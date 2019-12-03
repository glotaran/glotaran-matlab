function [fileName,pp] = get_ncfile(filename)
persistent lastPath pathName
% If this is the first time running the function this session,
% Initialize lastPath to 0
if isempty(lastPath) 
    lastPath = 0;
end
% First time calling 'uigetfile', use the pwd
if lastPath == 0
    [fileName, pathName] = uigetfile('*.nc');
    pp = pathName;
% All subsequent calls, use the path to the last selected file
else
    [fileName, pathName] = uigetfile(strcat(lastPath,'*.nc'));
    pp = pathName;
end
% Use the path to the last selected file
% If 'uigetfile' is called, but no item is selected, 'lastPath' is not overwritten with 0
if pathName ~= 0
    lastPath = pathName;
end