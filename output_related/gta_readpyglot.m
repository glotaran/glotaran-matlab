          
function [wavelength,time,lifetime,das,sas,normdas,normsas,lsv,rsv,fitdata,outdata,rms,conc,outfilename,kmat] = gta_readpyglot(varargin)
[outfilename,path] = get_ncfile('*.nc');
fullpathname = [path outfilename];
    if isequal(outfilename,0) || isequal(path,0)
        return
    end

% mac issue - still need to make all files check on
if isfolder(fullpathname)
    f = fullfile(fullpathname,'/*.' )
   [outfilename,path] = uigetfile(f)
   fullpathname = strcat(path,outfilename);
end

ncdisp (fullpathname); 
nc_header = ncinfo(fullpathname);
variable_names = {nc_header.Variables.Name};
supported_variables = ~contains({nc_header.Variables.Datatype},'UNSUPPORTED');
variables_to_load = variable_names(supported_variables);
attributes = cell2mat({nc_header.Attributes}) ;
data_struct = struct();   
for j=1:numel(variables_to_load)
   var = variables_to_load{j};
   data_struct.(var) = ncread(fullpathname,var);
end

% sw_x = isempty(data_struct);
% switch sw_x
% 
%     case 0 
%         app.StatusLamp.Color = 'green';
% 
%     case 1
%         app.StatusLamp.Color = 'red';      
% end
    if isfield(data_struct,'center_dispersion_1')
       app.dispersion_1 = data_struct.center_dispersion_1;
    end


wavelength = data_struct.spectral;
time = data_struct.time;
lifetime = num2cellstr(-data_struct.lifetime);
das = data_struct.decay_associated_spectra;
    for i=1:size(das,1);
        das_max = max(abs(das(i,:)));
        normdas(i,:) = das(i,:) / das_max;
    end
sas = data_struct.species_associated_spectra;
    for i=1:size(sas,1);
        sas_max = max(abs(sas(i,:)));
        normsas(i,:) = sas(i,:) / sas_max;
    end
 lsv_f = data_struct.residual_left_singular_vectors;
 rsv_f = data_struct.residual_right_singular_vectors;   
 lsv = lsv_f(1:2,:);
 rsv = rsv_f(:,1:2);
 fitdata = data_struct.fitted_data;
 outdata = data_struct.data;
 rms = num2str(attributes.Value);
 conc = data_struct.species_concentration;
 kmat = data_struct.k_matrix;
end
% app.conc = data_struct.species_concentration; %need to correct
% app.data = data_struct.data;
% app.fitdata = data_struct.fitted_data;
% app.lsv = data_struct.residual_left_singular_vectors;
% app.rsv = data_struct.residual_right_singular_vectors;
% app.residual = data_struct.residual;
% app.kmat = data_struct.k_matrix;
% app.path = filename;
% app.RMS = num2str(attributes.Value);    
% % app.lifetime = num2cellstr(app.lifetime)';
% app.FeedbackTextArea.Value = fullpathname;