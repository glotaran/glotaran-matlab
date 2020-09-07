% function 
clear all; clc ; close all;
matfile = 'Output_8_cmdoptimize.mat';
res_opt = load(matfile);
DataField = fieldnames(res_opt);
textfile = erase(matfile,'.mat');
textfilename = strcat(textfile,'.txt');
% textfile created
writematrix(res_opt.(DataField{1}),textfilename,'Delimiter','tab')
% look for the line numbers which will give the iterations details
A1 = regexp(fileread(textfilename),'\n','split');
start = find(contains(A1,'Iteration'))+1;
upto = find(contains(A1,'maximum')) - 1;
    if isempty(upto)
        upto = find(contains(A1,'termination')) - 1;
    end
% reopen the textfile
fid = fopen(textfilename,'r');
str = textscan(fid,'%s','Delimiter','\n');
fclose(fid);
str2 = str{1}(start:upto); 

%% Save as a new text file
textfile2 = strcat(textfile,'final','.txt');
fid2 = fopen(textfile2,'w');
fprintf(fid2,'%s\n', str2{:});
fclose(fid2);
A2 = dlmread(textfile2);
%% plot
plot(A2(:,2),log10(A2(:,3)),'k','Marker','o','LineWidth',1.5,'MarkerEdgeColor','k','MarkerSize',10,'MarkerFaceColor','k');
title('Iterational changes');
xlabel('Iterations');
ylabel('Cost');
legend(strcat('Total Iterations-',num2str(size(A2,1))))