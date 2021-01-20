function [ spectra ] = spcbgsub( inputSpectra,bgexpression,varargin )
%SPECTOBGSUN Finds the signal and background files and subtracts bg from
%signal
%   input_spectra: the spectra to be parsed
%   identifier: the keywords behind/prior to which the indexes are labeled
%   isIdentifierFront: if the identifier is in front of the index or behind
%   bgexpression: the keywords to identify background files

p = inputParser;
defaultMethod = 'non-normalized';
validMethods = {'non-normalized','norm2Si–O–Si'};
checkMethods = @(x) any(validatestring(x,validMethods));

addRequired(p,'inputSpectra',@isstruct);
addRequired(p,'bgexpression',@ischar);
addOptional(p,'method',defaultMethod,checkMethods);

p.KeepUnmatched = false;

parse(p,inputSpectra,bgexpression,varargin{:});

inputSpectra = p.Results.inputSpectra;
bgexpression = p.Results.bgexpression;
method = p.Results.method;

%% Sort spectra based on index
% sort different spectra of the same cells
[~,sortSeq] = sort(inputSpectra.label.spcID);
spectra = spcsort(inputSpectra,sortSeq);

%% find background and subtract bg
bgID = regexp(spectra.label.oriFileName,bgexpression);
bgID = ~cellfun(@isempty,bgID);
switch method
    case 'non-normalized'
        spectra.data.spc = spectra.data.oriSpc(:,~bgID) - spectra.data.oriSpc(:,bgID);
    case 'norm2Si–O–Si'
        [a,b] = spcfindregion(spectra,833,1024,'original');
        bgsum = sum(spectra.data.oriSpc(a:b,bgID),1);
        specsum = sum(spectra.data.oriSpc(a:b,~bgID,1));
        spectra.data.spc = spectra.data.oriSpc(:,~bgID) - (specsum./bgsum).*spectra.data.oriSpc(:,bgID);
    case 'SMIRF'
        [fitted,~,~,~,~,~,~] = SMIRFCode(spectraset',0,[1 995],30, cont','fluor off');
end
spectra.data.wavenum = spectra.data.oriWaveNum(:,~bgID);
spectra.label.bgID = bgID;
end


