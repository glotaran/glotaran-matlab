        
function [fc] = checkfiles_ml_nc(pp)
        
fc = checkfilepresence_mldatx(pp);
        if fc == 0
            fc = checkfilepresence_nc(pp)
           
%             fc = checkfilepresence_ascii(pp)
        end
end