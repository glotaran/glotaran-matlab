function mydialog(out_fig)
    d = dialog('Position',[300 300 250 150],'Name','My Dialog');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String','Click the close button when you''re done.');

       btn1 = uibutton('Parent',d,'push',...
                        'ButtonPushedFcn', @(btn1,event) traceButtonPushed(btn1,editmax));
       btn1.Visible = 'on';
       btn1.Text = 'Get Traces';
       btn1.FontColor = 'm';       
end