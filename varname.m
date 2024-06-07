clear all
close all
clc
% Load Lab position to update
%load('D:\Sun-PhD\Path of Onedrive\OneDrive - Imperial College London\PhD Report\Python_Code\MSK_model\Input\Lab_position.mat');

% locate 3D marker position folder 
folder_old = "D:\Sun-PhD\Path of Onedrive\OneDrive - Imperial College London\PhD Report\Python_Code\MSK_model\marker_old_proto\TRA";
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
load_mat = load(path);
trial_name = exp_name(1:end-4);
mat_file = load_mat.(trial_name);
clear load_mat