function [cutdata,wavelengthcut] = gta_buttonsavedata(cropmin,cropmax,wavelength,dataf,time)
% wavelength explicit
% save ('cutdata.txt','cutdata','-ascii')
% figure(1)
% imagesc(wavelength,time,dataf');

% min = 670;
% max = 750;
% [cropmin,cropmax] = gta_cropButtonPushed(editmin,editmax)
%         cropmin = editmin.Value;
%         cropmax = editmax.Value;
%        editmax = uieditfield(grid2,'numeric','Value', 0,'ValueDisplayFormat','%.0f Crop_Min-wavelength');
%        editmin = uieditfield(grid2,'numeric','Value', 0,'ValueDisplayFormat','%.0f Crop_Max-wavelength');
cutdata =[];
wavelengthcut =[];
if cropmin == 0 && cropmax == 0
    cutdata = [];
    cutdata = [cutdata;dataf(:,:)];
    wavelengthcut = wavelength(1:end);
else
    [r,c,v] = find(wavelength>cropmin&wavelength<cropmax);
    wavelengthcut = wavelength(r(1:end)) ;
    % cutdata = [];
    for j = 1:size(r,1)
        cutdata = [cutdata;dataf(r(j),:)];
        
    end
end
save('cropdata_user.mat','cutdata');
save('cropdata_wavelength.mat','wavelengthcut');
%%
load ('cropdata_user.mat');
load ('cropdata_wavelength.mat');
wavelengthcut1 = [ 0; wavelengthcut];
newdata0 = [wavelengthcut cutdata ];

time0 = [time , NaN];
newdata = [time0;newdata0];

filter = {'*.ascii'};
[savefile,savepath] = uiputfile(filter);
savename = strcat(savepath,savefile);
% savename
save(savename,'newdata','-ascii')
cd(savepath)


end