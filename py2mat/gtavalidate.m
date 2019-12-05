function[status,cmdout0]= gtavalidate(filename1,filename2)
[filem,pathm] = testUigetfile_yml('*.yaml')
filename1 = strcat(pathm,filem)

[filep,pathp] = testUigetfile_yml('*.yaml')
filename2 = strcat(pathp,filep)

space = ' '
c1 = 'glotaran validate -m';
c2 = '-p';

command = [c1,space,filename1,space,c2,space,filename2]
[status,cmdout0] = system(command,'-echo')
end