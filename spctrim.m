function [ spectra ] = spctrim( spectrainput,lowerEdge,upperEdge )
%spectratrim Trims the original spectra from lowerEdge to upperEdge by
%lookuping the closest wavenum of these inputs and then trim.

spectra = spectrainput;

% Find minimum distance for lowerEdge
[~, indexAtMin] = min(abs(spectra.data.wavenum - lowerEdge));
% Find minimum distance for upperEdge
[~, indexAtMax] = min(abs(spectra.data.wavenum - upperEdge));

% Trim the spectrum
spectra.data.wavenum = spectra.data.wavenum(indexAtMin:indexAtMax);
spectra.data.spc = spectra.data.spc(indexAtMin:indexAtMax,:); 


end

