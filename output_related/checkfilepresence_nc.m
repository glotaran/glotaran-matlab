function [typecheck] = checkfilepresence_nc(your_path)

% your_path = cd;
dir_struct = dir( fullfile(your_path,'*nc') );
if numel(dir_struct) == 0
    
  typecheck = 0;
%   display("then there are no files with extension pdf")
else
  display("there is a pdf file in your directory")
  typecheck = 1
  % dir_struct(1).name gives the file name of the first "pdf" file listed
end