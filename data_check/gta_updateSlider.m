function gta_updateSlider(spn,time,V,ax,ax1,ax2,wavelength,U,chk)

    switch chk
        case 0
            plot(ax1,wavelength,U(:,1:spn.Value));
            xlabel(ax1,'Wavelength(nm)');
            ylabel(ax1,'Intensity');
            ax1.Title.String = 'Right singular vector';
            plot(ax2,time,V(:,1:spn.Value));
            xlabel(ax2,'Time(ns)');
            ylabel(ax2,'Intensity');
            ax2.Title.String = 'Left singular vector';

        case 1
            plot(ax1,wavelength,V(:,1:spn.Value));
            xlabel(ax1,'Wavelength(nm)');
            ylabel(ax1,'Intensity');
            ax1.Title.String = 'Right singular vector';

            plot(ax2,time,U(:,1:spn.Value));
            xlabel(ax2,'Time(ns)');
            ylabel(ax2,'Intensity');
            ax2.Title.String = 'Left singular vector';
        case 9
            plot(ax1,wavelength,U(:,1:spn.Value));
            xlabel(ax1,'Wavelength(nm)');
            ylabel(ax1,'Intensity');
            ax1.Title.String = 'Right singular vector';
            plot(ax2,time,V(:,1:spn.Value));
            xlabel(ax2,'Time(ns)');
            ylabel(ax2,'Intensity');
            ax2.Title.String = 'Left singular vector';
            
    end
        
end