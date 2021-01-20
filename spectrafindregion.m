function [ indexAtMin,indexAtMax ] = spectrafindregion( spectrainput,lowerEdge,upperEdge )
%SPECTRAFINDREGION Finds the cloeset positions to the lower and upper edges
%input and returns the 
%   Detailed explanation goes here
spectra = spectrainput;

% Find minimum distance for lowerEdge
[~, indexAtMin] = min(abs(spectra.wavenum - lowerEdge));
% Find minimum distance for upperEdge
[~, indexAtMax] = min(abs(spectra.wavenum - upperEdge));

end

