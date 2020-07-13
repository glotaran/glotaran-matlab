function [grid1,p,ax,grid2,time] = gta_dataload_GUI_v1(f,filename,data,dataf,wavelength,time,U,S,V,chk)
% [f,grid1,p,ax,grid2,time] = gta_dataload_GUI_v1(filename,data,dataf,wavelength,time,U,S,V,chk)
% [filename,data,dataf,wavelength,time,U,S,V,chk] = gta_loaddataset
% Data Exploration-UI  

% Filename as loaded from the loaddataset function
            
%              f = uifigure('Name','Data-exploration');
%              f = app.DataExplorerTab;
% Grid1 is created over the uifigure f
           
            grid1 = uigridlayout(f);
            grid1.RowHeight = {'1x'};
            grid1.ColumnWidth= {180,'1x'};

% panel p created over the grid1

            p = uipanel(grid1);
            p.Title = filename; 
%             p.BorderType = 'none';
           
% Create grid2 in the panel p 
            grid2 = uigridlayout(p);
            grid2.RowHeight = {22, 22, 22, 22, 22};
            grid2.ColumnWidth = {'1x'};
%           grid2.ColumnWidth{2} = 0         
            
% ax axes creates the loaded dataset image
            ax = uiaxes(grid1);
            ax.Layout.Column = [2 4];
            switch chk
                case 1
                imagesc(ax,wavelength,time,dataf); 
                wavemin = fix(min(wavelength));
                wavemax = ceil(max(wavelength));
                timemin = fix(min(time));
                timemax = ceil(max(time));
                ax.XLim = [wavemin wavemax];
                ax.YLim = [timemin timemax];
                xlabel(ax,'Wavelength(nm)');
                ylabel(ax,'Time (ns)');
                cb = colorbar(ax);
                cb.Box = 'off';
                ax.Box = 'on';
                ax.LineWidth = 1.5;
%                 ax.XLim = [0 ax.XData(2)];
%                 ax.YLim = [0 ax.YData(2)];
%                ax.Title.String = filename;
                case 0
                imagesc(ax,wavelength,time,dataf'); 
                wavemin = fix(min(wavelength));
                wavemax = ceil(max(wavelength));
                timemin = fix(min(time));
                timemax = ceil(max(time));
                ax.XLim = [wavemin wavemax];
                ax.YLim = [timemin timemax];
                xlabel(ax,'Wavelength(nm)');
                ylabel(ax,'Time (ns)');
                cb = colorbar(ax);
                cb.Box = 'off';
                ax.Box = 'on';
                ax.LineWidth = 1.5;
%                ax.Title.String = filename; 
                case 9
                    
                imagesc(ax,wavelength,time,dataf'); 
                wavemin = fix(min(wavelength));
                wavemax = ceil(max(wavelength));
                timemin = fix(min(time));
                timemax = ceil(max(time));
                ax.XLim = [wavemin wavemax];
                ax.YLim = [timemin timemax];
                xlabel(ax,'Wavelength(nm)');
                ylabel(ax,'Time (ns)');
                cb = colorbar(ax);
                cb.Box = 'off';
                ax.Box = 'on';
                ax.LineWidth = 1.5;
%                 ax.Title.String = filename;
            end
            
% hiding the rows below to see a enlarge view of the load dataset 
            grid1.RowHeight{2} = 0;  
%           grid1.ColumnWidth{1} = 0;
%%
% create new axes for SVD plots
             ax1 = uiaxes(grid1);
             ax1.Layout.Row = 2;
             ax1.Layout.Column = 2;
%            ax1.HandleVisibility = 'off';
             ax1.YGrid = 'on';
             ax1.GridColor = [0 0 0];
             
             ax2 = uiaxes(grid1);
             ax2.Layout.Row = 2;
             ax2.Layout.Column = 3;
%            ax2.HandleVisibility = 'off';
             ax2.YGrid = 'on';
             ax2.GridColor = [0 0 0];
             
             ax3 = uiaxes(grid1);
             ax3.Layout.Row = 2;
             ax3.Layout.Column = 4;
%            ax2.HandleVisibility = 'off';
%              ax3.YGrid = 'on';
%              ax3.GridColor = [0 0 0];
%%             
% create other requirments 
             % Add method label and drop-down
             % findMethodLabel = uilabel(grid2,'Text','Properties');
             findMethod = uidropdown(grid2);
             findMethod.Items = {'Data','SVD','Crop-Data','Save-crop Data'};
             findMethod.ValueChangedFcn = @button_callback;
%              ef = uieditfield(grid2,'numeric','RoundFractionalValues','on');
%%
% call the function of uispinned @gta_updayeSlider             
            spn = uispinner(grid2,'Value',2,...
                'Position',[100 140 100 22],'ValueDisplayFormat','%.0f SVD',...
                'ValueChangedFcn',@(spn,event) gta_updateSlider(spn,time,V,ax,ax1,ax2,wavelength,U,chk));
            spn.Limits = [1 size(wavelength,1)];
%%
% 
       editmax = uieditfield(grid2,'numeric','Value', 0,'ValueDisplayFormat','%.0f Crop_Min-wavelength');
       editmin = uieditfield(grid2,'numeric','Value', 0,'ValueDisplayFormat','%.0f Crop_Max-wavelength');
%      uieditfield(grid2);  
%        nl = uigridlayout(grid2); 
%        nl.Layout.Row = 3;
%        nl.Layout.Column = 2;
      [cropmin,cropmax] = gta_cropButtonPushed(editmax,editmin);

       btn = uibutton(grid2,'push','Position',[100 10 10 10],...
                        'ButtonPushedFcn', @(btn,event) gta_buttonsavedata(cropmin,cropmax,wavelength,dataf,time));
       btn.Visible = 'on';
       btn.Text = 'Save to folder';
%%   
% create a new button for saving to path

%%    
     function button_callback(src,ev)
         method = src.Value;
         switch method
            case 'Data'
                if chk == 0 | chk == 9 
                grid1.RowHeight{2} = 0;
%                 grid2.RowHeight{3} = 0;
%                 grid2.ColumnWidth{2} = 0;
                imagesc(ax,wavelength,time,dataf'); 
                
                xlabel(ax,'Wavelength(nm)');
                ylabel(ax,'Time (ns)');
%                 ax.Title.String = filename;
                else
                    grid1.RowHeight{2} = 0; 
                    imagesc(ax,wavelength,time,dataf);  
                    xlabel(ax,'Wavelength(nm)');
                    ylabel(ax,'Time (ns)');
                    ax.Title.String = filename;
                end
                wavemin = fix(min(wavelength));
                wavemax = ceil(max(wavelength));
                timemin = fix(min(time));
                timemax = ceil(max(time));
                ax.XLim = [wavemin wavemax];
                ax.YLim = [timemin timemax];
                
            case 'SVD'
%                 grid1.RowHeight{1} = 0 ;
%                grid2.ColumnWidth = {80,'1x'};
%                grid2.RowHeight{3} = 0;
               grid1.RowHeight{2} = '1x'; % brings back the axes for SVD plotting
%                grid2.RowHeight{2} = 0; % removes the row for edit
               gta_updateSlider(spn,time,V,ax,ax1,ax2,wavelength,U,chk);
               
                   s2 = log10(diag(S));
%                s2 = 10.^s2;
                   if size(s2,1)>20
                       s2 = s2(1:20);
                   end
               screeind = linspace(1,size(s2,1),size(s2,1));
               plot(ax3,screeind,s2,'-k s')
%                set(ax3,'ytick',[])
               xlabel(ax3,'Singular value index (n)');
               ylabel(ax3,'Log(SVn)');
               ax3.Title.String = 'Screeplot';
               
               ax1.XGrid = 'on';
               ax1.YGrid = 'on';              
               ax2.XGrid = 'on';
               ax2.YGrid = 'on';               
               ax3.XGrid = 'on';
               ax3.YGrid = 'on';
               
%                ax1.Color = [0.7 0.7 0.7];
%                ax2.Color = [0.7 0.7 0.7];
%                ax3.Color = [0.7 0.7 0.7];
               ax1.LineWidth = 1.5;  
               ax2.LineWidth = 1.5;
               ax3.LineWidth = 1.5;
               
               ax1.Box = 'on';
               ax2.Box = 'on';
               ax3.Box = 'on';
               
               
               
            case 'Crop-Data'

                 [cropmin,cropmax] = gta_cropButtonPushed(editmax,editmin);

                 [cutdata,wavelengthcut] = gta_cropdata(ax,cropmin,cropmax,wavelength,dataf,time);
                 
%                   save('saveA.mat','cutdata');
%                   wavelengthcut;
%                   ax.XLim = [cropmin cropmax];
%% works
%                 grid1.RowHeight{2} = 0;
%                 grid2.RowHeight{3} = 0;
%                 gta_cropdata(650,750,wavelength,dataf)
%                [cutdata,wavelengthcut] = gta_cropdata(650,750,wavelength,dataf)
%                 imagesc(ax,wavelengthcut,time,cutdata');
             case 'Save-crop Data'
                 [cropmin,cropmax] = gta_cropButtonPushed(editmax,editmin);
                 [cutdata,wavelengthcut] = gta_cropdata_noplot(cropmin,cropmax,wavelength,dataf,time);
                 gta_savecropdata(ax,cutdata,wavelengthcut,time);
%              case 'Reopen-saved Data'
%                   [filename,data,dataf,wavelength,time,U,S,V,chk] = gta_loadsaveddata()
%                    p.Title = filename; 
               

                       
                     
                 
          end
       end
                 
                
end
 
   


    
    
 
    

