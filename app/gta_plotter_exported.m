classdef gta_plotter_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        Plotter                      matlab.ui.Figure
        FileMenu                     matlab.ui.container.Menu
        CreateProjectMenu            matlab.ui.container.Menu
        OpenProjectMenu              matlab.ui.container.Menu
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
        OpenProjectButton            matlab.ui.control.Button
        UITable                      matlab.ui.control.Table
        CreateProjectButton          matlab.ui.control.Button
        CreateProjectTextArea        matlab.ui.control.TextArea
        CurrentDirectory             matlab.ui.control.TextArea
        Panel                        matlab.ui.container.Panel
        ModelButton                  matlab.ui.control.Button
        ParameterButton              matlab.ui.control.Button
        DeleteTabButton              matlab.ui.control.Button
        CaptureButton                matlab.ui.control.Button
        RunAnalysisPanel             matlab.ui.container.Panel
        StartAnalysis                matlab.ui.control.StateButton
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
        full_filename_output
        full_filename_analysis
        cbox
        cmdoptimize
        statusoptimize % the optimizing status
        t % tab       
        valueIt % total itrerations input
    end

    

    
    methods (Access = public)
        
    end
    
    methods (Access = private)
        

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
            nod = selectedNodes.Text;
            switch nod
                case 'Dataset'
                    [app.filename,app.data,app.dataf,app.wavelength,app.time,app.U,app.S,app.V,app.chk] = gta_loaddataset();
                    d = uiprogressdlg(app.Plotter,'Title','Please Wait',...
                        'Message','Loading your data ...');
                    pause(.5)
                    app.t = app.TabGroup;
                    app.f = uitab(app.t);
                    app.f.Title = app.filename;
                    [app.grid1,app.p,app.ax,app.grid2,app.time] = gta_dataload_GUI_v1(app.f,app.filename,app.data,app.dataf,app.wavelength,app.time,app.U,app.S,app.V,app.chk);
                    
                case 'M-file'
                    [~,cmdoutmodel,~]= gta_printmodel();
                    app.ModelTextArea.Value = cmdoutmodel;
                case 'P-file'
                    [~,cmdoutpar,~]= gta_printparameter();
                    app.ParameterTextArea.Value = cmdoutpar;
            end
        end

        % Value changed function: IterationsSpinner
        function IterationsSpinnerValueChanged(app, event)
            app.valueIt = app.IterationsSpinner.Value;
            
        end

        % Value changed function: StartAnalysis
        function StartAnalysisValueChanged(app, event)
            % optimization of the analysis scheme created by the user
            app.valueIt = app.IterationsSpinner.Value;
            
            % Incase the user directly goes for the analysis
            if isempty(app.user_selected_fullpathname)
                message1 = sprintf('Project file missing. \n 1.Create output file. \n 2.Run your analysis file!');
                uiconfirm(app.Plotter,message1,'MISSING',...
                    'Icon','info');
               
                [app.user_selected_fullpathname] = gta_userselected_outputpath;
                
                % checks whether there is a space in the path - throws error
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
                    outfoldermsg = strcat(outfoldermsg1,outfoldermsg2);
                    uialert(app.Plotter,outfoldermsg,'WRONG FILE NAMING',...
                        'Icon','error');
                end
            end
            
            % Analysis schema options - reuse the anlaysis scheme or not
            switch app.AnlaysisSchemaSwitch.Value
                case 'Old'
                    d0 = uiprogressdlg(app.Plotter,"Title",'Starting analysis ..',"Value",0);
                    [app.statusoptimize,app.cmdoptimize,app.full_filename_analysis,app.full_filename_output,file_output]= gta_optimize_cboxon(app.valueIt,app.user_selected_fullpathname,app.full_filename_analysis);
                case 'New'
                    %         [statusoptimize,cmdoptimize,app.full_filename_analysis,full_filename_output,file_output]= gta_optimize_cboxon(valueIt,app.user_selected_fullpathname,app.full_filename_analysis)
                    [app.statusoptimize,app.cmdoptimize,app.full_filename_analysis,app.full_filename_output,file_output]= gta_optimize(app.valueIt,app.user_selected_fullpathname);
                    d0 = uiprogressdlg(app.Plotter,"Title",'Starting analysis ..',"Value",0);
            end  %switch case end
            
            d1 = uiprogressdlg(app.Plotter,"Title",'Optimizing ..',"Value",0.25);
            app.AnalysisresultTextArea.Value = app.cmdoptimize;
            app.CurrentAnalysisSchemainuseLabel.Text = app.full_filename_analysis;
            display(app.full_filename_output)
            
            % Creating output directly in a new tab only if the optimization was successful,
            if  app.statusoptimize == 0
                %             [app.wavelength,app.time,app.lifetime,app.das,app.sas,app.normdas,app.normsas,app.lsv,app.rsv,app.fitdata,app.outdata,app.rms,app.conc,app.outfilename,app.kmat] = gta_quickreadoutput(app.statusoptimize,full_filename_output);
                [app.wavelength,app.time,app.lifetime,app.das,app.sas,app.normdas,app.normsas,app.lsv,app.rsv,app.fitdata,app.outdata,app.rms,app.conc,app.outfilename,app.kmat] = go2userchoice_output_v4(app.full_filename_output);
                app.t = app.TabGroup;
                app.out_fig = uitab(app.t);
                app.out_fig.Title = file_output;
                gta_output(app.out_fig,app.wavelength,app.das,app.sas,app.normdas,app.normsas,app.lsv,app.rsv,app.fitdata,app.outdata,app.rms,app.time,app.lifetime,app.conc,app.outfilename,app.kmat,app.cmdoptimize,app.t,app.out_fig.Title,app.user_selected_fullpathname);
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

        % Button pushed function: OpenProjectButton
        function OpenProjectButtonPushed(app, event)

            app.user_selected_fullpathname = uigetdir();
            try
            a = dir(app.user_selected_fullpathname);
            catch
                message_nofile = sprintf(' No files selected ');
                uialert(app.Plotter,message_nofile,'Message',...
                    'Icon','none');
                return
            end
            b = {a(:).name}';
            b(ismember(b,{'.','..','count.mat','optimized_parameter.csv','result.md'})) = [];
            app.uit = app.UITable;
            app.uit.Data = b;
            app.uit.RowName = 'numbered';
            app.CurrentDirectory.Value = app.user_selected_fullpathname;
        end

        % Cell selection callback: UITable
        function UITableCellSelection2(app, event)
            % Folder which contains .nc & .mat file for analysis summary
            % Folder segregation within the go2_userchoice_output_v4
            indices = event.Indices ;
            multi_select = numel(indices); % multiselection/comparision not implemented yet
            row = event.Indices(1);
            col = 1;
            app.user_tableselect = app.UITable.Data(row,col);
            % output plots / analysis output ?
            check = '.mat';
            if ~endsWith(app.user_tableselect,check)
                try
                % go2userchoice_output_v3 reads the nc file
                [app.wavelength,app.time,app.lifetime,app.das,app.sas,app.normdas,app.normsas,app.lsv,app.rsv,app.fitdata,app.outdata,app.rms,app.conc,app.outfilename,app.kmat] = go2userchoice_output_v4(app.full_filename_output,app.user_selected_fullpathname,app.user_tableselect);
                catch 
                    message_nofile = sprintf(' Cannot open / No files found');
                   uialert(app.Plotter,message_nofile,'Error',...
                    'Icon','error'); 
                return
                end
                app.t = app.TabGroup;
                app.out_fig = uitab(app.t);
                tabtitle = strcat(num2str(row),'.',string(app.user_tableselect));
                app.out_fig.Title = tabtitle;
                app.out_fig.ForegroundColor = 'r';
                gta_output(app.out_fig,app.wavelength,app.das,app.sas,app.normdas,app.normsas,app.lsv,app.rsv,app.fitdata,app.outdata,app.rms,app.time,app.lifetime,app.conc,app.outfilename,app.kmat,app.cmdoptimize,app.t,app.out_fig.Title);
             
            else
                % ends with .mat file
                
                cd(fullfile(app.user_selected_fullpathname))             
                app.t = app.TabGroup;
                app.out_fig = uitab(app.t); 
                % layout for plot and text area
                gg = uigridlayout(app.out_fig,[2 2]);              
                app.out_fig.Title = string(app.user_tableselect);
                tarea = uitextarea(gg);
                tarea.Layout.Column = 1;
                tarea.Layout.Row = [1 2];
                % save the matfile
                matfile = string(app.user_tableselect) ;
                res_opt = load(matfile);
                DataField = fieldnames(res_opt);
                % put the strings to text box
                tarea.Value = res_opt.(DataField{1});
                %tarea.Position = [10 10 600 700];
                tarea.FontColor = 'b';
                % create a text file
                textfile = erase(matfile,'.mat');
                textfilename = strcat(textfile,'.txt');
                % textfile created
                try
                writematrix(res_opt.(DataField{1}),textfilename,'Delimiter','tab')
                catch
                    message_nofile = res_opt.(DataField{1});
                    uialert(app.Plotter,message_nofile,'Error',...
                        'Icon','error');
                    delete(textfilename)
                    
%                     delete(textfile2)
                    return
                end
                    
                % look for the line numbers which will give the iterations details
                A1 = regexp(fileread(textfilename),'\n','split');
                start = find(contains(A1,'Iteration'))+1;
                upto = find(contains(A1,'maximum')) - 1; % doesnot work if mimimzation reached
                if isempty(upto) % when iterations has satisfies mimization function
                    upto = find(contains(A1,'termination')) - 1;
                end
                % reopen the textfile
                fid = fopen(textfilename,'r');
                str = textscan(fid,'%s','Delimiter','\n');
                fclose(fid);
                str2 = str{1}(start:upto);             
                %% Save as a new text file
                textfile2 = strcat(textfile,'final','.txt');
                fid2 = fopen(textfile2,'w');
                fprintf(fid2,'%s\n', str2{:});
                fclose(fid2);
                try
                A2 = dlmread(textfile2); % saved in A2 for plot
                catch
                    message_nofile = res_opt.(DataField{1});
                    uialert(app.Plotter,message_nofile,'Error',...
                        'Icon','error');
                    delete(textfilename)
                    delete(textfile2)
                    
                    return
                end
                %% plot
                ax0 = uiaxes(gg);               
                ax0.Layout.Column = 2;
                ax0.Layout.Row = 1;
                plot(ax0,A2(:,2),(A2(:,3)),'k','Marker','o','LineWidth',1.5,'MarkerEdgeColor','k','MarkerSize',10,'MarkerFaceColor','k');
                ax0.Title.String = 'Iterational changes';
                xlabel(ax0,'Iterations');
                ylabel(ax0,'Cost');
                legend(ax0,strcat('Total Iterations-',num2str(size(A2,1))));
                ax0.Box = 'on'; ax0.XGrid = 'on';ax0.YGrid = 'on';
                delete(textfilename)
                delete(textfile2)   
            end

        end

        % Button pushed function: CreateProjectButton
        function CreateProjectButtonPushed(app, event)
            try
                [app.user_selected_fullpathname,openname] = gta_userselected_outputpath;
            catch
                message_cancelopen = sprintf('Output folder not created');
                uialert(app.Plotter,message_cancelopen,'Message',...
                    'Icon','none');
                return
            end
            
            if ~isspace(app.user_selected_fullpathname)
                app.CurrentDirectory.Value = app.user_selected_fullpathname;
                app.CreateProjectTextArea.Value = app.user_selected_fullpathname;
                
                node1 = uitreenode(app.Tree,'Text',openname);
                node1 = uitreenode(node1,'Text','Dataset');
                node2 = uitreenode(app.Tree,'Text','Schema');
                node2a = uitreenode(node2,'Text','M-file');
                node2b = uitreenode(node2,'Text','P-file');
%                 scroll(app.Tree,'bottom','right');
                scroll(app.Tree,node2b)

            else
                outfoldermsg1 = sprintf('Path to filename must be without spaces: \n ');
                outfoldermsg2 = app.user_selected_fullpathname;
                outfoldermsg = strcat(outfoldermsg1,outfoldermsg2);
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
%             app.TabGroup.SelectedTab.Visible = 'off';
        end

        % Button pushed function: CaptureButton
        function CaptureButtonPushed(app, event)

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
%             figure()
            imshow(imgData)

%           end
        end

        % Menu selected function: CreateProjectMenu
        function CreateProjectMenuSelected(app, event)
            CreateProjectButtonPushed(app, event)
        end

        % Menu selected function: OpenProjectMenu
        function OpenProjectMenuSelected(app, event)
            OpenProjectButtonPushed(app, event)
        end

        % Menu selected function: VersionMenu
        function VersionMenuSelected(app, event)
            
            [status_version,cmd_version] = gta_version();
            
            if status_version == 0
                message_version = cmd_version;
                uialert(app.Plotter,message_version,'Glotaran-Version',...
                    'Icon','success');
            else
                msg1 = cmd_version;
                msg2 = sprintf('\n Please check the istallation or report issue. ');
                message_version = strcat(msg1,msg2) 
                uialert(app.Plotter,message_version,'Installation-error',...
                    'Icon','error');
            end

            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create Plotter and hide until all components are created
            app.Plotter = uifigure('Visible', 'off');
            app.Plotter.AutoResizeChildren = 'off';
            app.Plotter.Color = [1 1 1];
            app.Plotter.Colormap = [0.251 0.1647 0.7059;0.251 0.1686 0.7176;0.2549 0.1725 0.7294;0.2549 0.1765 0.7412;0.2588 0.1804 0.749;0.2588 0.1804 0.7608;0.2627 0.1882 0.7725;0.2627 0.1922 0.7843;0.2627 0.1961 0.7922;0.2667 0.2 0.8039;0.2667 0.2039 0.8157;0.2706 0.2078 0.8235;0.2706 0.2157 0.8353;0.2706 0.2196 0.8431;0.2745 0.2235 0.851;0.2745 0.2275 0.8627;0.2745 0.2314 0.8706;0.2745 0.2392 0.8784;0.2784 0.2431 0.8824;0.2784 0.2471 0.8902;0.2784 0.2549 0.898;0.2784 0.2588 0.902;0.2784 0.2667 0.9098;0.2784 0.2706 0.9137;0.2784 0.2745 0.9216;0.2824 0.2824 0.9255;0.2824 0.2863 0.9294;0.2824 0.2941 0.9333;0.2824 0.298 0.9412;0.2824 0.3059 0.9451;0.2824 0.3098 0.949;0.2824 0.3137 0.9529;0.2824 0.3216 0.9569;0.2824 0.3255 0.9608;0.2824 0.3294 0.9647;0.2784 0.3373 0.9686;0.2784 0.3412 0.9686;0.2784 0.349 0.9725;0.2784 0.3529 0.9765;0.2784 0.3569 0.9804;0.2784 0.3647 0.9804;0.2745 0.3686 0.9843;0.2745 0.3765 0.9843;0.2745 0.3804 0.9882;0.2706 0.3843 0.9882;0.2706 0.3922 0.9922;0.2667 0.3961 0.9922;0.2627 0.4039 0.9922;0.2627 0.4078 0.9961;0.2588 0.4157 0.9961;0.2549 0.4196 0.9961;0.251 0.4275 0.9961;0.2471 0.4314 1;0.2431 0.4392 1;0.2353 0.4431 1;0.2314 0.451 1;0.2235 0.4549 1;0.2196 0.4627 0.9961;0.2118 0.4667 0.9961;0.2078 0.4745 0.9922;0.2 0.4784 0.9922;0.1961 0.4863 0.9882;0.1922 0.4902 0.9882;0.1882 0.498 0.9843;0.1843 0.502 0.9804;0.1843 0.5098 0.9804;0.1804 0.5137 0.9765;0.1804 0.5176 0.9725;0.1804 0.5255 0.9725;0.1804 0.5294 0.9686;0.1765 0.5333 0.9647;0.1765 0.5412 0.9608;0.1765 0.5451 0.9569;0.1765 0.549 0.9529;0.1765 0.5569 0.949;0.1725 0.5608 0.9451;0.1725 0.5647 0.9412;0.1686 0.5686 0.9373;0.1647 0.5765 0.9333;0.1608 0.5804 0.9294;0.1569 0.5843 0.9255;0.1529 0.5922 0.9216;0.1529 0.5961 0.9176;0.149 0.6 0.9137;0.149 0.6039 0.9098;0.1451 0.6078 0.9098;0.1451 0.6118 0.9059;0.1412 0.6196 0.902;0.1412 0.6235 0.898;0.1373 0.6275 0.898;0.1373 0.6314 0.8941;0.1333 0.6353 0.8941;0.1294 0.6392 0.8902;0.1255 0.6471 0.8902;0.1216 0.651 0.8863;0.1176 0.6549 0.8824;0.1137 0.6588 0.8824;0.1137 0.6627 0.8784;0.1098 0.6667 0.8745;0.1059 0.6706 0.8706;0.102 0.6745 0.8667;0.098 0.6784 0.8627;0.0902 0.6824 0.8549;0.0863 0.6863 0.851;0.0784 0.6902 0.8471;0.0706 0.6941 0.8392;0.0627 0.698 0.8353;0.0549 0.702 0.8314;0.0431 0.702 0.8235;0.0314 0.7059 0.8196;0.0235 0.7098 0.8118;0.0157 0.7137 0.8078;0.0078 0.7176 0.8;0.0039 0.7176 0.7922;0 0.7216 0.7882;0 0.7255 0.7804;0 0.7294 0.7765;0.0039 0.7294 0.7686;0.0078 0.7333 0.7608;0.0157 0.7333 0.7569;0.0235 0.7373 0.749;0.0353 0.7412 0.7412;0.051 0.7412 0.7373;0.0627 0.7451 0.7294;0.0784 0.7451 0.7216;0.0902 0.749 0.7137;0.102 0.7529 0.7098;0.1137 0.7529 0.702;0.1255 0.7569 0.6941;0.1373 0.7569 0.6863;0.1451 0.7608 0.6824;0.1529 0.7608 0.6745;0.1608 0.7647 0.6667;0.1686 0.7647 0.6588;0.1725 0.7686 0.651;0.1804 0.7686 0.6471;0.1843 0.7725 0.6392;0.1922 0.7725 0.6314;0.1961 0.7765 0.6235;0.2 0.7804 0.6157;0.2078 0.7804 0.6078;0.2118 0.7843 0.6;0.2196 0.7843 0.5882;0.2235 0.7882 0.5804;0.2314 0.7882 0.5725;0.2392 0.7922 0.5647;0.251 0.7922 0.5529;0.2588 0.7922 0.5451;0.2706 0.7961 0.5373;0.2824 0.7961 0.5255;0.2941 0.7961 0.5176;0.3059 0.8 0.5059;0.3176 0.8 0.498;0.3294 0.8 0.4863;0.3412 0.8 0.4784;0.3529 0.8 0.4667;0.3686 0.8039 0.4549;0.3804 0.8039 0.4471;0.3922 0.8039 0.4353;0.4039 0.8039 0.4235;0.4196 0.8039 0.4118;0.4314 0.8039 0.4;0.4471 0.8039 0.3922;0.4627 0.8 0.3804;0.4745 0.8 0.3686;0.4902 0.8 0.3569;0.5059 0.8 0.349;0.5176 0.8 0.3373;0.5333 0.7961 0.3255;0.5451 0.7961 0.3176;0.5608 0.7961 0.3059;0.5765 0.7922 0.2941;0.5882 0.7922 0.2824;0.6039 0.7882 0.2745;0.6157 0.7882 0.2627;0.6314 0.7843 0.251;0.6431 0.7843 0.2431;0.6549 0.7804 0.2314;0.6706 0.7804 0.2235;0.6824 0.7765 0.2157;0.698 0.7765 0.2078;0.7098 0.7725 0.2;0.7216 0.7686 0.1922;0.7333 0.7686 0.1843;0.7451 0.7647 0.1765;0.7608 0.7647 0.1725;0.7725 0.7608 0.1647;0.7843 0.7569 0.1608;0.7961 0.7569 0.1569;0.8078 0.7529 0.1529;0.8157 0.749 0.1529;0.8275 0.749 0.1529;0.8392 0.7451 0.1529;0.851 0.7451 0.1569;0.8588 0.7412 0.1569;0.8706 0.7373 0.1608;0.8824 0.7373 0.1647;0.8902 0.7373 0.1686;0.902 0.7333 0.1765;0.9098 0.7333 0.1804;0.9176 0.7294 0.1882;0.9255 0.7294 0.1961;0.9373 0.7294 0.2078;0.9451 0.7294 0.2157;0.9529 0.7294 0.2235;0.9608 0.7294 0.2314;0.9686 0.7294 0.2392;0.9765 0.7294 0.2431;0.9843 0.7333 0.2431;0.9882 0.7373 0.2431;0.9961 0.7412 0.2392;0.9961 0.7451 0.2353;0.9961 0.7529 0.2314;0.9961 0.7569 0.2275;0.9961 0.7608 0.2235;0.9961 0.7686 0.2196;0.9961 0.7725 0.2157;0.9961 0.7804 0.2078;0.9961 0.7843 0.2039;0.9961 0.7922 0.2;0.9922 0.7961 0.1961;0.9922 0.8039 0.1922;0.9922 0.8078 0.1922;0.9882 0.8157 0.1882;0.9843 0.8235 0.1843;0.9843 0.8275 0.1804;0.9804 0.8353 0.1804;0.9765 0.8392 0.1765;0.9765 0.8471 0.1725;0.9725 0.851 0.1686;0.9686 0.8588 0.1647;0.9686 0.8667 0.1647;0.9647 0.8706 0.1608;0.9647 0.8784 0.1569;0.9608 0.8824 0.1569;0.9608 0.8902 0.1529;0.9608 0.898 0.149;0.9608 0.902 0.149;0.9608 0.9098 0.1451;0.9608 0.9137 0.1412;0.9608 0.9216 0.1373;0.9608 0.9255 0.1333;0.9608 0.9333 0.1294;0.9647 0.9373 0.1255;0.9647 0.9451 0.1216;0.9647 0.949 0.1176;0.9686 0.9569 0.1098;0.9686 0.9608 0.1059;0.9725 0.9686 0.102;0.9725 0.9725 0.0941;0.9765 0.9765 0.0863;0.9765 0.9843 0.0824;1 1 1;1 1 1;1 1 1;1 1 1;1 1 1;1 1 1;1 1 1];
            app.Plotter.Position = [10 500 1400 900];
            app.Plotter.Name = 'Plotter';
            app.Plotter.Resize = 'off';
            app.Plotter.Scrollable = 'on';

            % Create FileMenu
            app.FileMenu = uimenu(app.Plotter);
            app.FileMenu.Text = 'File';

            % Create CreateProjectMenu
            app.CreateProjectMenu = uimenu(app.FileMenu);
            app.CreateProjectMenu.MenuSelectedFcn = createCallbackFcn(app, @CreateProjectMenuSelected, true);
            app.CreateProjectMenu.Text = 'Create Project';

            % Create OpenProjectMenu
            app.OpenProjectMenu = uimenu(app.FileMenu);
            app.OpenProjectMenu.MenuSelectedFcn = createCallbackFcn(app, @OpenProjectMenuSelected, true);
            app.OpenProjectMenu.Text = 'Open Project';

            % Create EditMenu
            app.EditMenu = uimenu(app.Plotter);
            app.EditMenu.Text = 'Edit';

            % Create HelpMenu
            app.HelpMenu = uimenu(app.Plotter);
            app.HelpMenu.Text = 'Help';

            % Create VersionMenu
            app.VersionMenu = uimenu(app.HelpMenu);
            app.VersionMenu.MenuSelectedFcn = createCallbackFcn(app, @VersionMenuSelected, true);
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
            app.Tree.Position = [12 445 169 321];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.Plotter);
            app.TabGroup.AutoResizeChildren = 'off';
            app.TabGroup.HandleVisibility = 'off';
            app.TabGroup.Position = [200 83 956 755];

            % Create Tab
            app.Tab = uitab(app.TabGroup);
            app.Tab.AutoResizeChildren = 'off';
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
            app.IterationsSpinnerLabel.Position = [14 404 81 22];
            app.IterationsSpinnerLabel.Text = 'Iterations';

            % Create IterationsSpinner
            app.IterationsSpinner = uispinner(app.Plotter);
            app.IterationsSpinner.ValueChangedFcn = createCallbackFcn(app, @IterationsSpinnerValueChanged, true);
            app.IterationsSpinner.HorizontalAlignment = 'center';
            app.IterationsSpinner.FontWeight = 'bold';
            app.IterationsSpinner.Position = [99 404 66 22];
            app.IterationsSpinner.Value = 1;

            % Create OpenProjectButton
            app.OpenProjectButton = uibutton(app.Plotter, 'push');
            app.OpenProjectButton.ButtonPushedFcn = createCallbackFcn(app, @OpenProjectButtonPushed, true);
            app.OpenProjectButton.Icon = 'icons8-opened-folder-480.png';
            app.OpenProjectButton.FontName = 'Trebuchet MS';
            app.OpenProjectButton.FontWeight = 'bold';
            app.OpenProjectButton.Tooltip = {'Open output folder.'};
            app.OpenProjectButton.Position = [73 812 47 28];
            app.OpenProjectButton.Text = '';

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
            app.UITable.Position = [1165 265 209 586];

            % Create CreateProjectButton
            app.CreateProjectButton = uibutton(app.Plotter, 'push');
            app.CreateProjectButton.ButtonPushedFcn = createCallbackFcn(app, @CreateProjectButtonPushed, true);
            app.CreateProjectButton.Icon = 'icons8-add-folder-48.png';
            app.CreateProjectButton.FontName = 'Trebuchet MS';
            app.CreateProjectButton.FontWeight = 'bold';
            app.CreateProjectButton.Tooltip = {'Create new folder. Folder name / path to folder name must be without spaces.'};
            app.CreateProjectButton.Position = [14 812 47 28];
            app.CreateProjectButton.Text = '';

            % Create CreateProjectTextArea
            app.CreateProjectTextArea = uitextarea(app.Plotter);
            app.CreateProjectTextArea.FontSize = 10;
            app.CreateProjectTextArea.FontWeight = 'bold';
            app.CreateProjectTextArea.FontAngle = 'italic';
            app.CreateProjectTextArea.FontColor = [0 0 1];
            app.CreateProjectTextArea.Position = [12 775 169 25];
            app.CreateProjectTextArea.Value = {'Current project - directory'};

            % Create CurrentDirectory
            app.CurrentDirectory = uitextarea(app.Plotter);
            app.CurrentDirectory.FontSize = 10;
            app.CurrentDirectory.FontWeight = 'bold';
            app.CurrentDirectory.FontAngle = 'italic';
            app.CurrentDirectory.FontColor = [0 0 1];
            app.CurrentDirectory.Position = [1165 860 209 30];
            app.CurrentDirectory.Value = {'Current output - directory'};

            % Create Panel
            app.Panel = uipanel(app.Plotter);
            app.Panel.AutoResizeChildren = 'off';
            app.Panel.Title = 'Panel';
            app.Panel.Position = [200 841 955 60];

            % Create ModelButton
            app.ModelButton = uibutton(app.Panel, 'push');
            app.ModelButton.Position = [13 7 100 22];
            app.ModelButton.Text = 'Model';

            % Create ParameterButton
            app.ParameterButton = uibutton(app.Panel, 'push');
            app.ParameterButton.Position = [132 7 100 22];
            app.ParameterButton.Text = 'Parameter';

            % Create DeleteTabButton
            app.DeleteTabButton = uibutton(app.Panel, 'push');
            app.DeleteTabButton.ButtonPushedFcn = createCallbackFcn(app, @DeleteTabButtonPushed, true);
            app.DeleteTabButton.Icon = 'close-window-512.png';
            app.DeleteTabButton.IconAlignment = 'center';
            app.DeleteTabButton.HorizontalAlignment = 'left';
            app.DeleteTabButton.VerticalAlignment = 'top';
            app.DeleteTabButton.FontSize = 14;
            app.DeleteTabButton.FontWeight = 'bold';
            app.DeleteTabButton.Tooltip = {'Close selected tab.'};
            app.DeleteTabButton.Position = [923 9 24 26];
            app.DeleteTabButton.Text = '';

            % Create CaptureButton
            app.CaptureButton = uibutton(app.Panel, 'push');
            app.CaptureButton.ButtonPushedFcn = createCallbackFcn(app, @CaptureButtonPushed, true);
            app.CaptureButton.Icon = 'icons8-screenshot-50.png';
            app.CaptureButton.IconAlignment = 'center';
            app.CaptureButton.HorizontalAlignment = 'left';
            app.CaptureButton.VerticalAlignment = 'top';
            app.CaptureButton.FontWeight = 'bold';
            app.CaptureButton.Tooltip = {'Screenshot.'};
            app.CaptureButton.Position = [886 9 24 26];
            app.CaptureButton.Text = '';

            % Create RunAnalysisPanel
            app.RunAnalysisPanel = uipanel(app.Plotter);
            app.RunAnalysisPanel.AutoResizeChildren = 'off';
            app.RunAnalysisPanel.BackgroundColor = [1 1 1];
            app.RunAnalysisPanel.Position = [14 259 167 136];

            % Create StartAnalysis
            app.StartAnalysis = uibutton(app.RunAnalysisPanel, 'state');
            app.StartAnalysis.ValueChangedFcn = createCallbackFcn(app, @StartAnalysisValueChanged, true);
            app.StartAnalysis.Tooltip = {'Run Analysis '};
            app.StartAnalysis.Icon = 'img_319547.png';
            app.StartAnalysis.Text = {'Start'; ''};
            app.StartAnalysis.BackgroundColor = [1 1 1];
            app.StartAnalysis.FontWeight = 'bold';
            app.StartAnalysis.Position = [46 94 69 33];

            % Create AnlaysisSchemaSwitchLabel
            app.AnlaysisSchemaSwitchLabel = uilabel(app.RunAnalysisPanel);
            app.AnlaysisSchemaSwitchLabel.HorizontalAlignment = 'center';
            app.AnlaysisSchemaSwitchLabel.FontSize = 10;
            app.AnlaysisSchemaSwitchLabel.Position = [40 32 82 22];
            app.AnlaysisSchemaSwitchLabel.Text = 'Anlaysis Schema';

            % Create AnlaysisSchemaSwitch
            app.AnlaysisSchemaSwitch = uiswitch(app.RunAnalysisPanel, 'slider');
            app.AnlaysisSchemaSwitch.Items = {'New', 'Old'};
            app.AnlaysisSchemaSwitch.ValueChangedFcn = createCallbackFcn(app, @AnlaysisSchemaSwitchValueChanged, true);
            app.AnlaysisSchemaSwitch.Tooltip = {'Whether previously used analysis schema will be used. '};
            app.AnlaysisSchemaSwitch.Position = [69 60 22 10];
            app.AnlaysisSchemaSwitch.Value = 'New';

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