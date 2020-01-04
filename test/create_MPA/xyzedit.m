clc; clear all ;
textfilename = 'xyz_parameter.txt';
A1 = regexp(fileread(textfilename),'\n','split');


catch1 = find(contains(A1,'[1.0]'));
replacecatch1 = "- {'vary': False, 'non-negative': False}";
%
fid = fopen(textfilename);
str = textscan(fid,'%s','Delimiter','\n','CollectOutput',true);
fclose( fid );
str2 = str{1}(1:end)
fid = fopen(textfilename, 'w' );
%     fprintf(fid2,'%s\n', str{:});
%     fclose(fid2);
for jj = 1:catch1
    fprintf( fid, str2{jj} )
end

fprintf( fid, replacecatch1)

for jj =  catch1+1 : length(str2)
    fprintf( fid, '%s\n', str2{jj} );
end
fclose( fid );
% open 'xyz_parameter.txt'
copyfile 'xyz_parameter.txt' 'xyz_parameter2.yaml' 
open 'xyz_parameter2.yaml' 