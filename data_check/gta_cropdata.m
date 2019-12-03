function [cutdata,wavelengthcut] = gta_cropdata(ax,min,max,wavelength,dataf,time)
% wavelength explicit
% save ('cutdata.txt','cutdata','-ascii')
% figure(1)
% imagesc(wavelength,time,dataf');

% min = 670;
% max = 750;

[r,c,v] = find(wavelength>min&wavelength<max);
wavelengthcut = wavelength(r(1:end)) ;
cutdata = [];
for j = 1:size(r,1)
    cutdata = [cutdata;dataf(r(j),:)];
    
end
% figure(2)
% imagesc(wavelengthcut,time,cutdata');
imagesc(ax,wavelengthcut,time,cutdata');
% cutwavemin = fix(min(wavelengthcut));
% cutwavemax = ceil(max(wavelengthcut));
% % cuttimemin = fix(min(time));
% % cuttimemax = ceil(max(time));
ax.XLim = [min max];
% ax.YLim = [timemin timemax];
xlabel(ax,'Wavelength(nm)');
ylabel(ax,'Time (ns)');
end