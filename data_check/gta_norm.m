function [normspectra] = gta_norm(spectra)

 normspectra = (spectra - min(spectra)) / ( max(spectra) - min(spectra));
end