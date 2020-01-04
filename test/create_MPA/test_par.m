clear all;
clc;
%% Excitation
strucp = struct();


%e.Excitation.a = struct()

% strucp.Excitation.C1 = 1;
% strucp.Excitation.C2 = 0;
% strucp.Excitation.C3 = 0;

% 
strucp.Excitation = [1 0 0] ;

%e.Excitation.a = 'ff'
% struc.input = 0
% struc.input.C3 = 0
% struc.input.vary = 'False'
% e.Excitation.non-negative = 'False'
% strucp.Excitation.vary = 'False'


%% irf
%struc.i = struct()
% c = char('centre')
% strucp.irf.center = [68]
% strucp.irf.width = 4
% strucp.irf.vary = 'true'
% strucp.irf = []
strucp.irf = [68 ;4];
% strucp.irf = 
% strcup.irf.width = 4
%%
%struc = struct()
% strucp.kinetic.C1 = [0.1];
% strucp.kinetic.C2 = 0.05
% strucp.kinetic.C3 = 0.002
% strucp.kinetic.vary = 'true'
strucp.kinetic = [0.1 0.05 0.002];
% strucp.kinetic(2,1) = 'T'
% strucp.kinetic.vary = 'True'
%%
strucp.constant = 12800;
% strucp.constant.vary = 'false'
%%
WriteYaml('test_parameter.yaml',strucp)
WriteYaml('test_parameter.txt',strucp)
edit_par
% type test_parameter.txt
%%
% WriteYaml('test1.yaml',strucp)