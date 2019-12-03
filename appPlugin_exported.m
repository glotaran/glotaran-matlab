classdef appPluginbackup_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        Pyglotaran_Plugin      matlab.ui.Figure
        FileButton             matlab.ui.control.Button
        StatusLampLabel        matlab.ui.control.Label
        StatusLamp             matlab.ui.control.Lamp
        TabGroup               matlab.ui.container.TabGroup
        Parallel_Model         matlab.ui.container.Tab
        PlotButton             matlab.ui.control.Button
        UIAxes                 matlab.ui.control.UIAxes
        UIAxes2                matlab.ui.control.UIAxes
        SmoothDASSwitchLabel   matlab.ui.control.Label
        SmoothDASSwitch        matlab.ui.control.Switch
        CheckMaximaButton      matlab.ui.control.Button
        Sequential_Model       matlab.ui.container.Tab
        UIAxes3                matlab.ui.control.UIAxes
        UIAxes4                matlab.ui.control.UIAxes
        PlotButton_2           matlab.ui.control.Button
        SmoothSASSwitchLabel   matlab.ui.control.Label
        SmoothSASSwitch        matlab.ui.control.Switch
        Residual_Conc_profile  matlab.ui.container.Tab
        UIAxes5                matlab.ui.control.UIAxes
        UIAxes6                matlab.ui.control.UIAxes
        UIAxes7                matlab.ui.control.UIAxes
        UIAxes8                matlab.ui.control.UIAxes
        ResultsButton          matlab.ui.control.Button
        Nodal_DiagramTab       matlab.ui.container.Tab
        UIAxes13               matlab.ui.control.UIAxes
        ModelButton            matlab.ui.control.Button
        PressenterafteryoufillupclickonmodelEditFieldLabel  matlab.ui.control.Label
        PressenterafteryoufillupclickonmodelEditField  matlab.ui.control.EditField
        PleaseenterthenamesofyourcompartmentLabel  matlab.ui.control.Label
        TracesTab              matlab.ui.container.Tab
        SlicetraceButton       matlab.ui.control.Button
        EnternooftraceshitSlicetraceEditFieldLabel  matlab.ui.control.Label
        EnternooftraceshitSlicetraceEditField  matlab.ui.control.NumericEditField
        UIAxes14               matlab.ui.control.UIAxes
        TheoutputoftracewillbeinanewwindowWavelengthnmasyaxisLabel  matlab.ui.control.Label
        SliderLabel            matlab.ui.control.Label
        Slider                 matlab.ui.control.Slider
        Comparision_DataTab    matlab.ui.container.Tab
        UIAxes9                matlab.ui.control.UIAxes
        UIAxes11               matlab.ui.control.UIAxes
        Button                 matlab.ui.control.Button
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
        residual 
        txt2 
        kmat 
        
          % call within other methods
    end

    

    
    methods (Access = public)
        %not working
        function locmax(app,wavelength,das)
                        
                [das_max,idx]= max(das);
                wavelength_max = wavelength(idx,1);
                txt = num2str(das_max,4);%Precision upto 4 digits 
                txt2 = num2str(wavelength_max,3);
                txt2
%                 t=text(app.UIAxes2,app.wavelength_max,app.das_max,txt2,'Color','black','FontSize',10);
            
        end
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: FileButton
        function FileButtonPushed(app, event)
         % read the files and push the variables into properties   
           [filename,path] = uigetfile('*.nc');
           fullpathname = strcat(path,filename);
              
           fullpathname = strcat(path,filename);
%              ncdisp (filename); % info regarding the file
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
            app.kmat = data_struct.k_matrix;

        end

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)

              normdas = [];
           %smoothening the spectras 
%            dastra = app.das';
          
%            dassm = smooth(dastra,'sgolay');
%            dasr= reshape(dassm,[size(dastra,1),size(dastra,2)]);
%            app.das= dasr';  %final das after smoothening 
            for i=1:size(app.das,1)
                das_max = max(abs(app.das(i,:)));
                normdas(i,:) = app.das(i,:) / das_max;
            end
              plot(app.UIAxes,app.wavelength,app.das)
            plot(app.UIAxes2,app.wavelength,normdas)
        end

        % Button pushed function: PlotButton_2
        function PlotButton_2Pushed(app, event)
            normsas =[];
            
%         sastra = app.sas';
%         sassm = smooth(sastra,'sgolay');
%         sasr= reshape(sassm,[size(sastra,1),size(sastra,2)]);
%         app.sas= sasr'; %final das after smootheninh
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

        % Value changed function: SmoothSASSwitch
        function SmoothSASSwitchValueChanged(app, event)
            value = app.SmoothSASSwitch.Value;
           SmoothSwitchValue = app.SmoothSASSwitch.Value;
            if ( strcmpi(SmoothSwitchValue,'on') )
                %app.functionA;
            sastra = app.sas';
        sassm = smooth(sastra,'sgolay');
        sasr= reshape(sassm,[size(sastra,1),size(sastra,2)]);
        sassm= sasr'; %final das after smootheninh
                for i=1:size(app.sas,1)
            sas_max = max(sassm(i,:));
            smnormsas(i,:) = sassm(i,:) / sas_max;
              end
            plot(app.UIAxes3,app.wavelength,sassm)
            plot(app.UIAxes4,app.wavelength,smnormsas)
            
            else
%                 app.functionB;
                      for i=1:size(app.sas,1)
            sas_max = max(app.sas(i,:));
            normsas(i,:) = app.sas(i,:) / sas_max;
        %     normsas(i,:)=locmax(spectra,normsas(i,:));
                end
            plot(app.UIAxes3,app.wavelength,app.sas)
            plot(app.UIAxes4,app.wavelength,normsas) 
            end
            
           
        end

        % Value changed function: SmoothDASSwitch
        function SmoothDASSwitchValueChanged(app, event)
            normdas =[];
            dassm =[];
            value = app.SmoothDASSwitch.Value;
            SmoothDASSwitchValue = app.SmoothDASSwitch.Value;
            if ( strcmpi(SmoothDASSwitchValue,'on') )
                %app.functionA;
            dastra = app.das';
            dassm = smooth(dastra,'sgolay');
            dasrsm = reshape(dassm,[size(dastra,1),size(dastra,2)]);
            dassm = dasrsm';    %final das after smootheninh
                for i=1:size(app.das,1)
            smdas_max = max(abs(dassm(i,:)));
            smnormdas(i,:) = dassm(i,:) / smdas_max;
                end
            plot(app.UIAxes,app.wavelength,dassm)
            plot(app.UIAxes2,app.wavelength,smnormdas)
            
            else
                
                for i=1:size(app.das,1)
            das_max = max(abs(app.das(i,:)));
            normdas(i,:) = app.das(i,:) / das_max;
        %     normsas(i,:)=locmax(spectra,normsas(i,:));
                      end
            plot(app.UIAxes,app.wavelength,app.das)
            plot(app.UIAxes2,app.wavelength,normdas) 
            end
        end

        % Button pushed function: CheckMaximaButton
        function CheckMaximaButtonPushed(app, event)
         locmax(app,app.wavelength,app.das)  
          

          text(app.UIAxes2,app.wavelength,app.das,txt2,'Color','black','FontSize',10);



        end

        % Button pushed function: ModelButton
        function ModelButtonPushed(app, event)
 
          
            value = app.PressenterafteryoufillupclickonmodelEditField.Value;
%            if species = [];
%               disp ('fill your compartments') 
%            end
            species = strsplit(value);

            [C2,C1,rates] =find (app.kmat);
            
            G = digraph(C1,C2,rates,species);
            H =plot(app.UIAxes13,G,'Layout','circle','EdgeLabel',G.Edges.Weight);
%             layout(H,'layered','Direction','down');
            highlight(H,[1:size(species,2)],'Marker','o','MarkerSize',25)
            highlight(H,[1:size(species,2)],'NodeColor',[0.4660 0.6740 0.1880])
        
        end

        % Button pushed function: SlicetraceButton
        function SlicetraceButtonPushed(app, event)
%              Number = 0;
%     a = app.EnternooftraceshitSlicetraceEditField.Value;
%             aConverted = a;
%             aConverted = Number
            a = app.EnternooftraceshitSlicetraceEditField.Value;
            aConverted = a
            Number = round(a);

            x= sqrt(Number);
            sqc= ceil(x);  
            
            Lin = size(app.data,1)/Number;
               Lin_r = round(Lin);
               for i= 1:size(app.fitdata,1) %fitdata
        
                storefitdata_row{i} = app.fitdata(i,[1:size(app.fitdata,2)]);   
                   end
                for  d = 1:size(app.data,1) %data
                
                storedata_row{d} = app.data(d,[1:size(app.data,2)]);   
                   end
            
               trace_list = 1:Lin_r:size(app.fitdata,1);
                
               g = uigridlayout([sqc,sqc])
               for k = 1:Number 
                   n = trace_list(k)   %trace_list(k);
                            
                ax = uiaxes(g);
                ax.Layout.Row = ceil((k-0.5)/sqc);
                ax.Layout.Column = k-(ax.Layout.Row-1)*sqc;       
                plot(ax,app.time,storefitdata_row{n},'red')
                hold (ax,'on')
                plot(ax,app.time,storedata_row{n},'k --');
                wa = num2str(app.wavelength(n),5);
                hold (ax,'off')
                legend(ax,'fit','data');
                xlabel (ax,'time (ns) '); ylabel(ax,wa);
               

            end
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
       imagesc(app.UIAxes9,app.wavelength,app.time,app.data');   
       imagesc(app.UIAxes11,app.wavelength,app.time,app.fitdata'); 
        end

        % Value changed function: 
        % PressenterafteryoufillupclickonmodelEditField
        function PressenterafteryoufillupclickonmodelEditFieldValueChanged(app, event)
            value = app.PressenterafteryoufillupclickonmodelEditField.Value;
            species = strsplit(value)
            
% [app.value,matches] = strsplit(str,{' ','ain'},'CollapseDelimiters',true)
        end

        % Value changed function: 
        % EnternooftraceshitSlicetraceEditField
        function EnternooftraceshitSlicetraceEditFieldValueChanged(app, event)
            a = app.EnternooftraceshitSlicetraceEditField.Value;
            aConverted = a
            %double(strsplit(a,','));
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create Pyglotaran_Plugin and hide until all components are created
            app.Pyglotaran_Plugin = uifigure('Visible', 'off');
            app.Pyglotaran_Plugin.AutoResizeChildren = 'off';
            app.Pyglotaran_Plugin.Position = [100 100 640 480];
            app.Pyglotaran_Plugin.Name = 'UI Figure';

            % Create FileButton
            app.FileButton = uibutton(app.Pyglotaran_Plugin, 'push');
            app.FileButton.ButtonPushedFcn = createCallbackFcn(app, @FileButtonPushed, true);
            app.FileButton.Position = [10 455 100 22];
            app.FileButton.Text = 'File';

            % Create StatusLampLabel
            app.StatusLampLabel = uilabel(app.Pyglotaran_Plugin);
            app.StatusLampLabel.HorizontalAlignment = 'right';
            app.StatusLampLabel.VerticalAlignment = 'top';
            app.StatusLampLabel.FontWeight = 'bold';
            app.StatusLampLabel.Position = [119 459 42 15];
            app.StatusLampLabel.Text = 'Status';

            % Create StatusLamp
            app.StatusLamp = uilamp(app.Pyglotaran_Plugin);
            app.StatusLamp.Enable = 'off';
            app.StatusLamp.Position = [176 456 20 20];
            app.StatusLamp.Color = [1 1 0];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.Pyglotaran_Plugin);
            app.TabGroup.AutoResizeChildren = 'off';
            app.TabGroup.Position = [10 12 621 434];

            % Create Parallel_Model
            app.Parallel_Model = uitab(app.TabGroup);
            app.Parallel_Model.AutoResizeChildren = 'off';
            app.Parallel_Model.Title = 'Parallel_Model';

            % Create PlotButton
            app.PlotButton = uibutton(app.Parallel_Model, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.FontAngle = 'italic';
            app.PlotButton.Position = [19 349 100 22];
            app.PlotButton.Text = 'Plot';

            % Create UIAxes
            app.UIAxes = uiaxes(app.Parallel_Model);
            title(app.UIAxes, 'Decay-associated spectra (DAS)')
            xlabel(app.UIAxes, 'Wavelength (nm)')
            ylabel(app.UIAxes, 'DAS')
            app.UIAxes.FontName = 'Times New Roman';
            app.UIAxes.FontAngle = 'italic';
            app.UIAxes.FontWeight = 'bold';
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [141 201 300 185];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.Parallel_Model);
            title(app.UIAxes2, 'Decay-associated spectra Norm')
            xlabel(app.UIAxes2, 'Wavelength (nm)')
            ylabel(app.UIAxes2, 'DAS Norm')
            app.UIAxes2.FontName = 'Times New Roman';
            app.UIAxes2.FontAngle = 'italic';
            app.UIAxes2.FontWeight = 'bold';
            app.UIAxes2.XGrid = 'on';
            app.UIAxes2.YGrid = 'on';
            app.UIAxes2.Position = [141 5 300 185];

            % Create SmoothDASSwitchLabel
            app.SmoothDASSwitchLabel = uilabel(app.Parallel_Model);
            app.SmoothDASSwitchLabel.HorizontalAlignment = 'center';
            app.SmoothDASSwitchLabel.Position = [32 273 75 22];
            app.SmoothDASSwitchLabel.Text = 'Smooth DAS';

            % Create SmoothDASSwitch
            app.SmoothDASSwitch = uiswitch(app.Parallel_Model, 'slider');
            app.SmoothDASSwitch.ValueChangedFcn = createCallbackFcn(app, @SmoothDASSwitchValueChanged, true);
            app.SmoothDASSwitch.Position = [46 310 45 20];

            % Create CheckMaximaButton
            app.CheckMaximaButton = uibutton(app.Parallel_Model, 'push');
            app.CheckMaximaButton.ButtonPushedFcn = createCallbackFcn(app, @CheckMaximaButtonPushed, true);
            app.CheckMaximaButton.Position = [492 349 100 22];
            app.CheckMaximaButton.Text = {'Check Maxima'; ''};

            % Create Sequential_Model
            app.Sequential_Model = uitab(app.TabGroup);
            app.Sequential_Model.AutoResizeChildren = 'off';
            app.Sequential_Model.Title = 'Compartmental_Model';

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.Sequential_Model);
            title(app.UIAxes3, 'Species-associated spectra (SAS)')
            xlabel(app.UIAxes3, 'Wavelength (nm)')
            ylabel(app.UIAxes3, 'SAS')
            app.UIAxes3.FontAngle = 'italic';
            app.UIAxes3.FontWeight = 'bold';
            app.UIAxes3.Box = 'on';
            app.UIAxes3.XGrid = 'on';
            app.UIAxes3.YGrid = 'on';
            app.UIAxes3.Position = [161 203 300 185];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.Sequential_Model);
            title(app.UIAxes4, 'Species-associated spectra (norm)')
            xlabel(app.UIAxes4, 'Wavelength (nm)')
            ylabel(app.UIAxes4, 'SAS')
            app.UIAxes4.FontAngle = 'italic';
            app.UIAxes4.FontWeight = 'bold';
            app.UIAxes4.YLim = [0 1.2];
            app.UIAxes4.Box = 'on';
            app.UIAxes4.XGrid = 'on';
            app.UIAxes4.YGrid = 'on';
            app.UIAxes4.Position = [161 1 300 185];

            % Create PlotButton_2
            app.PlotButton_2 = uibutton(app.Sequential_Model, 'push');
            app.PlotButton_2.ButtonPushedFcn = createCallbackFcn(app, @PlotButton_2Pushed, true);
            app.PlotButton_2.Position = [10 366 100 22];
            app.PlotButton_2.Text = 'Plot';

            % Create SmoothSASSwitchLabel
            app.SmoothSASSwitchLabel = uilabel(app.Sequential_Model);
            app.SmoothSASSwitchLabel.HorizontalAlignment = 'center';
            app.SmoothSASSwitchLabel.Position = [23.5 287 74 22];
            app.SmoothSASSwitchLabel.Text = {'Smooth SAS'; ''};

            % Create SmoothSASSwitch
            app.SmoothSASSwitch = uiswitch(app.Sequential_Model, 'slider');
            app.SmoothSASSwitch.ValueChangedFcn = createCallbackFcn(app, @SmoothSASSwitchValueChanged, true);
            app.SmoothSASSwitch.Position = [37 324 45 20];

            % Create Residual_Conc_profile
            app.Residual_Conc_profile = uitab(app.TabGroup);
            app.Residual_Conc_profile.AutoResizeChildren = 'off';
            app.Residual_Conc_profile.Title = 'Residuals';

            % Create UIAxes5
            app.UIAxes5 = uiaxes(app.Residual_Conc_profile);
            title(app.UIAxes5, 'Concentration profile')
            xlabel(app.UIAxes5, 'Time (ns)')
            ylabel(app.UIAxes5, 'Concentration')
            app.UIAxes5.Box = 'on';
            app.UIAxes5.XGrid = 'on';
            app.UIAxes5.Position = [9 216 300 185];

            % Create UIAxes6
            app.UIAxes6 = uiaxes(app.Residual_Conc_profile);
            title(app.UIAxes6, {'Residuals'; ''})
            xlabel(app.UIAxes6, 'Time (ns)')
            ylabel(app.UIAxes6, 'Wavelength (nm)')
            app.UIAxes6.Box = 'on';
            app.UIAxes6.YGrid = 'on';
            app.UIAxes6.Position = [310 216 300 185];

            % Create UIAxes7
            app.UIAxes7 = uiaxes(app.Residual_Conc_profile);
            title(app.UIAxes7, {'Left singular vector'; ''})
            xlabel(app.UIAxes7, 'Wavelength')
            ylabel(app.UIAxes7, 'Intensity')
            app.UIAxes7.Box = 'on';
            app.UIAxes7.YGrid = 'on';
            app.UIAxes7.Position = [9 15 300 185];

            % Create UIAxes8
            app.UIAxes8 = uiaxes(app.Residual_Conc_profile);
            title(app.UIAxes8, 'Right singular vector')
            xlabel(app.UIAxes8, 'Time (ns)')
            ylabel(app.UIAxes8, 'Intensity')
            app.UIAxes8.Box = 'on';
            app.UIAxes8.YGrid = 'on';
            app.UIAxes8.Position = [310 15 300 185];

            % Create ResultsButton
            app.ResultsButton = uibutton(app.Residual_Conc_profile, 'push');
            app.ResultsButton.ButtonPushedFcn = createCallbackFcn(app, @ResultsButtonPushed, true);
            app.ResultsButton.Position = [279 9 86 22];
            app.ResultsButton.Text = 'Results';

            % Create Nodal_DiagramTab
            app.Nodal_DiagramTab = uitab(app.TabGroup);
            app.Nodal_DiagramTab.AutoResizeChildren = 'off';
            app.Nodal_DiagramTab.Title = 'Nodal_Diagram';

            % Create UIAxes13
            app.UIAxes13 = uiaxes(app.Nodal_DiagramTab);
            title(app.UIAxes13, 'Model Visualization')
            xlabel(app.UIAxes13, 'X')
            ylabel(app.UIAxes13, 'Y')
            app.UIAxes13.FontWeight = 'bold';
            app.UIAxes13.Box = 'on';
            app.UIAxes13.Position = [10 0 602 345];

            % Create ModelButton
            app.ModelButton = uibutton(app.Nodal_DiagramTab, 'push');
            app.ModelButton.ButtonPushedFcn = createCallbackFcn(app, @ModelButtonPushed, true);
            app.ModelButton.Position = [43 376 100 22];
            app.ModelButton.Text = {'Model'; ''};

            % Create PressenterafteryoufillupclickonmodelEditFieldLabel
            app.PressenterafteryoufillupclickonmodelEditFieldLabel = uilabel(app.Nodal_DiagramTab);
            app.PressenterafteryoufillupclickonmodelEditFieldLabel.VerticalAlignment = 'top';
            app.PressenterafteryoufillupclickonmodelEditFieldLabel.FontAngle = 'italic';
            app.PressenterafteryoufillupclickonmodelEditFieldLabel.Position = [46 347 241 22];
            app.PressenterafteryoufillupclickonmodelEditFieldLabel.Text = 'Press enter after you fill up & click on model';

            % Create PressenterafteryoufillupclickonmodelEditField
            app.PressenterafteryoufillupclickonmodelEditField = uieditfield(app.Nodal_DiagramTab, 'text');
            app.PressenterafteryoufillupclickonmodelEditField.ValueChangedFcn = createCallbackFcn(app, @PressenterafteryoufillupclickonmodelEditFieldValueChanged, true);
            app.PressenterafteryoufillupclickonmodelEditField.Position = [286 350 290 22];

            % Create PleaseenterthenamesofyourcompartmentLabel
            app.PleaseenterthenamesofyourcompartmentLabel = uilabel(app.Nodal_DiagramTab);
            app.PleaseenterthenamesofyourcompartmentLabel.FontSize = 10;
            app.PleaseenterthenamesofyourcompartmentLabel.FontWeight = 'bold';
            app.PleaseenterthenamesofyourcompartmentLabel.Position = [150 370 457 37];
            app.PleaseenterthenamesofyourcompartmentLabel.Text = 'Please enter the names of the compartments only with spaces between them (eg : AB BA BC)';

            % Create TracesTab
            app.TracesTab = uitab(app.TabGroup);
            app.TracesTab.Title = 'Traces';

            % Create SlicetraceButton
            app.SlicetraceButton = uibutton(app.TracesTab, 'push');
            app.SlicetraceButton.ButtonPushedFcn = createCallbackFcn(app, @SlicetraceButtonPushed, true);
            app.SlicetraceButton.Position = [509 11 100 22];
            app.SlicetraceButton.Text = {'Slice trace'; ''};

            % Create EnternooftraceshitSlicetraceEditFieldLabel
            app.EnternooftraceshitSlicetraceEditFieldLabel = uilabel(app.TracesTab);
            app.EnternooftraceshitSlicetraceEditFieldLabel.HorizontalAlignment = 'right';
            app.EnternooftraceshitSlicetraceEditFieldLabel.FontAngle = 'italic';
            app.EnternooftraceshitSlicetraceEditFieldLabel.Position = [387 43 107 28];
            app.EnternooftraceshitSlicetraceEditFieldLabel.Text = {'Enter no. of traces '; '& hit ''Slice trace'''};

            % Create EnternooftraceshitSlicetraceEditField
            app.EnternooftraceshitSlicetraceEditField = uieditfield(app.TracesTab, 'numeric');
            app.EnternooftraceshitSlicetraceEditField.ValueChangedFcn = createCallbackFcn(app, @EnternooftraceshitSlicetraceEditFieldValueChanged, true);
            app.EnternooftraceshitSlicetraceEditField.FontAngle = 'italic';
            app.EnternooftraceshitSlicetraceEditField.Position = [509 49 100 22];

            % Create UIAxes14
            app.UIAxes14 = uiaxes(app.TracesTab);
            title(app.UIAxes14, 'Time traces')
            xlabel(app.UIAxes14, 'X')
            ylabel(app.UIAxes14, 'Y')
            app.UIAxes14.Position = [21 121 558 269];

            % Create TheoutputoftracewillbeinanewwindowWavelengthnmasyaxisLabel
            app.TheoutputoftracewillbeinanewwindowWavelengthnmasyaxisLabel = uilabel(app.TracesTab);
            app.TheoutputoftracewillbeinanewwindowWavelengthnmasyaxisLabel.HorizontalAlignment = 'center';
            app.TheoutputoftracewillbeinanewwindowWavelengthnmasyaxisLabel.FontWeight = 'bold';
            app.TheoutputoftracewillbeinanewwindowWavelengthnmasyaxisLabel.FontAngle = 'italic';
            app.TheoutputoftracewillbeinanewwindowWavelengthnmasyaxisLabel.Position = [81 11 413 22];
            app.TheoutputoftracewillbeinanewwindowWavelengthnmasyaxisLabel.Text = 'The output of trace will be in a new window.Wavelength (nm) as y-axis';

            % Create SliderLabel
            app.SliderLabel = uilabel(app.TracesTab);
            app.SliderLabel.HorizontalAlignment = 'right';
            app.SliderLabel.Position = [21 82 36 22];
            app.SliderLabel.Text = 'Slider';

            % Create Slider
            app.Slider = uislider(app.TracesTab);
            app.Slider.Position = [78 91 150 3];

            % Create Comparision_DataTab
            app.Comparision_DataTab = uitab(app.TabGroup);
            app.Comparision_DataTab.AutoResizeChildren = 'off';
            app.Comparision_DataTab.Title = 'Comparision_Data';

            % Create UIAxes9
            app.UIAxes9 = uiaxes(app.Comparision_DataTab);
            title(app.UIAxes9, 'Title')
            xlabel(app.UIAxes9, 'Wavelength')
            ylabel(app.UIAxes9, 'Time  (ns)')
            app.UIAxes9.Position = [150 208 300 185];

            % Create UIAxes11
            app.UIAxes11 = uiaxes(app.Comparision_DataTab);
            title(app.UIAxes11, 'Title')
            xlabel(app.UIAxes11, 'X')
            ylabel(app.UIAxes11, 'Y')
            app.UIAxes11.Position = [150 15 300 185];

            % Create Button
            app.Button = uibutton(app.Comparision_DataTab, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.Position = [24 371 100 22];

            % Show the figure after all components are created
            app.Pyglotaran_Plugin.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = appPluginbackup_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.Pyglotaran_Plugin)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.Pyglotaran_Plugin)
        end
    end
end