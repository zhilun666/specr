function calibrate(thisSpecr,ref,varargin)
%% Parse inputs
p = inputParser;

defaultData = length(thisSpecr.data.spc);

defaultStd = 'A/T';
validStd = {'DMSO','polystyrene','intrinsic','A/T'};
checkStd = @(x) any(validatestring(x,validStd));

defaultMode = 'auto';
validMode = {'auto','manual'};
checkMode = @(x) any(validatestring(x,validMode));

defaultLength = 1600;

addRequired(p,'ref')
addParameter(p,'data',defaultData,@isscalar);
addParameter(p,'standard',defaultStd,checkStd);
addParameter(p,'peakDetectionMode',defaultMode,checkMode);
addParameter(p,'xlength',defaultLength,@isscalar);
parse(p,ref,varargin{:});

targetdata = p.Results.data;
stdrd = p.Results.standard;
ref = p.Results.ref;
mode = p.Results.peakDetectionMode;
xlength = p.Results.xlength;


%% Calibrate wavenumber axis
[calibAxis] = spccalibstd(ref,'standard',stdrd,'peakDetectionMode',mode,'xlength',xlength);


thisSpecr.data.wavenum{end+1} = repmat(calibAxis,size(thisSpecr.data.wavenum{targetdata},1),1);
thisSpecr.data.spc{end+1} = thisSpecr.data.spc{targetdata};
thisSpecr.data.bgcor{end+1} = [];
thisSpecr.data.removed{end+1} = [];
thisSpecr.label.history{1,end+1} = ['wavenumber calibrated with ',stdrd];
thisSpecr.label.history{2,end} = datetime('now');
end