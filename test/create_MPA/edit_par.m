clc; clear all ;
textfilename = 'test_parameter.txt';
A1 = regexp(fileread(textfilename),'\n','split');

%%
catch1 = find(contains(A1,'irf'))+1;
replacecatch1 = "- ['center',68.0]";
%
fid = fopen(textfilename);
str = textscan(fid,'%s','Delimiter','\n','CollectOutput',true);
fclose( fid );
str2 = str{1}(1:end);
fid = fopen(textfilename, 'w' );
%     fprintf(fid2,'%s\n', str{:});
%     fclose(fid2);
for jj = 1:catch1-1
    fprintf( fid, '%s\n', str2{jj} )
end

fprintf( fid, '%s\n', replacecatch1)

for jj =  catch1+1 : length(str2)
    fprintf( fid, '%s\n', str2{jj} );
end
fclose( fid );
%% 
catch2 = catch1 + 1;
replacecatch2 = "- ['width', 4]";
%
fid = fopen(textfilename);
str = textscan(fid,'%s','Delimiter','\n','CollectOutput',true);
fclose( fid );
str2 = str{1}(1:end)
fid = fopen(textfilename, 'w' );
%     fprintf(fid2,'%s\n', str{:});
%     fclose(fid2);
for jj = 1:catch2-1
    fprintf( fid, '%s\n', str2{jj} )
end

fprintf( fid, '%s\n', replacecatch2)

for jj =  catch2+1 : length(str2)
    fprintf( fid, '%s\n', str2{jj} );
end
fclose( fid );
%%
catch3 = find(contains(A1,'constant'))+1;
catch4 = catch3+1;
catch5 = catch4+1;


replacecatch3 = "- - cI12500";
fid = fopen(textfilename);
str = textscan(fid,'%s','Delimiter','\n','CollectOutput',true);
fclose( fid );
str2 = str{1}(1:end);
fid = fopen(textfilename, 'w' );
%     fprintf(fid2,'%s\n', str{:});
%     fclose(fid2);
for jj = 1:catch3-1
    fprintf( fid, '%s\n', str2{jj} )
end

fprintf( fid, '%s\n', replacecatch3)

for jj =  catch3+1 : length(str2)
    fprintf( fid, '%s\n', str2{jj} );
end
fclose( fid );
%%
catch3 = find(contains(A1,'constant'))+1;
catch4 = catch3+1;
replacecatch4 = '- 12800.0';
fid = fopen(textfilename);
str = textscan(fid,'%s','Delimiter','\n','CollectOutput',true);
fclose( fid );
str2 = str{1}(1:end);
fid = fopen(textfilename, 'w' );
%     fprintf(fid2,'%s\n', str{:});
%     fclose(fid2);
for jj = 1:catch4 - 1
    fprintf( fid, '%s\n', str2{jj} )
end

fprintf( fid, '%s\n', replacecatch4)

for jj =  catch4+1 : length(str2)
    fprintf( fid, '%s\n', str2{jj} );
end
fclose( fid );
%%
catch3 = find(contains(A1,'constant'))+1;
catch4 = catch3+1;
catch5 = catch4+1;

replacecatch5 = '- {vary: false}';
fid = fopen(textfilename);
str = textscan(fid,'%s','Delimiter','\n','CollectOutput',true);
fclose( fid );
str2 = str{1}(1:end);
fid = fopen(textfilename, 'w' );
%     fprintf(fid2,'%s\n', str{:});
%     fclose(fid2);
for jj = 1:catch5 - 1
    fprintf( fid, '%s\n', str2{jj} )
end

fprintf( fid, '%s\n', replacecatch5)

for jj =  catch5+1 : length(str2)
    fprintf( fid, '%s\n', str2{jj} );
end
fclose( fid );
%%