function [created_folder] = autocreate_folder(user_selected_fullpathname)

path = cd(user_selected_fullpathname)


% g = dir( fullfile(path,'*.mldatx') )
% f = size(g,1)
load count.mat
m = m + 1;
save count.mat m;
created_folder = ['Output_' num2str(m)];

%new folder name
mkdir(created_folder)%create new folder

end