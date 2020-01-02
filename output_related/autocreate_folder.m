function [created_folder] = autocreate_folder(user_selected_fullpathname)
%% create folder for output - based on the count.mat file variable
% 

path = cd(user_selected_fullpathname);
load count.mat;
m = m + 1;
save count.mat m;
created_folder = ['Output_' num2str(m)];
%new folder name
mkdir(created_folder);

end