function gta_output(out_fig,wavelength,das,sas,normdas,normsas,lsv,rsv,fitdata,outdata,rms,time,lifetime,conc,outfilename,kmat,cmdoptimize,t,t1,pathname_ana_file)
%[wavelength,time,lifetime,das,sas,normdas,normsas,lsv,rsv,fitdata,outdata,rms,conc,outfilename] = readpyglot()
% for the callback from the table 
% 

           
            out_grid1 = uigridlayout(out_fig);
            out_grid1.RowHeight = {'1x'};
            out_grid1.ColumnWidth= {180,'1x'};

% panel out_p created over the grid1

            out_p = uipanel(out_grid1);
            out_p.Title = outfilename; 
%             p.BorderType = 'none';
           
% Create grid2 in the panel p 
            out_grid2 = uigridlayout(out_p);
            out_grid2.RowHeight = {22, 22, 22, 22};
            out_grid2.ColumnWidth = {'1x'};
%           grid2.ColumnWidth{2} = 0         
            
% axes loads the results directly
            out_ax0 = uiaxes(out_grid1);
            out_ax1 = uiaxes(out_grid1);          
            out_ax0.Layout.Column = 2;
            out_ax0.Layout.Row = 1;       
            out_ax1.Layout.Column = 3;
            out_ax1.Layout.Row = 1;
            
            plot(out_ax0,wavelength,das,"LineWidth",1.5);
            plot(out_ax1,wavelength,normdas,"LineWidth",1.5);
            xlabel(out_ax0,'Wavelength(nm)');
            ylabel(out_ax0,'DAS');
            xlabel(out_ax1,'Wavelength(nm)');
            ylabel(out_ax1,'DAS norm');
            out_ax0.Title.String = 'Parallel Model';
            out_ax1.Title.String = 'Parallel Model';
            
            out_ax2 = uiaxes(out_grid1);
            out_ax3 = uiaxes(out_grid1);   
            out_ax2.Layout.Column = 2;
            out_ax2.Layout.Row = 2;       
            out_ax3.Layout.Column = 3;
            out_ax3.Layout.Row = 2;
            
            plot(out_ax2,wavelength,sas,"LineWidth",1.5);
            plot(out_ax3,wavelength,normsas,"LineWidth",1.5);
            out_ax2.Title.String = 'Target Model';
            out_ax3.Title.String = 'Target Model';
            
            xlabel(out_ax2,'Wavelength(nm)');
            ylabel(out_ax2,'SAS');
            xlabel(out_ax3,'Wavelength(nm)');
            ylabel(out_ax3,'SAS norm');
            
            out_ax4 = uiaxes(out_grid1);
            out_ax5 = uiaxes(out_grid1);
            out_ax4.Layout.Column = 2;
            out_ax4.Layout.Row = 3;       
            out_ax5.Layout.Column = 3;
            out_ax5.Layout.Row = 3;
            
            plot(out_ax4,wavelength,rsv,"LineWidth",1.5);
            plot(out_ax5,time,lsv,"LineWidth",1.5);
            out_ax4.Title.String = 'Right singular vector';
            out_ax5.Title.String = 'Left singular vector';
            xlabel(out_ax4,'Wavelength (nm)');
            ylabel(out_ax4,'Intensity');
            xlabel(out_ax5,'Time (ns)');
            ylabel(out_ax5,'Intensity');
            
            out_ax6 = uiaxes(out_grid1);
            out_ax7 = uiaxes(out_grid1);
            out_ax6.Layout.Column = 4;
            out_ax6.Layout.Row = 1;       
            out_ax7.Layout.Column = 4;
            out_ax7.Layout.Row = 2;
            
            imagesc(out_ax6,wavelength,time,outdata');
            imagesc(out_ax7,wavelength,time,fitdata');
            
            xlabel(out_ax6,'Wavelength(nm)');
            ylabel(out_ax6,'Time (ns)');
            out_ax6.Title.String = 'Original Data';
            xlabel(out_ax7,'Wavelength(nm)');
            ylabel(out_ax7,'Time (ns)');
            out_ax7.Title.String = 'Fitted Data';
            
             out_ax8 = uiaxes(out_grid1);
             out_ax8.Layout.Column = 4;
             out_ax8.Layout.Row = 3;
             plot(out_ax8,time,conc,"LineWidth",1.5);
             xlabel(out_ax8,'Time (ns)');
             ylabel(out_ax8,'Concentration');
             out_ax8.Title.String = 'Concentration profile'  ;          
%              out_fig.BackgroundColor = '#e6daa6';%'#d1b26f';;
             out_fig.BackgroundColor = [0.65 0.65 0.65];
             
             out_ax0.Box = 'on'; out_ax0.XGrid = 'on';out_ax0.YGrid = 'on';
             out_ax1.Box = 'on'; out_ax1.XGrid = 'on';out_ax1.YGrid = 'on';
             out_ax2.Box = 'on'; out_ax2.XGrid = 'on';out_ax2.YGrid = 'on';
             out_ax3.Box = 'on'; out_ax3.XGrid = 'on';out_ax3.YGrid = 'on';
             out_ax4.Box = 'on'; out_ax4.XGrid = 'on';out_ax4.YGrid = 'on';
             out_ax5.Box = 'on'; out_ax5.XGrid = 'on';out_ax5.YGrid = 'on';
             out_ax6.Box = 'on'; out_ax6.XGrid = 'on';out_ax6.YGrid = 'on';
             out_ax7.Box = 'on'; out_ax7.XGrid = 'on';out_ax7.YGrid = 'on';
             out_ax8.Box = 'on'; out_ax8.XGrid = 'on';out_ax8.YGrid = 'on';
%%             
% create other requirments 
             % Add method label and drop-down
             % findMethodLabel = uilabel(grid2,'Text','Properties');
             findMethod = uidropdown(out_grid2);
             findMethod.Items = {'Summary'};
             findMethod.ValueChangedFcn = @button_callback;
%              ef = uieditfield(grid2,'numeric','RoundFractionalValues','on');
%%
% call the function of uispinned @gta_updayeSlider             
%             spn = uispinner(out_grid2,'Value',1,...
%                 'Position',[100 140 100 22],'ValueDisplayFormat','%.0f SVD',...
%                 'ValueChangedFcn',@(spn,event) gta_updateSlider(spn,time,V,out_ax0,ax1,ax2,wavelength,U));
%             spn.Limits = [1 15];
%%
% 
       editmax = uieditfield(out_grid2,'numeric','Value', 1,'ValueDisplayFormat','%.0f No. of traces');
%        editmin = uieditfield(out_grid2,'numeric','Value', 0,'ValueDisplayFormat','%.0f Crop_Max-wavelength');
%      uieditfield(grid2);  
%%   lifetime & Rms within uitextarea    
       otxa = uitextarea(out_grid1);
       otxa.Layout.Column = 1;
       otxa.Layout.Row = 2;
       
      [text] = textbox_lifetime(lifetime,rms) ;  
       otxa.Value = text;
       otxa.FontName = 'Arial';
       otxa.FontColor = 'k';
%        otxa.BackgroundColor = [1 1 1];
       otxa.FontAngle = 'italic';
%        otxa.FontWeight = 'bold';
       otxa.FontSize = 12;
%        otxa.BackgroundColor = '#e6daa6';
       otxa.BackgroundColor = [0.94 0.94 0.94];
%% button for plot trace, input from edit
       btn_n = uibutton(out_grid2,'push',...
                        'ButtonPushedFcn', @(btn1,event) traceButtonPushed(btn1,editmax));
       btn_n.Visible = 'on';
       btn_n.Text = 'Get Traces';
       btn_n.FontColor = 'm';
       
    function traceButtonPushed(~,editmax)               
    [val] = gta_gettracevalue(editmax);
     g = gta_plottrace(val,outdata,wavelength,time,fitdata,out_fig,t,t1);
%     out_fig.ForegroundColor = 'm';
    end
  
    
%% create new panel then grid of 4 within panel 
%             out_p2 = uipanel(out_grid1);
%             out_p2.Title = 'Options'
%             out_p2.Layout.Column = 1;
%             out_p2.Layout.Row = 3;
%             
%             og3 = uigridlayout(out_p2);

%% delete tab in new grid3
%            btn = uibutton(og3,'push',...
%                'Position',[85 20 70 25],...
%                'ButtonPushedFcn', @(btn,event) deletetabButtonPushed(btn,out_fig));
%            btn.Text = 'Close Tab' ;
%            btn.FontColor = 'r';
%            btn.Layout.Column = 1;
%            btn.Layout.Row = 3;
%     
%     function deletetabButtonPushed(btn,out_fig)
%                 delete(out_fig)
%     end
%% button nodal
           btn_n = uibutton(out_grid2,'push',...
                        'ButtonPushedFcn', @(btn1,event) nodalButtonPushed(btn_n,kmat,out_fig,t,t1));
       btn_n.Visible = 'on';
       btn_n.Text = 'Create Nodal';
       btn_n.FontColor = '#06470c';
       
    function nodalButtonPushed(~,kmat,out_fig,t,t1)               
     gta_nodal(kmat,out_fig,t,t1)
%      g = gta_plottrace(val,outdata,wavelength,time,fitdata,out_fig,t,t1);
%     out_fig.ForegroundColor = 'm';
    end
%%    
     function button_callback(src,ev)
         method = src.Value;
         switch method
                 
            case 'Summary'
                cla(out_ax0)
                cla(out_ax1)
                out_grid1.RowHeight{4} = 0;
                out_ax0 = uiaxes(out_grid1);
                out_ax1 = uiaxes(out_grid1);           
                out_ax0.Layout.Column = 2;
                out_ax0.Layout.Row = 1;       
                out_ax1.Layout.Column = 3;
                out_ax1.Layout.Row = 1;

                plot(out_ax0,wavelength,das,"LineWidth",1.5);
                plot(out_ax1,wavelength,normdas,"LineWidth",1.5);

                out_ax2 = uiaxes(out_grid1);
                out_ax3 = uiaxes(out_grid1);   
                out_ax2.Layout.Column = 2;
                out_ax2.Layout.Row = 2;       
                out_ax3.Layout.Column = 3;
                out_ax3.Layout.Row = 2;

                plot(out_ax2,wavelength,sas,"LineWidth",1.5);
                plot(out_ax3,wavelength,normsas,"LineWidth",1.5);

                out_ax4 = uiaxes(out_grid1);
                out_ax5 = uiaxes(out_grid1);
                out_ax4.Layout.Column = 2;
                out_ax4.Layout.Row = 3;       
                out_ax5.Layout.Column = 3;
                out_ax5.Layout.Row = 3;

                plot(out_ax4,wavelength,rsv,"LineWidth",1.5);
                plot(out_ax5,time,lsv,"LineWidth",1.5);

                out_ax6 = uiaxes(out_grid1);
                out_ax7 = uiaxes(out_grid1);
                out_ax6.Layout.Column = 4;
                out_ax6.Layout.Row = 1;       
                out_ax7.Layout.Column = 4;
                out_ax7.Layout.Row = 2;

                imagesc(out_ax6,wavelength,time,outdata');
                imagesc(out_ax7,wavelength,time,fitdata');

                out_ax8 = uiaxes(out_grid1);
                out_ax8.Layout.Column = 4;
                out_ax8.Layout.Row = 3;
                plot(out_ax8,time,conc,"LineWidth",1.5);


                
                               
          end
     end
                 
%             CButton = uibutton(out_fig, 'state');
% %             app.CButton.HorizontalAlignment = 'left';
%             CButton.Text = 'C';
%             CButton.FontSize = 8;
%             CButton.Position = [11 731 100 100];             
%              m = uimenu(out_fig);
%              m.Text = 'Open Selection';
end