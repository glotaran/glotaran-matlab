
function [wavelength,time,lifetime,das,sas,normdas,normsas,lsv,rsv,fitdata,outdata,rms,conc,outfilename,kmat] = go2userchoice_output_v3(user_selected_fullpathname,user_tableselect)
% check for nc files in the selected folder , while using open project
% Work flow : 1. create project [user_selected_fullpathname] = gta_userselected_outputpath() 
%             2. [created_folder] = autocreate_folder(user_selected_fullpathname) 
%                 - creates a folder naming - output_m.mat
%             3. this function called when selecting the file from table
% it takes input from user_selected-table , and the pathname selected as
%  navigates to the path, look for nc files if not change directory and
%  read nc file in the user's given string
% input - user selected full pathname from the open project 
%         user selected table from the table 

%%
     user_tableselect = string(user_tableselect);
     pattern1 = ".nc";
  if ~endsWith(user_tableselect,pattern1)
        % no nc file here,cd to userselected folder
        pp = cd(fullfile(user_selected_fullpathname,user_tableselect));                 
        g = dir('*.nc');
        if size(g,1) == 0     % again checks for nc files
          cd(user_tableselect)
        g = dir('*.nc')
        end
        outfilename = g.name;
        pathname = g.folder;
        fullpathname = fullfile(pathname,outfilename);
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
 else
        % for nc files
        g = dir('*.nc');
        outfilename = g.name;
        pathname = g.folder;
        fullpathname = fullfile(pathname,outfilename);
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

end
     

    
    