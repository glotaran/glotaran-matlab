
function trace(Number,filename)
% Input : Number : number of traces   
%       : filename : 'filename.nc'
% Output : same number of trace plots as the input gievn.
% helps to check the fit of the data at different time traces
 

%% read files
Number = round(Number);
wavelength=ncread(filename,'spectral');
time = ncread(filename,'time');
data=ncread(filename,'data');
fitdata = ncread(filename,'fitted_data');
%%
Lin = size(data,1)/Number;
Lin_r = round(Lin);

for i= 1:size(fitdata,1)%fitdata
    
    storefitdata_row{i} = fitdata(i,[1:size(fitdata,2)]);   
end
for d = 1:size(data,1)%data
    
    storedata_row{d} = data(d,[1:size(data,2)]);   
end
for n=1:Lin_r:size(fitdata,1)
    
    figure(n);

    set(gcf,'NumberTitle','off'); 
    
    txt = num2str(wavelength(n));
    txt2 = ('nm');
    plot(time,storefitdata_row{n},'red');
    hold on
    plot(time,storedata_row{n},'k --');
    legend('fit','data');
    title 'Time trace';
    xlabel 'time (ns) '; ylabel 'Intensity';
    ylim=get(gca,'ylim');
    xlim=get(gca,'xlim');
    t=text(xlim(1),ylim(2),txt,'Color','black','FontSize',10);
    t2=text(xlim(1),ylim(2),txt2,'Color','black','FontSize',10);
    t.FontWeight='bold';
    t.HorizontalAlignment ='left'; 
    t.VerticalAlignment= 'bottom';
    
    t2.FontWeight='bold';
    t2.HorizontalAlignment ='left'; 
    t2.VerticalAlignment= 'top';
    box off   
end
end 


