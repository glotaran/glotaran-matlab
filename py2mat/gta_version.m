function [status_version,cmd_version] = gta_version()
command = 'glotaran --version';
[status_version,cmd_version] = system(command,'-echo');
end