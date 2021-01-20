function [ noise ] = spectraNoiseEst( FilePath )
%spectraNoiseEst Calculates the standand deviation of a spectrum after
%subtracted by the smoothed spectrum to yield noise estimation

    fileID = fopen(FilePath);
    txt_read = textscan(fileID,'%f %f');
    spectrum = txt_read{2};
    fclose(fileID);
    
    smoothed_spectrum = smooth(spectrum,0.02,'loess');
    noise = std(spectrum - smoothed_spectrum);

end

