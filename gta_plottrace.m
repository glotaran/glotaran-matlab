function gta_plottrace(val,outdata,wavelength,time,fitdata)
        Number = round(val);
        x= sqrt(Number);
        sqc = ceil(x);  
        Lin = size(outdata,1)/Number;
        Lin_r = round(Lin);
        for i= 1:size(fitdata,1) %fitdata
        storefitdata_row{i} = fitdata(i,[1:size(fitdata,2)]);   
        end
        for  d = 1:size(outdata,1) %data
        storedata_row{d} = outdata(d,[1:size(outdata,2)]);   
        end
         trace_list = 1:Lin_r:size(fitdata,1);
         g = uigridlayout([sqc,sqc])
         for k = 1:Number 
            n = trace_list(k)   %trace_list(k);
            ax = uiaxes(g);
            ax.Layout.Row = ceil((k-0.5)/sqc);
            ax.Layout.Column = k-(ax.Layout.Row-1)*sqc;       
            plot(ax,time,storefitdata_row{n},'red')
            hold (ax,'on')
            plot(ax,time,storedata_row{n},'k --');
            wa = num2str(wavelength(n),5);
            hold (ax,'off')
            legend(ax,'fit','data');
            xlabel (ax,'time (ns) '); ylabel(ax,wa);
         end
end