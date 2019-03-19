
function[wavelength,time,das,normdas,sas,normsas,data,residual,fitdata]= pyglot_read(filename)

% Analyze netcdf (.nc) files obtained from pyglotaran 
% startreading -'filename'(example : startraeding'global.nc')
% new features : 
% loc max function added % smotthening function added
% format fig removed % zero line in DAS and norm DAS 
% separate function made to read each types of speactra 
% function for finding minima applied locmin_spectra (but as separate)
%% more req :
%            lifetimes 
%            Steady-state
%            digraph 
%%
 ncdisp(filename)

%% Read
wavelength=ncread(filename,'spectral');
time = ncread(filename,'time');

das = ncread(filename,'decay_associated_spectra');
dastra = das';
dassm = smooth(dastra,'sgolay');
dasr= reshape(dassm,[104,5]);
das= dasr'; %final das after smoothening
 for i=1:size(das,1)
    das_max = max(abs(das(i,:)));
    normdas(i,:) = das(i,:) / das_max;
 end

sas = ncread(filename,'species_associated_spectra');
sastra = sas';
sassm = smooth(sastra,'sgolay');
sasr= reshape(sassm,[104,5]);
sas= sasr'; %final das after smoothening

 for i=1:size(sas,1)
    sas_max = max(sas(i,:));
    normsas(i,:) = sas(i,:) / sas_max;
%     normsas(i,:)=locmax(spectra,normsas(i,:));
 end

% max_conv_kin_vec=max(max(conv_kin_vec));
% conv_kin_vec=conv_kin_vec/max_conv_kin_vec;

species= {'K1','K2','K3','K4','k5'};
data=ncread(filename,'data');
residual =ncread(filename,'residual');
conc_read = ncread(filename,'species_concentration');
conc= conc_read(:,:,1);
dispersion_1 =ncread(filename,'center_dispersion_1');
dispersion_2 =ncread(filename,'center_dispersion_2');
leftsingularvector = ncread(filename,'residual_left_singular_vectors');
LSV_cut = leftsingularvector(1:2,:);
rightsingularvector = ncread(filename,'residual_right_singular_vectors');
RSV_cut = rightsingularvector(:,1:2);
fitdata = ncread(filename,'fitted_data');

% screeplot = ncread(filename,'residual_singular_values');
% semilog(screeplot);
% scree_cut = leftsingularvector(:,1:2); of igene values required
%% plotting
%DAS
figure(1);
subplot(2,2,1)
plot(wavelength,das,'linewidth',2.5);xlabel('Wavelength');ylabel('DAS'); title('Parallel Model');
hold on
plot(wavelength,zeros(length(wavelength)),'k --','linewidth',0.5);
legend ('K1','K2','K3','K4','k5');
hold off
%normDAS
subplot(2,2,3)
% figure(1);
plot(wavelength,normdas,'linewidth',2.5);xlabel('Wavelength');ylabel('DAS'); title('Norm Parallel Model');
hold on
plot(wavelength,zeros(length(wavelength)),'k --','linewidth',0.5)
legend ('K1','K2','K3','K4','k5');
ylim([-1.1 1.1]);
hold off
%EAS
subplot(2,2,2)
plot(wavelength,sas,'linewidth',2.5);xlabel('Wavelength');ylabel('EAS'); title('Sequential Model');
legend ('K1','K2','K3','K4','k5');
for i=1:size(sas,1)
    locmax(wavelength,sas(i,:));
end

%normEAS
subplot(2,2,4)
plot(wavelength,normsas,'linewidth',2.5);xlabel('Wavelength');ylabel('EAS'); title('Norm Sequential Model');
legend ('K1','K2','K3','K4','k5');
ylim([0 1.1]);

%load data
figure(2);
subplot(2,1,1);
% formatfig('slide');

imagesc(wavelength,time,data');xlabel('Time(ns)');ylabel('Wavelength'); title('data');
hold on
plot(wavelength,dispersion_1,'magenta');
hold on
plot(wavelength,dispersion_2,'white .')

%fitteddata
figure(2);
subplot(2,1,2);
imagesc(wavelength,time,fitdata');xlabel('Time(ns)');ylabel('Wavelength'); title('fitted data');

% calculated conc
figure(3);
subplot(2,2,4);
plot(time,conc,'linewidth',2.5); xlabel('Wavelength');ylabel('DAS'); title('Calculated conc. profile');
legend ('K1','K2','K3','K4','k5');

%residual
%figure(5);
subplot(2,2,3);
% formatfig('slide');
imagesc(time,wavelength,residual);xlabel('Time(ns)');ylabel('Wavelength'); title('residuals');
%LSV
% figure(6);
subplot(2,2,1);
% formatfig('slide');
plot(time,LSV_cut',time,zeros(length(time)),'k --');xlabel('Time (ps)');ylabel('Intensity'); title('Left Singular Vector');
legend ('1st LSV','2nd LSV');
%RSV
subplot(2,2,2);
%figure(7);
% formatfig('slide');
plot(wavelength,RSV_cut',wavelength,zeros(length(wavelength)),'k --');xlabel('Wavelength (nm)');ylabel('Intensity'); title('Right Singular Vector');
legend ('1st RSV','2nd RSV');
end
%% for image save
% semilogy(scree_cut);
% print('SAS_DAS','-dtiff')
%set(gcf,'PaperPositionMode','auto');
%print('PeaksSurface','-dpng','-r0')
%% 

%outputdisp
% Dimensions:
%            megacomplex                = 1
%            time                       = 1024
%            spectral                   = 104
%            left_singular_value_index  = 1024
%            singular_value_index       = 104
%            right_singular_value_index = 104
%            clp_label                  = 5
%            species                    = 5
%            compartment                = 5
% Variables:
%     megacomplex                    
%            Size:       1x1
%            Dimensions: megacomplex
%            Datatype:   UNSUPPORTED DATATYPE
%     time                           
%            Size:       1024x1
%            Dimensions: time
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     spectral                       
%            Size:       104x1
%            Dimensions: spectral
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     data                           
%            Size:       104x1024
%            Dimensions: spectral,time
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     data_left_singular_vectors     
%            Size:       1024x1024
%            Dimensions: left_singular_value_index,time
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     data_singular_values           
%            Size:       104x1
%            Dimensions: singular_value_index
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     data_right_singular_vectors    
%            Size:       104x104
%            Dimensions: right_singular_value_index,spectral
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     clp_label                      
%            Size:       5x1
%            Dimensions: clp_label
%            Datatype:   UNSUPPORTED DATATYPE
%     concentration                  
%            Size:       5x1024x104
%            Dimensions: clp_label,time,spectral
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     residual                       
%            Size:       104x1024
%            Dimensions: spectral,time
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     clp                            
%            Size:       5x104
%            Dimensions: clp_label,spectral
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     residual_left_singular_vectors 
%            Size:       1024x1024
%            Dimensions: left_singular_value_index,time
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     residual_right_singular_vectors
%            Size:       104x104
%            Dimensions: spectral,right_singular_value_index
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     residual_singular_values       
%            Size:       104x104
%            Dimensions: singular_value_index,spectral
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     fitted_data                    
%            Size:       104x1024
%            Dimensions: spectral,time
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     species                        
%            Size:       5x1
%            Dimensions: species
%            Datatype:   UNSUPPORTED DATATYPE
%     species_associated_spectra     
%            Size:       5x104
%            Dimensions: species,spectral
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     species_concentration          
%            Size:       5x1024x104
%            Dimensions: species,time,spectral
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     compartment                    
%            Size:       5x1
%            Dimensions: compartment
%            Datatype:   UNSUPPORTED DATATYPE
%     decay_associated_spectra       
%            Size:       5x104x1
%            Dimensions: compartment,spectral,megacomplex
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     irf                            
%            Size:       1024x1
%            Dimensions: time
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     center_dispersion_1            
%            Size:       104x1
%            Dimensions: spectral
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN
%     center_dispersion_2            
%            Size:       104x1
%            Dimensions: spectral
%            Datatype:   double
%            Attributes:
%                        _FillValue = NaN