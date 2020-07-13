function [cutdata,wavelengthcut] = gta_cropdata_noplot(min,max,wavelength,dataf,time)
% wavelength explicit
% save ('cutdata.txt','cutdata','-ascii')
% figure(1)
% imagesc(wavelength,time,dataf');

% min = 670;
% max = 750;
cutdata =[];
wavelengthcut =[];
if min == 0 && max == 0
    cutdata = [];
    cutdata = [cutdata;dataf(:,:)];
    wavelengthcut = wavelength(1:end);
else
    [r,c,v] = find(wavelength>min&wavelength<max);
    wavelengthcut = wavelength(r(1:end)) ;
    % cutdata = [];
    for j = 1:size(r,1)
        cutdata = [cutdata;dataf(r(j),:)];
        
    end
end