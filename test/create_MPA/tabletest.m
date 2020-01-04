clear all;clc;
Excitation = [{'1'},{'0'}];
Kinetic = [0.45,0.45];

% Height = [71;69;64;67;64];
% Weight = [176;163;131;133;119];
% BloodPressure = [124 93; 109 77; 125 83];

T = table(Excitation,Kinetic)
S = table2struct(T)
WriteYaml('table.yaml',S)
open table.yaml
!glotaran print -p 'table.yaml' 