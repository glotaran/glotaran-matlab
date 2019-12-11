classdef gta_plotter_v0 < matlab.apps.AppBase

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
        ProjectNode                  matlab.ui.container.TreeNode
        DatasetNode                  matlab.ui.container.TreeNode
        ModelsNode                   matlab.ui.container.TreeNode
        MfileNode                    matlab.ui.container.TreeNode
        PfileNode                    matlab.ui.container.TreeNode
        AfileNode                    matlab.ui.container.TreeNode
        ResultNode                   matlab.ui.container.TreeNode
        TabGroup                     matlab.ui.container.TabGroup
        Tab                          matlab.ui.container.Tab
        ModelTextAreaLabel           matlab.ui.control.Label
        ModelTextArea                matlab.ui.control.TextArea
        ParameterTextAreaLabel       matlab.ui.control.Label
        ParameterTextArea            matlab.ui.control.TextArea
        AnalysisresultTextAreaLabel  matlab.ui.control.Label
        AnalysisresultTextArea       matlab.ui.control.TextArea
        CurrentAnalysisSchemainuseLabel  matlab.ui.control.Label
        IterationsSpinnerLabel       matlab.ui.control.Label
        IterationsSpinner            matlab.ui.control.Spinner
        StartAnalysisButton          matlab.ui.control.StateButton
        OpenProjectOutputButton      matlab.ui.control.Button
        UITable                      matlab.ui.control.Table
        CreateProjectButton          matlab.ui.control.Button
        CurrentdirectoryLabel        matlab.ui.control.Label
        AnlaysisSchemaSwitchLabel    matlab.ui.control.Label
        AnlaysisSchemaSwitch         matlab.ui.control.Switch
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
        user_selected_filename
        full_filename_analysis
        cbox
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
                     t = app.TabGroup;
                     f = uitab(t);
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
                      app.ParameterTextArea.Value = cmdoutpar
                 
                
           
            end
        end

        % Value changed function: IterationsSpinner
        function IterationsSpinnerValueChanged(app, event)
            valueIt = app.IterationsSpinner.Value;
            
        end

        % Value changed function: StartAnalysisButton
        function StartAnalysisButtonValueChanged(app, event)
%             value = app.StartAnalysisButton.Value;
            valueIt = app.IterationsSpinner.Value;
           
        switch app.AnlaysisSchemaSwitch.Value 
            case 'Old'
              [statusoptimize,cmdoptimize,app.full_filename_analysis,full_filename_output,file_output]= gta_optimize_cboxon(valueIt,app.user_selected_fullpathname,app.full_filename_analysis)
            case 'New'
%          [statusoptimize,cmdoptimize,app.full_filename_analysis,full_filename_output,file_output]= gta_optimize_cboxon(valueIt,app.user_selected_fullpathname,app.full_filename_analysis)    
              [statusoptimize,cmdoptimize,app.full_filename_analysis,full_filename_output,file_output]= gta_optimize(valueIt,app.user_selected_fullpathname)
         end
            
            app.AnalysisresultTextArea.Value = cmdoptimize
            app.CurrentAnalysisSchemainuseLabel.Text = app.full_filename_analysis
             if statusoptimize == 0
            [wavelength,time,lifetime,das,sas,normdas,normsas,lsv,rsv,fitdata,outdata,rms,conc,outfilename,kmat] = gta_quickoutput(statusoptimize,full_filename_output)
              t = app.TabGroup;
             out_fig = uitab(t)
             out_fig.Title = file_output;
            gta_output(out_fig,wavelength,das,sas,normdas,normsas,lsv,rsv,fitdata,outdata,rms,time,lifetime,conc,outfilename,kmat) 
             else 
                 display('glotaran not working')
             end
            
            a = dir(app.user_selected_fullpathname);                         % Obtains the contents of the selected path.
            b = {a(:).name}';                      % Gets the name of the files/folders of the contents and stores them appropriately in a cell array
            b(ismember(b,{'.','..','count.mat'})) = [];      % Removes unnecessary '.' and '..' results from the display.

            app.uit = app.UITable;
            app.uit.Data = b;
            app.uit.RowName = 'numbered'
            app.CurrentdirectoryLabel.Text= app.user_selected_fullpathname;
        end

        % Button pushed function: OpenProjectOutputButton
        function OpenProjectOutputButtonPushed(app, event)
                        
            app.user_selected_fullpathname = uigetdir()                  % Calls 'uigetdir' to obtain the directory location from the user
%             app.UIFigure.Visible = 'off';     % Toggles figure visible.  These two lines of code work-around an issue whether the figure is sent to the background.
%             app.UIFigure.Visible = 'on';      
            %app.DirectoryLocationLabel.Text=path;  % Sets the label text to be the selected path

            a = dir(app.user_selected_fullpathname);                         % Obtains the contents of the selected path.
            b = {a(:).name}';                      % Gets the name of the files/folders of the contents and stores them appropriately in a cell array
            b(ismember(b,{'.','..','count.mat'})) = [];      % Removes unnecessary '.' and '..' results from the display.

            app.uit = app.UITable;
            app.uit.Data = b;
%             app.uit.RowName = 'numbered'
            app.CurrentdirectoryLabel.Text= app.user_selected_fullpathname;
        end

        % Callback function
        function ButtonPushed(app, event)
%             indices = event.Indices;
%             display(indices)
%              row = eventdata.Indices(1)
%              col = eventdata.Indices(2)
        end

        % Cell selection callback: UITable
        function UITableCellSelection2(app, event)
            indices = event.Indices;
                  
            display(indices)
             row = event.Indices(1)
             col = event.Indices(2)
%               display(app.uit)
             app.user_tableselect = app.UITable.Data(row,col)
             [wavelength,time,lifetime,das,sas,normdas,normsas,lsv,rsv,app.fitdata,outdata,rms,conc,outfilename,kmat] = go2userchoice_output_v2(app.user_selected_fullpathname,app.user_tableselect)  
             t = app.TabGroup;
             out_fig = uitab(t)
             out_fig.Title = num2str(row);
             gta_output(out_fig,wavelength,das,sas,normdas,normsas,lsv,rsv,app.fitdata,outdata,rms,time,lifetime,conc,app.outfilename,kmat) 
        
        end

        % Button pushed function: CreateProjectButton
        function CreateProjectButtonPushed(app, event)
                 [app.user_selected_filename,app.user_selected_fullpathname] = gta_userselected_outputpath
                  app.CurrentdirectoryLabel.Text= app.user_selected_fullpathname;
        end

        % Value changed function: AnlaysisSchemaSwitch
        function AnlaysisSchemaSwitchValueChanged(app, event)
            value = app.AnlaysisSchemaSwitch.Value;
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create Plotter and hide until all components are created
            app.Plotter = uifigure('Visible', 'off');
            app.Plotter.IntegerHandle = 'on';
            app.Plotter.Color = [1 1 1];
            app.Plotter.Position = [100 100 1379 827];
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
            app.Tree.Position = [39 481 169 224];

            % Create ProjectNode
            app.ProjectNode = uitreenode(app.Tree);
            app.ProjectNode.Text = 'Project';

            % Create DatasetNode
            app.DatasetNode = uitreenode(app.ProjectNode);
            app.DatasetNode.Text = 'Dataset';

            % Create ModelsNode
            app.ModelsNode = uitreenode(app.ProjectNode);
            app.ModelsNode.Text = 'Models';

            % Create MfileNode
            app.MfileNode = uitreenode(app.ModelsNode);
            app.MfileNode.Text = 'M-file';

            % Create PfileNode
            app.PfileNode = uitreenode(app.ModelsNode);
            app.PfileNode.Text = 'P-file';

            % Create AfileNode
            app.AfileNode = uitreenode(app.ModelsNode);
            app.AfileNode.Text = 'A-file';

            % Create ResultNode
            app.ResultNode = uitreenode(app.ProjectNode);
            app.ResultNode.Text = 'Result';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.Plotter);
            app.TabGroup.Position = [231 9 874 755];

            % Create Tab
            app.Tab = uitab(app.TabGroup);
            app.Tab.Scrollable = 'on';

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

            % Create CurrentAnalysisSchemainuseLabel
            app.CurrentAnalysisSchemainuseLabel = uilabel(app.Tab);
            app.CurrentAnalysisSchemainuseLabel.FontSize = 8;
            app.CurrentAnalysisSchemainuseLabel.FontWeight = 'bold';
            app.CurrentAnalysisSchemainuseLabel.FontColor = [0 0 1];
            app.CurrentAnalysisSchemainuseLabel.Position = [200 279 640 22];
            app.CurrentAnalysisSchemainuseLabel.Text = 'Current Analysis Schema in use';

            % Create IterationsSpinnerLabel
            app.IterationsSpinnerLabel = uilabel(app.Plotter);
            app.IterationsSpinnerLabel.HorizontalAlignment = 'center';
            app.IterationsSpinnerLabel.FontSize = 10;
            app.IterationsSpinnerLabel.FontWeight = 'bold';
            app.IterationsSpinnerLabel.Position = [34 397 100 22];
            app.IterationsSpinnerLabel.Text = 'Iterations';

            % Create IterationsSpinner
            app.IterationsSpinner = uispinner(app.Plotter);
            app.IterationsSpinner.ValueChangedFcn = createCallbackFcn(app, @IterationsSpinnerValueChanged, true);
            app.IterationsSpinner.HorizontalAlignment = 'center';
            app.IterationsSpinner.FontWeight = 'bold';
            app.IterationsSpinner.Position = [133 397 66 22];
            app.IterationsSpinner.Value = 1;

            % Create StartAnalysisButton
            app.StartAnalysisButton = uibutton(app.Plotter, 'state');
            app.StartAnalysisButton.ValueChangedFcn = createCallbackFcn(app, @StartAnalysisButtonValueChanged, true);
            app.StartAnalysisButton.Text = 'Start- Analysis';
            app.StartAnalysisButton.FontWeight = 'bold';
            app.StartAnalysisButton.Position = [37 354 162 33];

            % Create OpenProjectOutputButton
            app.OpenProjectOutputButton = uibutton(app.Plotter, 'push');
            app.OpenProjectOutputButton.ButtonPushedFcn = createCallbackFcn(app, @OpenProjectOutputButtonPushed, true);
            app.OpenProjectOutputButton.FontName = 'Trebuchet MS';
            app.OpenProjectOutputButton.FontWeight = 'bold';
            app.OpenProjectOutputButton.Position = [1120 727 162 33];
            app.OpenProjectOutputButton.Text = 'Open Project Output';

            % Create UITable
            app.UITable = uitable(app.Plotter);
            app.UITable.ColumnName = {'Files'};
            app.UITable.RowName = {};
            app.UITable.ColumnSortable = true;
            app.UITable.RowStriping = 'off';
            app.UITable.CellSelectionCallback = createCallbackFcn(app, @UITableCellSelection2, true);
            app.UITable.ForegroundColor = [0.8784 0.0863 0.0863];
            app.UITable.FontName = 'Trebuchet MS';
            app.UITable.FontAngle = 'italic';
            app.UITable.FontWeight = 'bold';
            app.UITable.Position = [1120 67 207 586];

            % Create CreateProjectButton
            app.CreateProjectButton = uibutton(app.Plotter, 'push');
            app.CreateProjectButton.ButtonPushedFcn = createCallbackFcn(app, @CreateProjectButtonPushed, true);
            app.CreateProjectButton.FontName = 'Trebuchet MS';
            app.CreateProjectButton.FontWeight = 'bold';
            app.CreateProjectButton.Position = [39 726 162 33];
            app.CreateProjectButton.Text = 'Create Project';

            % Create CurrentdirectoryLabel
            app.CurrentdirectoryLabel = uilabel(app.Plotter);
            app.CurrentdirectoryLabel.VerticalAlignment = 'top';
            app.CurrentdirectoryLabel.FontSize = 8;
            app.CurrentdirectoryLabel.FontWeight = 'bold';
            app.CurrentdirectoryLabel.FontAngle = 'italic';
            app.CurrentdirectoryLabel.FontColor = [0 0 1];
            app.CurrentdirectoryLabel.Position = [1120 605 242 100];
            app.CurrentdirectoryLabel.Text = 'Current-directory ';

            % Create AnlaysisSchemaSwitchLabel
            app.AnlaysisSchemaSwitchLabel = uilabel(app.Plotter);
            app.AnlaysisSchemaSwitchLabel.HorizontalAlignment = 'center';
            app.AnlaysisSchemaSwitchLabel.Position = [69 279 97 22];
            app.AnlaysisSchemaSwitchLabel.Text = 'Anlaysis Schema';

            % Create AnlaysisSchemaSwitch
            app.AnlaysisSchemaSwitch = uiswitch(app.Plotter, 'slider');
            app.AnlaysisSchemaSwitch.Items = {'New', 'Old'};
            app.AnlaysisSchemaSwitch.ValueChangedFcn = createCallbackFcn(app, @AnlaysisSchemaSwitchValueChanged, true);
            app.AnlaysisSchemaSwitch.Position = [83 315 69 30];
            app.AnlaysisSchemaSwitch.Value = 'New';

            % Show the figure after all components are created
            app.Plotter.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = gta_plotter_v0

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