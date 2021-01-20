function removeOutliner(thisSpecr,varargin)
%REMOVEOUTLINER Removes the outliners in the data set according to the
%corelation function
%   
%% Parse input

p = inputParser;

defaultFct = 'Pearson';
validFct = {'Pearson','Kendall','Spearman'};
checkFct = @(x) any(validatestring(x,validFct));

defaultData = length(thisSpecr.data.spc);

defaultThreshold = 0.3;

addRequired(p,'thisSpecr',@isobject);
addParameter(p,'fct',defaultFct,checkFct);
addParameter(p,'data',defaultData,@isscalar);
addParameter(p,'threshold',defaultThreshold);
p.KeepUnmatched = false;

parse(p,thisSpecr,varargin{:});

fct = p.Results.fct;
targetdata = p.Results.data;
t = p.Results.threshold;
spc = thisSpecr.data.spc{targetdata};

%% Calculate corelation matrix and parse the data
rho = corr(spc','Type',fct); % transpsed since the corr function computes columnwisely
score = sum(rho<0.95,2);
removal = score > size(spc,1)*t;

removed = spc(removal,:);
spc = spc(~removal,:);


%% Assign data
thisSpecr.data.spc{end+1} = spc;
thisSpecr.data.wavenum{end+1} = thisSpecr.data.wavenum{targetdata}(~removal,:);
thisSpecr.data.removed{end+1} = removed;
thisSpecr.data.bgcor{end+1} = [];
% needs better way
thisSpecr.label.fileName(removal)=[];

thisSpecr.label.history{1,end+1} = ['removed data using corelation function: ',fct];
thisSpecr.label.history{2,end} = datetime('now');
end

