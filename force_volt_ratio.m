%% File loading 
clear all
close all
clc
% repeat for each participant 
% locate QTM 3D marker position folder
folder_old = "C:\Users\USER\Desktop\BMEY4\FYP\Pilot07";
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
%% Force-voltage ratio 
Volt_data = mat_file.Analog(1).Data-2;
Max_volt = max(Volt_data);
%Manually add from notes 
F_pinch_max =3.436;
Ratio_FV = F_pinch_max/Max_volt;