% point extraction  

% sz_cel = length(Pilot0620FlexUD_Trial.Trajectories.Labeled.Labels);
% cnter =cell(sz_cel,2)
% 
% for i = 1: sz_cel
% mat = Pilot0620FlexUD_Trial.Trajectories.Labeled.Data(i,1:3,:);
% cnter{i,1} = Pilot0620FlexUD_Trial.Trajectories.Labeled.Labels(i);
% nsamp = size(mat,3);
% s11 = reshape(mat, [3, nsamp]);
% cnter{i,2} = s11;
% end
trial_name = fieldnames(Lab_position.Pilot6);
load("C:\Users\USER\Desktop\BMEY4\FYP\Pilot06\Pilot06_mat\Pilot06TRA_modi.mat");
% TRA trajectory calculation
% locate QTM 3D marker position folder
folder_old = "C:\Users\USER\Desktop\BMEY4\FYP\Pilot06";
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
    
for itrial = 1:9
%     if itrial == 5;
%         continue
%     end
    data = Lab_position.Pilot6.(trial_name{itrial});
    list = string(data(:,1));
    ind1 = find(strcmp(list,ptc1_name));
    ind2 = find(strcmp(list,ptc2_name));
    ind3 = find(strcmp(list,ptc3_name));
    
    ptc1_modi = data{ind1,2}';
    ptc2_modi = data{ind2,2}';
    ptc3_modi = data{ind3,2}';
%TRA
Final_pts = []; 
TRA_cosys = [];
for it = 1:size(ptc3_modi,1)
 Y_dum = ptc2_modi(it,:) - ptc1_modi(it,:);
    y_ax = Y_dum ./ norm(Y_dum);
    dum_vec = ptc3_modi(it,:) - ptc1_modi(it,:);
    X_dum = cross(dum_vec,y_ax);
    x_ax = X_dum ./ norm(X_dum);
    z_ax = cross(x_ax,y_ax);
    Cosys_t = [x_ax' y_ax' z_ax' ptc1_modi(it,:)';0 0 0 1];

    TRA_cosys(:,it) = Cosys_t * [Target_pts;1];  % TRA transition matrix 
end
Final_pts = TRA_cosys(1:3,:); % xyz coords 
Lab_position.Pilot6.(trial_name{itrial}){end+1,1} = "TRA";
Lab_position.Pilot6.(trial_name{itrial}){end,2}=Final_pts;
end
