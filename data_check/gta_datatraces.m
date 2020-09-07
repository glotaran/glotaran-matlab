function [specAvg,timeAvg,cut_specAvg,wavelengthcut] = gta_datatraces(dataf,wavelength,time,min,max,chk)
%% avergae of the data in spectral axis or time axis
% particular wavelength as input min and max
%%
if chk == 1
    dataf = dataf';
end
[r,c,v] = find(wavelength>min&wavelength<max);
wavelengthcut = wavelength(r(1:end)) ;
cutdata_wave = [];
for j = 1:size(r,1)
    cutdata_wave = [cutdata_wave;dataf(r(j),:)];
    
end
cut_specAvg = sum(cutdata_wave);
timeAvg = sum(dataf);
specAvg = sum(dataf,2);

figure;plot(time,gta_norm(timeAvg)); title('Sum of Time trace');
hold on
plot(time,gta_norm(cut_specAvg));title('Cut time trace');
legend('Avg along all the wavelength',strcat('cut :',num2str(min),'-',num2str(max)));
% hold off
% figure;plot(wavelength,specAvg);title('Sum of Wavelength trace');

end