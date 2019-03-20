
function pyglot_read(filename)
%% Display the file details
%  filename = 'dataset1.nc'
 filename = fullfile (filename) % ** filename**
 ncdisp (filename) % info regarding the file
 nc_header = ncinfo(filename);
 variable_names = {nc_header.Variables.Name};
 supported_variables = ~contains({nc_header.Variables.Datatype},'UNSUPPORTED');
 variables_to_load = variable_names(supported_variables);
 
 data_struct = struct(); %structure array 
 
 % loop over the variables and putting them into a data_strucure for later 
for j=1:numel(variables_to_load)
   % extract the jth variable (type = string)
   var = variables_to_load{j}
 % use dynamic field name to add this to the structure
   data_struct.(var) = ncread(filename,var);

   % convert from single to double, if that matters to you (it does to me)
   if isa(data_struct.(var),'single')
       data_struct.(var) = double(data_struct.(var));
   end
end
 
%% load the content (not necessary though)
wavelength = data_struct.spectral;
time = data_struct.time;

das = data_struct.decay_associated_spectra;

%smoothening the spectras 
dastra = data_struct.decay_associated_spectra'; %transpose the das
dassm = smooth(dastra,'sgolay');
dasr= reshape(dassm,[size(dastra,1),size(dastra,2)]);
das= dasr';  %final das after smoothening 
 for i=1:size(das,1)
    das_max = max(abs(das(i,:)));
    normdas(i,:) = das(i,:) / das_max;
 end

sas = data_struct.species_associated_spectra;
sastra = sas';
sassm = smooth(sastra,'sgolay');
sasr= reshape(sassm,[size(sastra,1),size(sastra,2)]);
sas= sasr'; %final das after smoothening

 for i=1:size(sas,1)
    sas_max = max(sas(i,:));
    normsas(i,:) = sas(i,:) / sas_max;
%     normsas(i,:)=locmax(spectra,normsas(i,:));
 end

% species= {'K1','K2','K3','K4','k5'};
data = data_struct.data;
residual = data_struct.residual;
conc_read = data_struct.species_concentration;
conc= conc_read(:,:,1);

 leftsingularvector = data_struct.residual_left_singular_vectors;
 LSV_cut = leftsingularvector(1:2,:);
 rightsingularvector = data_struct.residual_right_singular_vectors;
 RSV_cut = rightsingularvector(:,1:2);
 fitdata = data_struct.fitted_data;
 
%% not in the latest *nc file
%  kmat = data_struct.k_matrix;
%  lifetime = data_struct.lifetime;
% lifetime=single(lifetime)
%  a_matrix = data_struct.a_matrix;

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
%legend ('K1','K2','K3','K4','k5');
% legend (num2str(lifetime(1:size(lifetime,1),1)));
hold off
%normDAS
subplot(2,2,3)
% figure(1);
plot(wavelength,normdas,'linewidth',2.5);xlabel('Wavelength');ylabel('DAS'); title('Norm Parallel Model');
hold on
plot(wavelength,zeros(length(wavelength)),'k --','linewidth',0.5)
% legend ('K1','K2','K3','K4','k5');
ylim([-1.1 1.1]);
hold off
%EAS
subplot(2,2,2)
plot(wavelength,sas,'linewidth',2.5);xlabel('Wavelength');ylabel('EAS'); title('Sequential Model');
% legend ('K1','K2','K3','K4','k5');

for i=1:size(sas,1)
    locmax(wavelength,sas(i,:));% **using locmax_function 
end

%normEAS
subplot(2,2,4)
plot(wavelength,normsas,'linewidth',2.5);xlabel('Wavelength');ylabel('EAS'); title('Norm Sequential Model');
% legend ('K1','K2','K3','K4','k5');
ylim([0 1.1]);

%load data
figure(2);
subplot(2,1,1);
% formatfig('slide');

imagesc(wavelength,time,data');xlabel('Time(ns)');ylabel('Wavelength'); title('data');
if isfield(data_struct,'center_dispersion_1')== 1
    
  dispersion_1 = data_struct.center_dispersion_1;
  hold on
  plot(wavelength,dispersion_1,'magenta');
end  

if isfield(data_struct,'center_dispersion_2')== 1
    
  dispersion_2 = data_struct.center_dispersion_1;
  hold on
  plot(wavelength,dispersion_2,'white .')
end

%fitteddata
figure(2);
subplot(2,1,2);
imagesc(wavelength,time,fitdata');xlabel('Time(ns)');ylabel('Wavelength'); title('fitted data');

% calculated conc
figure(3);
subplot(2,2,4);
plot(time,conc,'linewidth',2.5); xlabel('Wavelength');ylabel('DAS'); title('Calculated conc. profile');
% legend ('K1','K2','K3','K4','k5');
%legend (num2str(lifetime(1:5)));

%residual
%figure(5);
subplot(2,2,3);
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
