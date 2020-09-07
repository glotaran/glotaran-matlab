clear all;
clc;
%% Excitation
strucp.Excitation = [1; 0; 0];

strucp.irf = [68;4;12800] ;


% k
strucp.kinetic = [0.1; 0.05; 0.002];

%

WriteYaml('xyz_parameter.yaml',strucp,0)
% WriteYaml('xyz_parameter.txt',strucp,0)
open xyz_parameter.yaml
%% run

  !glotaran print -p 'xyz_parameter.yaml' 
  !glotaran validate -m examplemodel.yaml -p xyz_parameter.yaml
%   !glotaran validate -m xyz_model.yaml -p xyz_parameter.yaml
  !glotaran optimize xyz_analysis.yaml
%% error

% >An error occured during optimization: 
% 
% >Non-finite concentrations for K-Matrix 'k1':
% >{k_matrix.matrix_as_markdown}


% excitation need to be fixed
%- {'vary': False, 'non-negative': False}