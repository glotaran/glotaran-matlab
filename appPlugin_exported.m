classdef appPlugin_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        FileButton             matlab.ui.control.Button
        StatusLampLabel        matlab.ui.control.Label
        StatusLamp             matlab.ui.control.Lamp
        TabGroup               matlab.ui.container.TabGroup
        Parallel_Model         matlab.ui.container.Tab
        PlotButton             matlab.ui.control.Button
        UIAxes                 matlab.ui.control.UIAxes
        UIAxes2                matlab.ui.control.UIAxes
        Sequential_Model       matlab.ui.container.Tab
        UIAxes3                matlab.ui.control.UIAxes
        UIAxes4                matlab.ui.control.UIAxes
        PlotButton_2           matlab.ui.control.Button
        Residual_Conc_profile  matlab.ui.container.Tab
        UIAxes5                matlab.ui.control.UIAxes
        UIAxes6                matlab.ui.control.UIAxes
        UIAxes7                matlab.ui.control.UIAxes
        UIAxes8                matlab.ui.control.UIAxes
        ResultsButton          matlab.ui.control.Button
    end


   properties (Access = public)
        das 
        sas
        wavelength
        time        
        conc
        data
        fitdata
        lsv
        rsv
        residual  % Description
    end

    


    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: FileButton
        function FileButtonPushed(app, event)
            
           [filename,path] = uigetfile('*.nc');
           fullpathname = strcat(path,filename);
              
             fullpathname = strcat(path,filename);
             ncdisp (filename); % info regarding the file
             nc_header = ncinfo(filename);
             variable_names = {nc_header.Variables.Name};
             supported_variables = ~contains({nc_header.Variables.Datatype},'UNSUPPORTED');
             variables_to_load = variable_names(supported_variables);
             
             data_struct = struct(); %structure array 
 
 % loop over the variables and putting them into a data_strucure for later 
            for j=1:numel(variables_to_load)
               % extract the jth variable (type = string)
               var = variables_to_load{j}
             % use dynamic field name to add this to the structure
               data_struct.(var) = ncread(filename,var);
            
               % convert from single to double, if that matters to you (it does to me)
               if isa(data_struct.(var),'single')
                   data_struct.(var) = double(data_struct.(var));
               end
            end
            if numel(fields(data_struct)) == numel(cell(variables_to_load))
                    app.StatusLamp.Color = 'green';
                    
                else
                    app.StatusLamp.Color = 'red';
                    
                end
                                  
            app.wavelength = data_struct.spectral;
            app.time = data_struct.time;

            app.das = data_struct.decay_associated_spectra;
            app.sas = data_struct.species_associated_spectra;
            app.conc = data_struct.species_concentration; %need to correct
            app.data = data_struct.data;
            app.fitdata = data_struct.fitted_data;
            app.lsv = data_struct.residual_left_singular_vectors;
            app.rsv = data_struct.residual_right_singular_vectors;
            app.residual = data_struct.residual;

        end

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)


           %smoothening the spectras 
           dastra = app.das';
          
           dassm = smooth(dastra,'sgolay');
           dasr= reshape(dassm,[size(dastra,1),size(dastra,2)]);
           app.das= dasr';  %final das after smoothening 
            for i=1:size(app.das,1)
                das_max = max(abs(app.das(i,:)));
                normdas(i,:) = app.das(i,:) / das_max;
            end
              plot(app.UIAxes,app.wavelength,app.das)
            plot(app.UIAxes2,app.wavelength,normdas)
        end

        % Button pushed function: PlotButton_2
        function PlotButton_2Pushed(app, event)
           
        sastra = app.sas';
        sassm = smooth(sastra,'sgolay');
        sasr= reshape(sassm,[size(sastra,1),size(sastra,2)]);
        app.sas= sasr'; %final das after smootheninh
                for i=1:size(app.sas,1)
            sas_max = max(app.sas(i,:));
            normsas(i,:) = app.sas(i,:) / sas_max;
        %     normsas(i,:)=locmax(spectra,normsas(i,:));
                end
            plot(app.UIAxes3,app.wavelength,app.sas)
            plot(app.UIAxes4,app.wavelength,normsas)
        end

        % Button pushed function: ResultsButton
        function ResultsButtonPushed(app, event)
            

                  kin= app.conc(:,:,1);
                  LSV_cut = app.lsv(1:2,:);
                 RSV_cut = app.rsv(:,1:2);
                  
            plot(app.UIAxes8,app.time,LSV_cut')
            plot(app.UIAxes7,app.wavelength,RSV_cut')
            plot(app.UIAxes5,app.time,kin)
            imagesc(app.UIAxes6,app.time,app.wavelength,app.residual);
            
 
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create FileButton
            app.FileButton = uibutton(app.UIFigure, 'push');
            app.FileButton.ButtonPushedFcn = createCallbackFcn(app, @FileButtonPushed, true);
            app.FileButton.Position = [10 455 100 22];
            app.FileButton.Text = 'File';

            % Create StatusLampLabel
            app.StatusLampLabel = uilabel(app.UIFigure);
            app.StatusLampLabel.HorizontalAlignment = 'right';
            app.StatusLampLabel.VerticalAlignment = 'top';
            app.StatusLampLabel.FontWeight = 'bold';
            app.StatusLampLabel.Position = [119 459 42 15];
            app.StatusLampLabel.Text = 'Status';

            % Create StatusLamp
            app.StatusLamp = uilamp(app.UIFigure);
            app.StatusLamp.Enable = 'off';
            app.StatusLamp.Position = [176 456 20 20];
            app.StatusLamp.Color = [1 1 0];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [10 12 621 434];

            % Create Parallel_Model
            app.Parallel_Model = uitab(app.TabGroup);
            app.Parallel_Model.Title = 'Parallel_Model';

            % Create PlotButton
            app.PlotButton = uibutton(app.Parallel_Model, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.FontAngle = 'italic';
            app.PlotButton.Position = [19 349 100 22];
            app.PlotButton.Text = 'Plot';

            % Create UIAxes
            app.UIAxes = uiaxes(app.Parallel_Model);
            title(app.UIAxes, 'Decay-associated spectra')
            xlabel(app.UIAxes, 'Wavelength (nm)')
            ylabel(app.UIAxes, 'DAS')
            app.UIAxes.FontName = 'Times New Roman';
            app.UIAxes.FontAngle = 'italic';
            app.UIAxes.FontWeight = 'bold';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [141 201 300 185];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.Parallel_Model);
            title(app.UIAxes2, 'Decay-associated spectra Norm')
            xlabel(app.UIAxes2, 'Wavelength')
            ylabel(app.UIAxes2, 'DAS Norm')
            app.UIAxes2.FontName = 'Times New Roman';
            app.UIAxes2.FontAngle = 'italic';
            app.UIAxes2.FontWeight = 'bold';
            app.UIAxes2.YGrid = 'on';
            app.UIAxes2.Position = [141 1 300 185];

            % Create Sequential_Model
            app.Sequential_Model = uitab(app.TabGroup);
            app.Sequential_Model.Title = 'Sequential_Model';

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.Sequential_Model);
            title(app.UIAxes3, 'Title')
            xlabel(app.UIAxes3, 'X')
            ylabel(app.UIAxes3, 'Y')
            app.UIAxes3.Box = 'on';
            app.UIAxes3.Position = [161 203 300 185];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.Sequential_Model);
            title(app.UIAxes4, 'Title')
            xlabel(app.UIAxes4, 'X')
            ylabel(app.UIAxes4, 'Y')
            app.UIAxes4.Box = 'on';
            app.UIAxes4.Position = [161 1 300 185];

            % Create PlotButton_2
            app.PlotButton_2 = uibutton(app.Sequential_Model, 'push');
            app.PlotButton_2.ButtonPushedFcn = createCallbackFcn(app, @PlotButton_2Pushed, true);
            app.PlotButton_2.Position = [10 366 100 22];
            app.PlotButton_2.Text = 'Plot';

            % Create Residual_Conc_profile
            app.Residual_Conc_profile = uitab(app.TabGroup);
            app.Residual_Conc_profile.Title = 'Res';

            % Create UIAxes5
            app.UIAxes5 = uiaxes(app.Residual_Conc_profile);
            title(app.UIAxes5, 'Concentration profile')
            xlabel(app.UIAxes5, 'X')
            ylabel(app.UIAxes5, 'Y')
            app.UIAxes5.Position = [9 216 300 185];

            % Create UIAxes6
            app.UIAxes6 = uiaxes(app.Residual_Conc_profile);
            title(app.UIAxes6, 'Title')
            xlabel(app.UIAxes6, 'X')
            ylabel(app.UIAxes6, 'Y')
            app.UIAxes6.Position = [308 216 300 185];

            % Create UIAxes7
            app.UIAxes7 = uiaxes(app.Residual_Conc_profile);
            title(app.UIAxes7, 'Title')
            xlabel(app.UIAxes7, 'X')
            ylabel(app.UIAxes7, 'Y')
            app.UIAxes7.Position = [9 15 300 185];

            % Create UIAxes8
            app.UIAxes8 = uiaxes(app.Residual_Conc_profile);
            title(app.UIAxes8, 'Title')
            xlabel(app.UIAxes8, 'X')
            ylabel(app.UIAxes8, 'Y')
            app.UIAxes8.Position = [308 15 300 185];

            % Create ResultsButton
            app.ResultsButton = uibutton(app.Residual_Conc_profile, 'push');
            app.ResultsButton.ButtonPushedFcn = createCallbackFcn(app, @ResultsButtonPushed, true);
            app.ResultsButton.Position = [268 1 86 22];
            app.ResultsButton.Text = 'Results';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = appPlugin_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end