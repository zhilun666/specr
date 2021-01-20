function [ spectra ] = spcnormalize( spectrainput,varargin )
%SPECTRANORMALIZE Normalizes the Raman spectra input with designated methods.
%   spectrainput: the spectra being normalized, must have .data.spc
%   Possible normalization methods:
%       2-norm: default method.
%       1-norm
%       min-max
%       snv
%       amide
%% Parse input

p = inputParser;

defaultFct = '2-norm';
validFct = {'min-max','1-norm','2-norm','snv','amide'};
checkFct = @(x) any(validatestring(x,validFct));

addRequired(p,'spectrainput',@isstruct);
addOptional(p,'fct',defaultFct,checkFct);
p.KeepUnmatched = false;

parse(p,spectrainput,varargin{:});

fct = p.Results.fct;
spectra = spectrainput;

%% Noramlize
switch fct
    case 'min-max'
        spectra.data.spc = spectra.data.spc - min(spectra.data.spc);
        spectra.data.spc = spectra.data.spc ./ max(spectra.data.spc);
    case '1-norm'
        spectra.data.spc = spectra.data.spc - mean(spectra.data.spc);
        spectra.data.spc = spectra.data.spc ./ sum(abs(spectra.data.spc));
    case '2-norm'
        spectra.data.spc = spectra.data.spc - mean(spectra.data.spc);
        spectra.data.spc = spectra.data.spc ./ sqrt(sum(spectra.data.spc.^2, 1));
    case 'snv'
        spectra.data.spc = spectra.data.spc - mean(spectra.data.spc);
        spectra.data.spc = spectra.data.spc ./ std(spectra.data.spc);
    case 'amide'
        [a,b] = spcfindregion(spectra,1640,1680);
        spectra.data.spc = spectra.data.spc - min(spectra.data.spc,[],1);
        amdsum = sqrt(sum(spectra.data.spc(a:b,:).^2,1));
        spectra.data.spc = spectra.data.spc ./ amdsum;
        
end
end

