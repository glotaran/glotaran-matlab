function[statusoptimize,cmdoptimize,full_filename_analysis,full_filename_output,file_output]= gtaoptimize(number)

[file_analysis,pathanalysis] = get_yamlfile('*.yaml')
full_filename_analysis = strcat(pathanalysis,file_analysis)

[file_output,path_output] = uiputfile()
full_filename_output = strcat(path_output,file_output)
% filename1 = '/home/avra/Desktop/analysisTet_TR2.yaml'
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
[statusoptimize,cmdoptimize] = system(commandoptimize)
end
    
    
