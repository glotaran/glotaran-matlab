function[user_selected_filename,user_selected_fullpathname] = gta_userselected_outputpath()
% output form mldatx

[user_selected_filename,user_selecteted_pathname] = uiputfile()
cd (user_selecteted_pathname)
mkdir(user_selected_filename)

user_selected_fullpathname = fullfile(user_selecteted_pathname,user_selected_filename)
cd(user_selected_fullpathname)
m = 0;
save count.mat m;

end