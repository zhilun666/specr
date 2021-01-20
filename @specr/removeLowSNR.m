function removeLowSNR(thisSpecr,varargin)
%REMOVEOUTLINER Removes the outliners in the data set according to the
%corelation function
%   
%% Parse input
peakLow = 1625;
peakHigh = 1715;
lowerEdge = 1800;
upperEdge = 2000;

p = inputParser;

defaultData = length(thisSpecr.data.spc);

defaultThreshold = 15;

addRequired(p,'thisSpecr',@isobject);
addParameter(p,'data',defaultData,@isscalar);
addParameter(p,'threshold',defaultThreshold);
p.KeepUnmatched = false;

parse(p,thisSpecr,varargin{:});

targetdata = p.Results.data;
t = p.Results.threshold;
spc = thisSpecr.data.spc{targetdata};

%% Calculate SNR
% Find minimum distance for lowerEdge
[~, indexAtMin] = min(abs(thisSpecr.data.wavenum{targetdata} - lowerEdge),[],2);
[~, indexAtMinPeak] = min(abs(thisSpecr.data.wavenum{targetdata} - peakLow),[],2);
% Find minimum distance for upperEdge
[~, indexAtMax] = min(abs(thisSpecr.data.wavenum{targetdata} - upperEdge),[],2);
[~, indexAtMaxPeak] = min(abs(thisSpecr.data.wavenum{targetdata} - peakHigh),[],2);

sp = spc(:,indexAtMin:indexAtMax); 
st = std(sp,0,2);
m = mean(sp,2);
pk = max(spc(:,indexAtMinPeak:indexAtMaxPeak),[],2);

% snr = abs((spc(:,861) - m)) ./ st;

snr = abs((pk - m)) ./ st;

removal = snr < t;

removed = spc(removal,:);
spc = spc(~removal,:);

%% Assign data
thisSpecr.data.spc{end+1} = spc;
thisSpecr.data.wavenum{end+1} = thisSpecr.data.wavenum{targetdata}(~removal,:);
thisSpecr.data.removed{end+1} = removed;
thisSpecr.data.bgcor{end+1} = [];

% needs better way
thisSpecr.label.history{1,end+1} = ['removed data that has lower SNR than: ',num2str(t)];
thisSpecr.label.history{2,end} = datetime('now');
if numel(thisSpecr.label.fileName) == length(removal)
    thisSpecr.label.fileName(removal)=[];
else 
    thisSpecr.label.fileName(numel(thisSpecr.label.fileName):length(removal))={''};
    thisSpecr.label.fileName(removal)=[];
    warning('some file names have been already removed, not matching to spectra right now')
end

end
