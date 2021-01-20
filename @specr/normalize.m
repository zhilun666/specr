function normalize( thisSpecr,varargin )
%Method NORMALIZE 
%   Normalizes the Raman spectra input with designated methods.
%   spectrainput: the spectra being normalized, must have .data.spc
%   Possible normalization methods:
%       2-norm: default method.
%       1-norm
%       min-max
%       snv
%       amide
%       custom: use 'peakLoc' and a vector to dedicate peak for
%       normalization
%% Parse input

p = inputParser;

defaultFct = '2-norm';
validFct = {'min-max','1-norm','2-norm','snv','amide','custom'};
checkFct = @(x) any(validatestring(x,validFct));

defaultData = length(thisSpecr.data.spc);

addRequired(p,'thisSpecr',@isobject);
addParameter(p,'fct',defaultFct,checkFct);
addParameter(p,'data',defaultData,@isscalar);
addParameter(p,'peakLoc',@isvector);
p.KeepUnmatched = false;

parse(p,thisSpecr,varargin{:});

fct = p.Results.fct;
targetdata = p.Results.data;
peakLoc = p.Results.peakLoc;
spc = thisSpecr.data.spc{targetdata};

%% Noramlize
switch fct
    case 'min-max'
        spc = spc - min(spc,[],2);
        spc = spc ./ max(spc,[],2);
    case '1-norm'
        spc = spc - mean(spc,2);
        spc = spc ./ sum(abs(spc),2);
    case '2-norm'
        spc = spc - mean(spc,2);
        spc = spc ./ sqrt(sum(spc.^2, 2));
    case 'snv'
        spc = spc - mean(spc,2);
        spc = spc ./ std(spc,0,2);
    case 'amide'
        [a,b] = spcfindregion(thisSpecr,1640,1680);
        spc = spc - min(spc,[],2);
        amdsum = sqrt(sum(spc(:,a:b).^2,2));
        spc = spc ./ amdsum;
    case 'custom'
        if length(peakLoc) == 2
            [a,b] = spcfindregion(thisSpecr,peakLoc(1),peakLoc(2));
            spc = spc - min(spc,[],2);
            amdsum = sqrt(sum(spc(:,a:b).^2,2));
            spc = spc ./ amdsum;        
        else
            error('wrong peak location')
        end
end

thisSpecr.data.spc{end+1} = spc;
thisSpecr.data.wavenum{end+1} = thisSpecr.data.wavenum{targetdata};
thisSpecr.data.bgcor{end+1} = [];
thisSpecr.data.removed{end+1} = [];
thisSpecr.label.history{1,end+1} = ['normalized with ',fct];
thisSpecr.label.history{2,end} = datetime('now');

end

