function [ spectra ] = spectratrim( spectrainput,lowerEdge,upperEdge )
%spectratrim Trims the original spectra from lowerEdge to upperEdge by
%lookuping the closest wavenum of these inputs and then trim.

spectra = spectrainput;

% Find minimum distance for lowerEdge
[~, indexAtMin] = min(abs(spectra.wavenum - lowerEdge));
% Find minimum distance for upperEdge
[~, indexAtMax] = min(abs(spectra.wavenum - upperEdge));

% Trim the spectrum
spectra.wavenum = spectra.wavenum(indexAtMin:indexAtMax);
spectra.spectrum = spectra.spectrum(indexAtMin:indexAtMax,:); 

spectra.trimed = true;

end

