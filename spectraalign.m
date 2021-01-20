function [ spectra ] = spectraalign( spectrainput )
%spectraalign Aligns the spectra to a common x axis with spline
%interpolation algorithm, starting from the smallest wavenumber rounded up
%to the nearest integer to the largest wavenumber rounded down with the 
%interval of the orinal interval rounded up.

spectra = spectrainput;
spectra.wavenum = (ceil(min(spectra.oriWaveNum))...
                  :ceil(spectra.oriWaveNum_interval)...
                  :floor(max(spectra.oriWaveNum)))';
for i = 1:spectra.cell_num
    spectra.spectrum(:,i) = spline(spectra.oriWaveNum(:,i),...
                                   spectra.oriSpectrum(:,i),...
                                   spectra.wavenum);
end

spectra.wavenum_min = min(spectra.wavenum);
spectra.wavenum_max = max(spectra.wavenum);
spectra.wavenum_interval = spectra.wavenum(2) - spectra.wavenum(1);

spectra.axis_aligned = true;

end

