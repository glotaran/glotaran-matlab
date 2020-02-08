function [specAvg,timeAvg] = gta_avg_data(dataf,wavelength,time)
%% avergae of the data in spectral axis or time axis
% mainly for power study
%%
timeAvg = sum(dataf);
specAvg = sum(dataf,2);
figure;plot(time,timeAvg)
figure;plot(wavelength,specAvg)
end