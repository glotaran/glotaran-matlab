function[txt,txt2] = locmax_spectra(wavelength,spectra)
% find the location of maxima in individual spectra of tested 'model'
% (das,normdas,sas,normsas)
% input : [wavelength] as x axis 
%         [spectra]-(das/normdas/sas/normsas)
%         input's (das/normdas/sas/normsas)should be specified 
% Output: [the location of the wavelength]

for i=1:size(spectra,1)
    [amplitude_max,idx]=max(spectra(i,:));
    wavelength_max=wavelength(idx,1);
    txt=num2str(amplitude_max,5);%Precision upto 4 digits 
    txt2=num2str(wavelength_max,3);

    t=text(wavelength_max,amplitude_max,txt2,'Color','black','FontSize',10);
    t.FontWeight='bold';
    t.HorizontalAlignment ='center'; 
    t.VerticalAlignment= 'bottom';
    

end
end
