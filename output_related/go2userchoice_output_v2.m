function [wavelength,time,lifetime,das,sas,normdas,normsas,lsv,rsv,fitdata,outdata,rms,conc,outfilename,kmat] = go2userchoice_output_v2(user_selected_fullpathname,user_tableselect)
        
     user_tableselect = string(user_tableselect)
     
     pattern1 = ".nc";   
     TF_nc = endsWith(user_tableselect,pattern1)
     pattern2 = ".mldatx";   
     TF_m = endsWith(user_tableselect,pattern2)
     pattern3 = ".ascii";   
     TF_ascii = endsWith(user_tableselect,pattern3)
         
     if TF_m == 1
        
        pp = cd(fullfile(user_selected_fullpathname))      
%         cd(user_tableselect)
        g = dir('*.nc')
        if size(g,1) == 0
            cd(user_tableselect)
            g = dir('*.nc')
        end
        outfilename = g.name;
        pathname = g.folder;
        fullpathname = fullfile(pathname,outfilename)
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
     
         if TF_nc == 1
                g = dir('*.nc')
                outfilename = g.name;
                pathname = g.folder;
        %%
                fullpathname = fullfile(pathname,outfilename)
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
end

%   user_selected_fullpathname  = '/Users/avra/Documents/glotaran-matlab/test/2.mldatx'
  