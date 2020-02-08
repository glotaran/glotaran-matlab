clc; clear all ;

analysisfile = 'xyz_analysis.yaml';
ana_content = ReadYaml(analysisfile);
modelifile = ana_content.model;
paramaterfile = ana_content.parameter;

%% if more than one file as input 
n = size(ana_content.data,1);
% for i = 1: n
%     
if n == 1
datafile = ana_content.data;
else 
    datafile = 'more than one dataset, need to be implemented';
end
%% 
