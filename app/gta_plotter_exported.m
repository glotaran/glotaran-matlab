classdef gta_plotter_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        Plotter                      matlab.ui.Figure
        FileMenu                     matlab.ui.container.Menu
        CreateProjectMenu            matlab.ui.container.Menu
        OpenProjectMenu              matlab.ui.container.Menu
        RecentProjectMenu            matlab.ui.container.Menu
        EditMenu                     matlab.ui.container.Menu
        HelpMenu                     matlab.ui.container.Menu
        VersionMenu                  matlab.ui.container.Menu
        UpdateMenu                   matlab.ui.container.Menu
        Tree                         matlab.ui.container.Tree
        TabGroup                     matlab.ui.container.TabGroup
        Tab                          matlab.ui.container.Tab
        CurrentAnalysisSchemainuseLabel  matlab.ui.control.Label
        ModelTextAreaLabel           matlab.ui.control.Label
        ModelTextArea                matlab.ui.control.TextArea
        ParameterTextAreaLabel       matlab.ui.control.Label
        ParameterTextArea            matlab.ui.control.TextArea
        AnalysisresultTextAreaLabel  matlab.ui.control.Label
        AnalysisresultTextArea       matlab.ui.control.TextArea
        IterationsSpinnerLabel       matlab.ui.control.Label
        IterationsSpinner            matlab.ui.control.Spinner
        StartAnalysisButton          matlab.ui.control.StateButton
        OpenProjectOutputButton      matlab.ui.control.Button
        UITable                      matlab.ui.control.Table
        CreateProjectButton          matlab.ui.control.Button
        AnlaysisSchemaSwitchLabel    matlab.ui.control.Label
        AnlaysisSchemaSwitch         matlab.ui.control.Switch
        PlotaccessibiltyButtonGroup  matlab.ui.container.ButtonGroup
        DASMaxButton                 matlab.ui.control.RadioButton
        DASMinButton                 matlab.ui.control.RadioButton
        SASMaxButton                 matlab.ui.control.RadioButton
        DeleteTabButton              matlab.ui.control.Button
        CaptureScreenButton          matlab.ui.control.Button
        CreateProjectTextArea        matlab.ui.control.TextArea
        CurrentDirectory             matlab.ui.control.TextArea
    end


   properties (Access = public) 
        
        filename
        data
        dataf
        wavelength
        time
        U
        S
        V
        chk
        f
        grid1
        p
        ax
        grid2
        lifetime
        das
        sas
        normdas
        normsas
        lsv
        rsv
        fitdata
        outdata
        rms
        conc
        outfilename
        kmat
        out_fig
        uit
        user_selected_fullpathname
        user_tableselect
        
        full_filename_analysis
        cbox
        cmdoptimize
        statusoptimize
        t % tab 
        lit
    end

    

    
    methods (Access = public)
        
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Node text changed function: Tree
        function TreeNodeTextChanged(app, event)
            node = event.Node;
            
                display(node)
            
        end

        % Selection changed function: Tree
        function TreeSelectionChanged(app, event)
            selectedNodes = app.Tree.SelectedNodes;
            nod = selectedNodes.Text
             switch nod
                 case 'Dataset'
%                      app.BoardPanel.cla;
                     [filename,data,dataf,wavelength,time,U,S,V,chk] = gta_loaddataset();
                         d = uiprogressdlg(app.Plotter,'Title','Please Wait',...
                                'Message','Loading your data ...');
                            pause(.5)
                     app.t = app.TabGroup;
                     f = uitab(app.t);
                     f.Title = filename;
%                      f.SelectionType = 'Mouse'
                     [app.grid1,p,ax,grid2,time] = gta_dataload_GUI_v1(f,filename,data,dataf,wavelength,time,U,S,V,chk);
                 case 'Result'
%                       app.BoardPanel.cla;
                    [wavelength,time,lifetime,das,sas,normdas,normsas,lsv,rsv,fitdata,outdata,rms,conc,outfilename,kmat] = gta_readpyglot()
                      t = app.TabGroup;
                     out_fig = uitab(t)
                     out_fig.Title = outfilename;
                     gta_output(out_fig,wavelength,das,sas,normdas,normsas,lsv,rsv,fitdata,outdata,rms,time,lifetime,conc,outfilename,kmat) 
                 case 'M-file'
                    [statusmodel,cmdoutmodel,filemodel]= gta_printmodel()
                      app.ModelTextArea.Value = cmdoutmodel
                 case 'P-file'
                     [statuspar,cmdoutpar,fileparameter]= gta_printparameter()
                      app.ParameterTextArea.Value = cmdoutpar;
                 
                
           
            end
        end

        % Value changed function: IterationsSpinner
        function IterationsSpinnerValueChanged(app, event)
            valueIt = app.IterationsSpinner.Value;
            
        end

        % Value changed function: StartAnalysisButton
        function StartAnalysisButtonValueChanged(app, event)
% optimization of the analysis scheme created by the user

        valueIt = app.IterationsSpinner.Value;  
%%        
% Incase the user directly goes for the analysis 

        if isempty(app.user_selected_fullpathname)
            message1 = sprintf('Project file missing. \n 1.Create output file. \n 2.Run your analysis file!');
            uialert(app.Plotter,message1,'MISSING',...
                    'Icon','info');           
            [app.user_selected_fullpathname] = gta_userselected_outputpath;
            
           if ~isspace(app.user_selected_fullpathname)
              app.CurrentDirectory.Value = app.user_selected_fullpathname;
              app.CreateProjectTextArea.Value = app.user_selected_fullpathname;
              node1 = uitreenode(app.Tree,'Text','Dataset');
              node2 = uitreenode(app.Tree,'Text','Schema');
              node2a = uitreenode(node2,'Text','M-file');
              node2b = uitreenode(node2,'Text','P-file');
              app.AnlaysisSchemaSwitch.Value = 'New'; % directly goes to new analysis scheme option
          else
              outfoldermsg1 = sprintf('Path to filename must be without spaces: \n ');
              outfoldermsg2 = app.user_selected_fullpathname;
              outfoldermsg = strcat(outfoldermsg1,outfoldermsg2)
                uialert(app.Plotter,outfoldermsg,'WRONG FILE NAMING',...
                'Icon','error');   
          end
            
            
        end
% Analysis schema options - reuse the anlaysis scheme or not           
        
        switch app.AnlaysisSchemaSwitch.Value 
            case 'Old'
              d0 = uiprogressdlg(app.Plotter,"Title",'Starting analysis ..',"Value",0);
              [app.statusoptimize,app.cmdoptimize,app.full_filename_analysis,full_filename_output,file_output]= gta_optimize_cboxon(valueIt,app.user_selected_fullpathname,app.full_filename_analysis);             
            case 'New'
    %         [statusoptimize,cmdoptimize,app.full_filename_analysis,full_filename_output,file_output]= gta_optimize_cboxon(valueIt,app.user_selected_fullpathname,app.full_filename_analysis)    
              [app.statusoptimize,app.cmdoptimize,app.full_filename_analysis,full_filename_output,file_output]= gta_optimize(valueIt,app.user_selected_fullpathname);
              d0 = uiprogressdlg(app.Plotter,"Title",'Starting analysis ..',"Value",0);
        end  %switch case end
          
        d1 = uiprogressdlg(app.Plotter,"Title",'Optimizing ..',"Value",0.25);
        app.AnalysisresultTextArea.Value = app.cmdoptimize;       
        app.CurrentAnalysisSchemainuseLabel.Text = app.full_filename_analysis;
        
% Creating output directly in a new tab only if the optimization was successful,       
        if  app.statusoptimize == 0
            [app.wavelength,app.time,app.lifetime,app.das,app.sas,app.normdas,app.normsas,app.lsv,app.rsv,app.fitdata,app.outdata,app.rms,app.conc,app.outfilename,app.kmat] = gta_quickreadoutput(app.statusoptimize,full_filename_output);
            app.t = app.TabGroup;
            app.out_fig = uitab(app.t);
            app.out_fig.Title = file_output;
            gta_output(app.out_fig,app.wavelength,app.das,app.sas,app.normdas,app.normsas,app.lsv,app.rsv,app.fitdata,app.outdata,app.rms,app.time,app.lifetime,app.conc,app.outfilename,app.kmat,app.cmdoptimize,app.t,app.out_fig.Title);
        else
            message2a = sprintf('The output tab cannot be produced \n app.statusoptimize output=');
            message2b = num2str(app.statusoptimize);
            message2 = strcat(message2a,message2b);
            uialert(app.Plotter,message2,'Error',...
                        'Icon','error');
        end
            d2 = uiprogressdlg(app.Plotter,"Title",'Optimization done..',"Value",1);
            a = dir(app.user_selected_fullpathname); % Obtains the contents of the selected path.
            b = {a(:).name}';% Gets the name of the files/folders of the contents and stores them appropriately in a cell array
            b(ismember(b,{'optimized_parameter.csv','..','count.mat','result.md'})) = [];% Removes unnecessary '.' and '..' results from the display.
            app.uit = app.UITable;
            app.uit.Data = b;
            app.uit.RowName = 'numbered';
            app.CurrentDirectory.Value = app.user_selected_fullpathname;
        end

        % Button pushed function: OpenProjectOutputButton
        function OpenProjectOutputButtonPushed(app, event)
                        
            app.user_selected_fullpathname = uigetdir()                  % Calls 'uigetdir' to obtain the directory location from the user
%             app.UIFigure.Visible = 'off';     % Toggles figure visible.  These two lines of code work-around an issue whether the figure is sent to the background.
%             app.UIFigure.Visible = 'on';      
            %app.DirectoryLocationLabel.Text=path;  % Sets the label text to be the selected path

            a = dir(app.user_selected_fullpathname);                         % Obtains the contents of the selected path.
            b = {a(:).name}';                      % Gets the name of the files/folders of the contents and stores them appropriately in a cell array
%             b(ismember(b,{'.','..','count.mat'})) = [];      % Removes unnecessary '.' and '..' results from the display.
            b(ismember(b,{'..','count.mat','optimized_parameter.csv','result.md'})) = [];
            app.uit = app.UITable;
            
            
            app.uit.Data = b;
            
            app.uit.RowName = 'numbered';            
            app.CurrentDirectory.Value = app.user_selected_fullpathname;
        end

        % Cell selection callback: UITable
        function UITableCellSelection2(app, event)
             indices = event.Indices ;
             multi_select = numel(indices)      
             display(indices)
             row = event.Indices(1)
             col = 1;
%               display(app.uit)
              
             app.user_tableselect = app.UITable.Data(row,col);
             [app.wavelength,app.time,app.lifetime,app.das,app.sas,app.normdas,app.normsas,app.lsv,app.rsv,app.fitdata,app.outdata,app.rms,app.conc,app.outfilename,app.kmat] = go2userchoice_output_v3(app.user_selected_fullpathname,app.user_tableselect);
             app.t = app.TabGroup;
             app.out_fig = uitab(app.t);   
             tabtitle = strcat(num2str(row),'.',string(app.user_tableselect));
             app.out_fig.Title = tabtitle;
             app.out_fig.ForegroundColor = 'r';
             gta_output(app.out_fig,app.wavelength,app.das,app.sas,app.normdas,app.normsas,app.lsv,app.rsv,app.fitdata,app.outdata,app.rms,app.time,app.lifetime,app.conc,app.outfilename,app.kmat,app.cmdoptimize,app.t,app.out_fig.Title) 

        end

        % Button pushed function: CreateProjectButton
        function CreateProjectButtonPushed(app, event)
                  app.user_selected_fullpathname = gta_userselected_outputpath;
%                   [~,name] = fileparts(app.user_selected_fullpathname)
                  if ~isspace(app.user_selected_fullpathname)
                      app.CurrentDirectory.Value = app.user_selected_fullpathname;
                      app.CreateProjectTextArea.Value = app.user_selected_fullpathname;
                      node1 = uitreenode(app.Tree,'Text','Dataset');
                      node2 = uitreenode(app.Tree,'Text','Schema');
                      node2a = uitreenode(node2,'Text','M-file');
                      node2b = uitreenode(node2,'Text','P-file');
                  else
                      outfoldermsg1 = sprintf('Path to filename must be without spaces: \n ');
                      outfoldermsg2 = app.user_selected_fullpathname;
                      outfoldermsg = strcat(outfoldermsg1,outfoldermsg2)
                        uialert(app.Plotter,outfoldermsg,'WRONG FILE NAMING',...
                        'Icon','error');   
                  end
        end

        % Value changed function: AnlaysisSchemaSwitch
        function AnlaysisSchemaSwitchValueChanged(app, event)
            value = app.AnlaysisSchemaSwitch.Value;
            
        end

        % Button pushed function: DeleteTabButton
        function DeleteTabButtonPushed(app, event)
            currenttab = app.TabGroup.SelectedTab;
            delete(currenttab)
        end

        % Button pushed function: CaptureScreenButton
        function CaptureScreenButtonPushed(app, event)
%             currenttab = app.Plotter;
%             screencapture(currenttab)
%  screencapture('handle',gcf,'target','myFigure.jpg');
% Button pushed function: CaptureButton
%         function CaptureButtonPushed(app, event)
                robot = java.awt.Robot();
                temp = app.Plotter.Position; % returns position as [left bottom width height]
             
                allMonPos = get(0,'MonitorPositions');
                curMon = find(temp(1)<(allMonPos(:,1)+allMonPos(:,3)),1,'first');
                curMonHeight = allMonPos(curMon,4)+1;
                pos = [temp(1) curMonHeight-(temp(2)+temp(4)) temp(3)-1 temp(4)]; % [left top width height].... UL X, UL Y, width, height
                rect = java.awt.Rectangle(pos(1),pos(2),pos(3),pos(4));
                cap = robot.createScreenCapture(rect);
                % Convert to an RGB image
                rgb = typecast(cap.getRGB(0,0,cap.getWidth,cap.getHeight,[],0,cap.getWidth),'uint8');
                imgData = zeros(cap.getHeight,cap.getWidth,3,'uint8');
                imgData(:,:,1) = reshape(rgb(3:4:end),cap.getWidth,[])';
                imgData(:,:,2) = reshape(rgb(2:4:end),cap.getWidth,[])';
                imgData(:,:,3) = reshape(rgb(1:4:end),cap.getWidth,[])';
%                 imclipboard('copy', imgData)
                imshow(imgData)

%           end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create Plotter and hide until all components are created
            app.Plotter = uifigure('Visible', 'off');
            app.Plotter.Color = [1 1 1];
            app.Plotter.Position = [20 100 1387 824];
            app.Plotter.Name = 'Plotter';
            app.Plotter.Scrollable = 'on';

            % Create FileMenu
            app.FileMenu = uimenu(app.Plotter);
            app.FileMenu.Text = 'File';

            % Create CreateProjectMenu
            app.CreateProjectMenu = uimenu(app.FileMenu);
            app.CreateProjectMenu.Text = 'Create Project';

            % Create OpenProjectMenu
            app.OpenProjectMenu = uimenu(app.FileMenu);
            app.OpenProjectMenu.Text = 'Open Project';

            % Create RecentProjectMenu
            app.RecentProjectMenu = uimenu(app.FileMenu);
            app.RecentProjectMenu.Text = 'Recent Project';

            % Create EditMenu
            app.EditMenu = uimenu(app.Plotter);
            app.EditMenu.Text = 'Edit';

            % Create HelpMenu
            app.HelpMenu = uimenu(app.Plotter);
            app.HelpMenu.Text = 'Help';

            % Create VersionMenu
            app.VersionMenu = uimenu(app.HelpMenu);
            app.VersionMenu.Text = 'Version';

            % Create UpdateMenu
            app.UpdateMenu = uimenu(app.HelpMenu);
            app.UpdateMenu.Text = 'Update';

            % Create Tree
            app.Tree = uitree(app.Plotter);
            app.Tree.SelectionChangedFcn = createCallbackFcn(app, @TreeSelectionChanged, true);
            app.Tree.NodeTextChangedFcn = createCallbackFcn(app, @TreeNodeTextChanged, true);
            app.Tree.FontSize = 10;
            app.Tree.FontWeight = 'bold';
            app.Tree.FontAngle = 'italic';
            app.Tree.FontColor = [0 0 1];
            app.Tree.BackgroundColor = [0.8 0.8 0.8];
            app.Tree.Position = [12 457 169 169];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.Plotter);
            app.TabGroup.Position = [200 6 956 755];

            % Create Tab
            app.Tab = uitab(app.TabGroup);
            app.Tab.Scrollable = 'on';

            % Create CurrentAnalysisSchemainuseLabel
            app.CurrentAnalysisSchemainuseLabel = uilabel(app.Tab);
            app.CurrentAnalysisSchemainuseLabel.FontSize = 8;
            app.CurrentAnalysisSchemainuseLabel.FontWeight = 'bold';
            app.CurrentAnalysisSchemainuseLabel.FontColor = [0 0 1];
            app.CurrentAnalysisSchemainuseLabel.Position = [200 279 640 22];
            app.CurrentAnalysisSchemainuseLabel.Text = 'Current Analysis Schema in use';

            % Create ModelTextAreaLabel
            app.ModelTextAreaLabel = uilabel(app.Tab);
            app.ModelTextAreaLabel.HorizontalAlignment = 'center';
            app.ModelTextAreaLabel.FontName = 'Trebuchet MS';
            app.ModelTextAreaLabel.FontSize = 15;
            app.ModelTextAreaLabel.FontWeight = 'bold';
            app.ModelTextAreaLabel.Position = [79 695 143 22];
            app.ModelTextAreaLabel.Text = 'Model ';

            % Create ModelTextArea
            app.ModelTextArea = uitextarea(app.Tab);
            app.ModelTextArea.Position = [15 326 391 362];

            % Create ParameterTextAreaLabel
            app.ParameterTextAreaLabel = uilabel(app.Tab);
            app.ParameterTextAreaLabel.HorizontalAlignment = 'center';
            app.ParameterTextAreaLabel.FontName = 'Trebuchet MS';
            app.ParameterTextAreaLabel.FontSize = 15;
            app.ParameterTextAreaLabel.FontWeight = 'bold';
            app.ParameterTextAreaLabel.Position = [474 695 79 22];
            app.ParameterTextAreaLabel.Text = 'Parameter';

            % Create ParameterTextArea
            app.ParameterTextArea = uitextarea(app.Tab);
            app.ParameterTextArea.Position = [447 326 409 362];

            % Create AnalysisresultTextAreaLabel
            app.AnalysisresultTextAreaLabel = uilabel(app.Tab);
            app.AnalysisresultTextAreaLabel.HorizontalAlignment = 'center';
            app.AnalysisresultTextAreaLabel.FontName = 'Trebuchet MS';
            app.AnalysisresultTextAreaLabel.FontSize = 15;
            app.AnalysisresultTextAreaLabel.FontWeight = 'bold';
            app.AnalysisresultTextAreaLabel.Position = [35 279 187 22];
            app.AnalysisresultTextAreaLabel.Text = 'Analysis result';

            % Create AnalysisresultTextArea
            app.AnalysisresultTextArea = uitextarea(app.Tab);
            app.AnalysisresultTextArea.Position = [19 10 837 262];

            % Create IterationsSpinnerLabel
            app.IterationsSpinnerLabel = uilabel(app.Plotter);
            app.IterationsSpinnerLabel.HorizontalAlignment = 'center';
            app.IterationsSpinnerLabel.FontSize = 10;
            app.IterationsSpinnerLabel.Position = [11 336 100 22];
            app.IterationsSpinnerLabel.Text = 'Iterations';

            % Create IterationsSpinner
            app.IterationsSpinner = uispinner(app.Plotter);
            app.IterationsSpinner.ValueChangedFcn = createCallbackFcn(app, @IterationsSpinnerValueChanged, true);
            app.IterationsSpinner.HorizontalAlignment = 'center';
            app.IterationsSpinner.FontWeight = 'bold';
            app.IterationsSpinner.Position = [110 336 66 22];
            app.IterationsSpinner.Value = 1;

            % Create StartAnalysisButton
            app.StartAnalysisButton = uibutton(app.Plotter, 'state');
            app.StartAnalysisButton.ValueChangedFcn = createCallbackFcn(app, @StartAnalysisButtonValueChanged, true);
            app.StartAnalysisButton.Text = 'Start- Analysis';
            app.StartAnalysisButton.FontWeight = 'bold';
            app.StartAnalysisButton.Position = [14 293 162 33];

            % Create OpenProjectOutputButton
            app.OpenProjectOutputButton = uibutton(app.Plotter, 'push');
            app.OpenProjectOutputButton.ButtonPushedFcn = createCallbackFcn(app, @OpenProjectOutputButtonPushed, true);
            app.OpenProjectOutputButton.FontName = 'Trebuchet MS';
            app.OpenProjectOutputButton.FontWeight = 'bold';
            app.OpenProjectOutputButton.Position = [1185 728 162 33];
            app.OpenProjectOutputButton.Text = 'Open Project Output';

            % Create UITable
            app.UITable = uitable(app.Plotter);
            app.UITable.ColumnName = {'Files'; ''};
            app.UITable.RowName = {};
            app.UITable.ColumnSortable = [true false];
            app.UITable.CellSelectionCallback = createCallbackFcn(app, @UITableCellSelection2, true);
            app.UITable.ForegroundColor = [0.8784 0.0863 0.0863];
            app.UITable.FontName = 'Trebuchet MS';
            app.UITable.FontAngle = 'italic';
            app.UITable.FontWeight = 'bold';
            app.UITable.Position = [1165 74 207 586];

            % Create CreateProjectButton
            app.CreateProjectButton = uibutton(app.Plotter, 'push');
            app.CreateProjectButton.ButtonPushedFcn = createCallbackFcn(app, @CreateProjectButtonPushed, true);
            app.CreateProjectButton.FontName = 'Trebuchet MS';
            app.CreateProjectButton.FontWeight = 'bold';
            app.CreateProjectButton.Tooltip = {'Path to folder name must be without spaces'};
            app.CreateProjectButton.Position = [12 723 162 33];
            app.CreateProjectButton.Text = 'Create Project';

            % Create AnlaysisSchemaSwitchLabel
            app.AnlaysisSchemaSwitchLabel = uilabel(app.Plotter);
            app.AnlaysisSchemaSwitchLabel.HorizontalAlignment = 'center';
            app.AnlaysisSchemaSwitchLabel.FontSize = 10;
            app.AnlaysisSchemaSwitchLabel.Position = [53 235 82 22];
            app.AnlaysisSchemaSwitchLabel.Text = 'Anlaysis Schema';

            % Create AnlaysisSchemaSwitch
            app.AnlaysisSchemaSwitch = uiswitch(app.Plotter, 'slider');
            app.AnlaysisSchemaSwitch.Items = {'New', 'Old'};
            app.AnlaysisSchemaSwitch.ValueChangedFcn = createCallbackFcn(app, @AnlaysisSchemaSwitchValueChanged, true);
            app.AnlaysisSchemaSwitch.Position = [82 263 22 10];
            app.AnlaysisSchemaSwitch.Value = 'New';

            % Create PlotaccessibiltyButtonGroup
            app.PlotaccessibiltyButtonGroup = uibuttongroup(app.Plotter);
            app.PlotaccessibiltyButtonGroup.BorderType = 'none';
            app.PlotaccessibiltyButtonGroup.Title = 'Plot accessibilty';
            app.PlotaccessibiltyButtonGroup.BackgroundColor = [0.8 0.8 0.8];
            app.PlotaccessibiltyButtonGroup.FontAngle = 'italic';
            app.PlotaccessibiltyButtonGroup.Position = [201 767 955 52];

            % Create DASMaxButton
            app.DASMaxButton = uiradiobutton(app.PlotaccessibiltyButtonGroup);
            app.DASMaxButton.Text = 'DAS Max';
            app.DASMaxButton.FontAngle = 'italic';
            app.DASMaxButton.Position = [11 1 72 22];
            app.DASMaxButton.Value = true;

            % Create DASMinButton
            app.DASMinButton = uiradiobutton(app.PlotaccessibiltyButtonGroup);
            app.DASMinButton.Text = 'DAS Min';
            app.DASMinButton.FontAngle = 'italic';
            app.DASMinButton.Position = [108 1 69 22];

            % Create SASMaxButton
            app.SASMaxButton = uiradiobutton(app.PlotaccessibiltyButtonGroup);
            app.SASMaxButton.Text = 'SAS Max';
            app.SASMaxButton.FontAngle = 'italic';
            app.SASMaxButton.Position = [203 1 71 22];

            % Create DeleteTabButton
            app.DeleteTabButton = uibutton(app.Plotter, 'push');
            app.DeleteTabButton.ButtonPushedFcn = createCallbackFcn(app, @DeleteTabButtonPushed, true);
            app.DeleteTabButton.FontWeight = 'bold';
            app.DeleteTabButton.Position = [19 55 162 33];
            app.DeleteTabButton.Text = 'Delete Tab';

            % Create CaptureScreenButton
            app.CaptureScreenButton = uibutton(app.Plotter, 'push');
            app.CaptureScreenButton.ButtonPushedFcn = createCallbackFcn(app, @CaptureScreenButtonPushed, true);
            app.CaptureScreenButton.FontWeight = 'bold';
            app.CaptureScreenButton.Position = [19 101 162 33];
            app.CaptureScreenButton.Text = 'Capture Screen';

            % Create CreateProjectTextArea
            app.CreateProjectTextArea = uitextarea(app.Plotter);
            app.CreateProjectTextArea.FontSize = 10;
            app.CreateProjectTextArea.FontWeight = 'bold';
            app.CreateProjectTextArea.FontAngle = 'italic';
            app.CreateProjectTextArea.FontColor = [0 0 1];
            app.CreateProjectTextArea.Position = [12 642 169 60];
            app.CreateProjectTextArea.Value = {'Current project - directory'};

            % Create CurrentDirectory
            app.CurrentDirectory = uitextarea(app.Plotter);
            app.CurrentDirectory.FontSize = 10;
            app.CurrentDirectory.FontWeight = 'bold';
            app.CurrentDirectory.FontAngle = 'italic';
            app.CurrentDirectory.FontColor = [0 0 1];
            app.CurrentDirectory.Position = [1165 671 207 52];
            app.CurrentDirectory.Value = {'Current output - directory'};

            % Show the figure after all components are created
            app.Plotter.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = gta_plotter_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.Plotter)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.Plotter)
        end
    end
end