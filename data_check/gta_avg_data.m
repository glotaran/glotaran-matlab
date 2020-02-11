function [specAvg,timeAvg] = gta_avg_data(dataf,wavelength,time)
%% avergae of the data in spectral axis or time axis
% mainly for power study
%%
timeAvg = gta_norm(sum(dataf));
specAvg = gta_norm(sum(dataf,2));
figure;plot(time,timeAvg,'k','LineWidth',1.5); title('Avg along the all the wavelength - "Decay trace"');
xlabel('Time (ps)'); ylabel('Normalized Intensity')
ylim([0 1.1])

figure;plot(wavelength,specAvg,'k','LineWidth',1.5); 
title('Avg along the all the time points - Reconstructed SS')
xlabel('Wavelength (nm)'); ylabel('Normalized Intensity')

ylim([0 1.1])
end