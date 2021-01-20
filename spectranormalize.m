function [ spectra ] = spectranormalize( spectrainput,varargin )
%SPECTRANORMALIZE Normalizes the Raman spectra input with designated
%methods.
%   Detailed explanation goes here

if isempty(varargin)
    fct = '2-norm';
elseif length(varargin) > 1
    error('Too many inputs');
else
    fct = varargin{1};
    if ~isequal(fct,'min-max') && ~isequal(fct,'1-norm') && ~isequal(fct,'2-norm') && ~isequal(fct,'snv')
    error('Unknown function.');
    end
end    
spectra = spectrainput;

switch fct
    case 'min-max'
        spectra.spectrum = spectra.spectrum - min(spectra.spectrum);
        spectra.spectrum = spectra.spectrum ./ max(spectra.spectrum);
    case '1-norm'
        spectra.spectrum = spectra.spectrum - mean(spectra.spectrum);
        spectra.spectrum = spectra.spectrum ./ sum(abs(spectra.spectrum));
    case '2-norm'
        spectra.spectrum = spectra.spectrum - mean(spectra.spectrum);
        spectra.spectrum = spectra.spectrum ./ sqrt(sum(spectra.spectrum.^2, 1));
    case 'snv'
        spectra.spectrum = spectra.spectrum - mean(spectra.spectrum);
        spectra.spectrum = spectra.spectrum ./ std(spectra.spectrum);
        
end
spectra.normalized = fct;
end

