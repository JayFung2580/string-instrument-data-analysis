%% File loading 
clear all
close all
clc
% repeat for each participant 
% locate QTM 3D marker position folder
folder_old = "C:\Users\USER\Desktop\BMEY4\FYP\Pilot09";
info_dir = dir(folder_old);
exp_list = {info_dir.name};
ind1 = find(strcmp(exp_list,'.'));
ind2 = find(strcmp(exp_list,'..'));
exp_list([ind1,ind2]) = [];
[i_trial,sel_ok] = listdlg('Name',' Trial selection','PromptString','Select a trial',...
    'InitialValue',1,'SelectionMode','single',...
    'ListString',exp_list, 'ListSize',[300 400]);
exp_name = exp_list{i_trial};
path = fullfile(folder_old,exp_name);

info_dir2 = dir(path);
exp_list2 = {info_dir2.name};   
[i_trial,sel_ok] = listdlg('Name',' Trial selection','PromptString','Select a trial',...
    'InitialValue',1,'SelectionMode','single',...
    'ListString',exp_list2, 'ListSize',[300 400]);

exp_name_load = exp_list2{i_trial};
file_path = fullfile(folder_old,exp_name,exp_name_load)
load_mat = load(file_path);
trial_name = exp_name_load(1:end-4); % file name in char
mat_file = load_mat.(trial_name);  % runs file in matlab through this
clear load_mat
%% Tell the ration
Ration_FV = 10.1518;
target_force = 4.1391/ 2;
Volt_data = mat_file.Analog(1).Data-2;
F_pinchdata = Volt_data *Ration_FV;
n_time = length(Volt_data);
x_time = (1:n_time) / 100;

Fs = 1/mean(diff(x_time)); % Average sample rate
y = lowpass(F_pinchdata,6,Fs,'Steepness',0.85,'StopbandAttenuation',60);

lower_bound = target_force * 0.9;   
hold on
plot(x_time,y)
ylim([target_force *0.8 target_force *1.2])

plot(x_time,ones(n_time,1).*target_force)
plot(x_time,ones(n_time,1).*lower_bound)
%% Find the target hit for timer on
% First time signal >= target force
ind_high = find(y >= target_force);
ind_timer_on = min(ind_high);   
%% Find when the force < bound
ind_low = y < lower_bound;
figure
plot(ind_low) % find manually from graph 
% if drop less than target, then can recover for > 5 seconds, consider as
%ok, if not, Drop out.
ylim([-0.01 1.01])
%% time 
met = (5280-ind_timer_on)/100;