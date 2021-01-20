function [ spectra ] = spectrauiimport( ifalign,ifplot,ifbackcor )
%SPECTRAUIIMPORT Imports the Raman spectra to matlab and then pre-processes
%                for further analysis 
%   ifalign : true to align the spectra to a common x axis
%   ifplot : true to plot

spectra = spectrauiopen;

if ifalign
    spectra = spectraalign(spectra);
    spectraAt1800To1900 = spectratrim(spectra,1800,1900);
    spectra.noiseAt1800To1900 = std(spectraAt1800To1900.spectrum);
end


spectra = spectratrim(spectra,1000,3100);

if ifbackcor
    for i=1:size(spectra.spectrum,2)
        [spectra.bgcor(:,i),~,~,~,~,~] = backcor(spectra.wavenum,spectra.spectrum(:,i),4,0.01,'atq');
    end
    spectra.spectrum = spectra.spectrum - spectra.bgcor;
    spectra.background_corrected = true;
end
spectra = spectranormalize(spectra,'2-norm');
if ifplot
    spectraplot(spectra);
end



end

