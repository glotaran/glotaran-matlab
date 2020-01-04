clear all; clc;
strucm = struct();
strucm.type = 'kinetic-spectrum';
% strucm.initial_concentration.Excitation.compartments = [01 02 03]
strucm.initial_concentration.Excitation.compartments{1} = 'C1';
strucm.initial_concentration.Excitation.compartments{2} = 'C2';
strucm.initial_concentration.Excitation.compartments{3} = 'C3';
% strucm.initial_concentration.Excitation.parameters = [100 200 300]
strucm.initial_concentration.Excitation.parameters{1} = 'Excitation.1';
strucm.initial_concentration.Excitation.parameters{2} = 'Excitation.2';
strucm.initial_concentration.Excitation.parameters{3} = 'Excitation.3';
%%
% this needs to be corrected - 
strucm.K_matrix.k1.matrix.kinetic1 = ['C1','C2'];
strucm.K_matrix.k1.matrix.kinetic2 = ['C2','C3'];
strucm.K_matrix.k1.matrix.kinetic3 = ['C3','C3'];

%%
strucm.megacomplex.m1.k_matrix = '[k1]'; %need ['k1]

strucm.irf.irf1.backsweep = 'true';
strucm.irf.irf1.backsweep_period = 'irf.3';
strucm.irf.irf1.center = 'irf.1';

strucm.irf.irf1.width = 'irf.2';
strucm.irf.irf1.type = 'gaussian';

strucm.dataset.data_TR2.initial_concentration = 'Excitation';
strucm.dataset.data_TR2.megacomplex = '[m1]'; % ['m1']
strucm.dataset.data_TR2.irf = 'irf1';


%%

WriteYaml('xyz_model.yaml',strucm,0)
!glotaran print -m 'xyz_model.yaml'
% !glotaran validate -m 'xyz_model.yaml' -p 'xyz_parameter.yaml'
% open 'xyz_model.yaml'
