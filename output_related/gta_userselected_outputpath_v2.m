function [user_selected_fullpathname,openname] = gta_userselected_outputpath()
% directory choice - creates .mat file keeping in track of latest output name 
% go2userchoice_output - navigates & seeks for presence of nc files

%%
% function[user_selected_filename,user_selected_fullpathname] = gta_userselected_outputpath()
% output form mldatx

% [user_selected_filename,user_selecteted_pathname] = uiputfile()
% cd (user_selecteted_pathname)
% mkdir(user_selected_filename)
% user_selected_fullpathname = fullfile(user_selecteted_pathname,user_selected_filename)
% fileattrib('D:/work/results','+h -w','','s')

%%
% if nargin == 1
%    [~,openname] = fileparts(user_selected_fullpathname);
%     cd (user_selected_fullpathname); 
% end
[user_selected_fullpathname] = uigetdir();
[~,openname] = fileparts(user_selected_fullpathname);
cd (user_selected_fullpathname);
%% if .m file ... 
m = 0;
save count.mat m;
% ny = dir('*.yaml');
% if size(d,1)>0
    
    
end