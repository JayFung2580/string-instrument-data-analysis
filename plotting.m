%% File loading 
clear all
close all
clc
% repeat for each participant 
% locate QTM 3D marker position folder
folder_old = "C:\Users\USER\Desktop\BMEY4\FYP\Partici02";
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
n_file = length(exp_list2);

%% structure initialise
Lab_position.Freq = 100;
Lab_position.Pilot8.str = [];
EMG_magstruct.Freq = 2000;
EMG_magstruct.Pilot8.str = [] ;
EMG_freqstruct.Freq = 2000;
EMG_freqstruct.Pilot8.str = [];
%% Trajectories 
for i = 3:n_file
    path2 = fullfile(path,exp_list2(i));
    f_name = exp_list2{i};
    load_mat = load(path2);
    trial_name = f_name(1:end-4); % file name in char 
    mat_file = load_mat.(trial_name);  % runs file in matlab through this 
    clear load_mat
    
    sz_cel = length(mat_file.Trajectories.Labeled.Labels);
    cnter =cell(sz_cel,2);

    for i = 1: sz_cel
        mat = mat_file.Trajectories.Labeled.Data(i,1:3,:);
        cnter{i,1} = mat_file.Trajectories.Labeled.Labels(i);
        nsamp = size(mat,3);
        s11 = reshape(mat, [3, nsamp]);
        cnter{i,2} = s11;
    end
    
    Lab_position.Pilot6.(trial_name) = cnter;

end
%% EMG Magnitude 
muscle_list = [{'FDP'}, {'FDS'}, {'EDC'}, {'EI'}, {'FPL'}, {'EPL'}, {'APL'}, {'APB'}, {'DI'}];
% NB: FDP is now at the end of list, 
sz_mus = length(muscle_list);
mag_cnter = cell(sz_mus,2);
addpath 'C:\Users\USER\Desktop\BMEY4\FYP\matlab analysis'
for j = 3:27
    path2 = fullfile(path,exp_list2(j));
    f_name = exp_list2{j};
    load_mat = load(path2);
    trial_name = f_name(1:end-4); % file name in char 
    mat_file = load_mat.(trial_name);  % runs file in matlab through this 
    clear load_mat
    n_samp = size(mat_file.Analog(2).Data,2);
    tx = (0:n_samp-1)./2000;
    
    n_emg = size(mat_file.Analog(2).Data,1); % was 40 for pilot 08, check if all muscles are loaded, not if change i/
    filter_emg =  [];
    
    % Initialize an array to store the results
    inx = nan(1, 13);  % Using NaN to mark the skipped indices
    for i = 1:n_emg/4
        % Skip index 6 to 8
        if i >= 6 && i <= 8
            continue;
        % Map index 9 to 6
        elseif i == 9
            inx = 6;
        % Map index 10 to 7
        elseif i == 10
            inx = 7;
        % Skip index 11
        elseif i == 11
            continue;
        % Map index 12 to 8
        elseif i == 12
            inx = 8;
        % Map index 13 to 9
        elseif i == 13
            inx = 9;
        else
            inx = i;
        end

        % For all other indices, set the index to the value itself
        emg_data =mat_file.Analog(2).Data(4*i-3,:);
        filter_emg= preprocess(emg_data,tx);
        EMG_magstruct.Pilot09.(trial_name).(muscle_list{inx})= filter_emg;%change back to inx for later pilots (15/4 - pilot7).
    end
   %EMG_magstruct.pilot8.(trial_name).(muscle_list{j-2}) = EMG_magstruct.Pilot8.(trial_name{j-2,:})
end 

%% normalised EMG magnitude table 
%dat_table  = zeros(7,9,'double');
% manually increment and rename file 
for k = 1:9
   dat_table(1,k) = max(EMG_magstruct.Pilot09.Pilot0940FlexRD_100MVC.(muscle_list{k}));
end 
mus_cols = dat_table'
% find max of each column (muscle) 
% % make new struct, then normalise with maximums 
% EMG_norm_magstruct.Freq = 2000;
% EMG_norm_magstruct.Pilot8.str = [] ;

%copy excel maximums here 
maximums = [237.0938362
457.5039539
1070.025437
930.5897511
505.5817756
412.3588719
971.3571222
363.9734501
482.8553857
]
%Normalise with maxs (load first) 
for l = 3:18
    path2 = fullfile(path,exp_list2(l));
    f_name = exp_list2{l};
    load_mat = load(path2);
    trial_name = f_name(1:end-4); % file name in char 
    mat_file = load_mat.(trial_name);  % runs file in matlab through this 
    clear load_mat
    for j  = 1:9 
        EMG_norm_magstruct.Pilot09.(trial_name).(muscle_list{j})= (EMG_magstruct.Pilot09.(trial_name).(muscle_list{j}))./maximums(j,1); 
    end 
end 
% average -> to excel -> SPSS
for j  = 1:9 
        norm_avgs(j,1) = mean(EMG_norm_magstruct.Pilot09.Pilot0940FlexRD_100MVC.(muscle_list{j}));
end

%% EMG Frequency 
% Median Freq 
muscle_list = [{'FDP'}, {'FDS'}, {'EDC'}, {'EI'}, {'FPL'}, {'EPL'}, {'APL'}, {'APB'}, {'DI'}];
sz_mus = length(muscle_list);
mag_cnter = cell(sz_mus,2);
addpath 'C:\Users\USER\Desktop\BMEY4\FYP\matlab analysis'
for k = 3:27
    path2 = fullfile(path,exp_list2(k));
    f_name = exp_list2{k};
    load_mat = load(path2);
    trial_name = f_name(1:end-4); % file name in char 
    mat_file = load_mat.(trial_name);  % runs file in matlab through this 
    clear load_mat

    n_samp = size(mat_file.Analog(2).Data,2);
    tx = (0:n_samp-1)./2000;
    
    n_emg = size(mat_file.Analog(2).Data,1);
    for i = 1:n_emg/4
        MedF_t = [];
        % Skip index 6 to 8
%         if i >= 6 && i <= 8
%             continue;
%         % Map index 9 to 6
%         elseif i == 9
%             inx = 6;
%         % Map index 10 to 7
%         elseif i == 10
%             inx = 7;
%         % Skip index 11
%         elseif i == 11
%             continue;
%         % Map index 12 to 8
%         elseif i == 12
%             inx = 8;
%         % Map index 13 to 9
%         elseif i == 13emg_data
%             inx = 9;
%         else
%             inx = i;
%         end
        emg_data = mat_file.Analog(2).Data(4*i-3,:);
        dum_mat = medf(emg_data,tx);
        % epoch generation 
        for i_t = 1:floor(max(tx))
            ind_time = find(tx >= i_t-1 & tx < i_t);
            MedF_t(i_t) = medfreq(emg_data(ind_time),2000,[25 450]);
        end
        time_plot = 1:floor(max(tx));
        EMG_freqstruct.Partici02.(trial_name).(muscle_list{i})= MedF_t;  %change back to inx for later pilots (15/4 - pilot7).
    end
end 
% %average to excel -> SPSS 
% for j  = 1:9 
%         norm_freq_avgs(j,1) = mean(EMG_freqstruct.Pilot09.Pilot0940FlexRD_100MVC.(muscle_list{j}));
% end
% plot(MedF_t')
% plot(filter_emg')
% legend('FDP', 'FDS', 'EDC', 'EI', 'FPL', 'EPL', 'APL', 'APB', 'DI') 