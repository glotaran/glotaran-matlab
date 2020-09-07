function gta_savecropdata(ax,cutdata,wavelengthcut,time)
save('cropdata_user.mat','cutdata');
save('cropdata_wavelength.mat','wavelengthcut');
load ('cropdata_user.mat');
load ('cropdata_wavelength.mat');

% figure()
imagesc(ax,wavelengthcut,time,cutdata');
%% 
% make ascii 
wavelengthcut1 = [ 0; wavelengthcut];
newdata0 = [wavelengthcut cutdata ];

time0 = [time , NaN];
newdata = [time0;newdata0];

filter = {'*.ascii'};
[savefile,savepath] = uiputfile(filter);
savename = strcat(savepath,savefile);
save(savename,'newdata','-ascii')
% filter = {'*.m';'*.slx';'*.mat';'*.*'};
% [file, path] = uiputfile(filter);


end 