function[statusoptimize,cmdoptimize,full_filename_analysis,full_filename_output,file_output]= gta_optimize_cboxon(number,user_selected_fullpathname,full_filename_analysis_1)


%     [file_analysis,pathanalysis] = get_yamlfile('*.yaml')
full_filename_analysis = full_filename_analysis_1;
[file_output] = autocreate_folder(user_selected_fullpathname);
full_filename_output = fullfile(user_selected_fullpathname,file_output);

% [file_output,path_output] = uiputfile()
% full_filename_output = strcat(path_output,file_output)
% filename1 = '/home/avra/Desktop/analysisTet_TR2.yaml'
space = ' ';
n = '--nfev';
c1 = 'glotaran optimize';
c2 = '-y';
out = '-o';
number = num2str(num2str(number))
commandoptimize = [c1,space,full_filename_analysis,space,n,space,number,space,c2,space,out,space,full_filename_output,space]
[statusoptimize,cmdoptimize] = system(commandoptimize);

% save the analysis schema
ana_save_file = strcat(file_output,'_cmdoptimize.mat');
% ana_s_file = strcat('cmdoptimize',m);
% matfile = fullfile(full_filename_output,ana_save_file)
matfile = fullfile(user_selected_fullpathname,ana_save_file)
% matfile = fullfile(full_filename_output,'cmdoptimize.mat')
save (matfile, 'cmdoptimize')
% save (matfile, ana_s_file)
end
    
    
