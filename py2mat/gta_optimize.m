function[statusoptimize,cmdoptimize,full_filename_analysis,full_filename_output,file_output]= gta_optimize(number,user_selected_fullpathname)


    [file_analysis,pathanalysis] = get_yamlfile('*.yaml')
    full_filename_analysis = strcat(pathanalysis,file_analysis)

        
    [file_output] = autocreate_folder(user_selected_fullpathname)
    full_filename_output = fullfile(user_selected_fullpathname,file_output)

% [file_output,path_output] = uiputfile()
% full_filename_output = strcat(path_output,file_output)
% filename1 = '/home/avra/Desktop/analysisTet_TR2.yaml'

% progressbar(0)

space = ' '
n = '--nfev'
c1 = 'glotaran optimize';
c2 = '-y';
out = '-o';
% if number == 0
%     number == 1
% end

number = num2str(num2str(number))

commandoptimize = [c1,space,full_filename_analysis,space,n,space,number,space,c2,space,out,space,full_filename_output,space]
% progressbar(0.5)
[statusoptimize,cmdoptimize] = system(commandoptimize)
% progressbar(1)
end
    
    
