function[filename,data,dataf,wavelength,time,U,S,V,chk] = gta_loaddataset()
% read data from ascii file
% output : filename,data,dataf,wavelength,time,U,S,V,chk
% output : 
%   filename , raw data and final data (after trimming wavelength & time)
% loads ascii data tested from Glotaran converted and BRC as standard 
% time-explicit - 0
% wavelength explicit - 1
% case 1 = TCSPC (wavelength explicit)
% case 0 = Streak(time explicit)
% case 9 - save data (special case)

%%
    [filename,pathname] = get_ascii('*.ascii');
        data = [];
%         data = dataset.data;
        dataf = [];
        wavelength = [];
        U = [];
        S = [];
        V = [];
        time = [];
        chk = [];
    % full_filepath = strcat(pathname,filename)
    full_filepath = [pathname filename];
         if isequal(filename,0) || isequal(pathname,0)
             return
         end

    [dataset,headerlinesOut] = importdata(full_filepath);
    
%     if size(dataset.data,2)<4
%         xaxis = dataset.data(:,1);
% 
%         fprintf('Not a 2Dimensional Data.')
%         plot(xaxis,dataset.data(:,2));
%         hold on
%        
%         plot(xaxis,dataset.data(:,3))
%         return
%         
%     end

     if ~isstruct(dataset)
         
                chk = 9;
                data = dataset;

                wavelength = data(2:end,1);
                time = data(1,1:end-1);
                dataf = data(2:end,2:end);
                [U1,S,V1] = svd(dataf);
                U = -U1 ;
                V = -V1 ;
     

         else

        data = dataset.data;

        for n = 1:size(dataset.textdata,1)
            h(n) = dataset.textdata(n);
        end
        str = strjoin(h);
        P = "Wavelength";
        chk = contains(h{2},P,'IgnoreCase',true) ;

    % case 1 = TCSPC (wavelength explicit)
    % case 0 = Streak(time explicit)
    switch chk
        case 1
            wavelength = data(1,2:end)';
            time = data(2:end,1);
            dataf = data(2:end,2:end);
  
            [U1,S,V1] = svd(dataf);
            U = -U1 ;
            V = -V1 ;

        case 0
            wavelength = data(2:end,1);
            time = data(1,1:end-1);
            dataf = data(2:end,2:end);

            [U1,S,V1] = svd(dataf);
            U = -U1 ;
            V = -V1 ;
        case 2
%             A = imread('ngc6543a.jpg');
           %%% fix this 
           plot(dataset.data(:,1),dataset.data(:,2))


       end
     end



end






