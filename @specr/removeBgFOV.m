function removeBgFOV(thisSpecr,varargin)
%% Parse inputs
p = inputParser;

defaultData = length(thisSpecr.data.spc);
defaultBgRange = [1 900];
defaultBgExp = '_bg';


addRequired(p,'thisSpecr',@isobject);
addOptional(p,'data',defaultData,@isscalar);
addOptional(p,'bgRange',defaultBgRange,@isvector);
addOptional(p,'bgExp',defaultBgExp,@isstring);


p.KeepUnmatched = false;

parse(p,thisSpecr,varargin{:});

thisSpecr = p.Results.thisSpecr;
targetData = p.Results.data;
bgRange = p.Results.bgRange;
bgExp = p.Results.bgExp;

spc = thisSpecr.data.spc{targetData};

%% Locate Bg and cells
S = cellfun(@(x) x(1:end-8), thisSpecr.label.fileName,'un',0);
bgIdntfer = cellfun(@(x) regexp(x,bgExp), thisSpecr.label.fileName,'un',0);
bgInx = cellfun(@(x) ~isempty(x), bgIdntfer,'un',1);
S(bgInx) = cellfun(@(x) x(1:end-length(bgExp)), S(bgInx),'un',0);
[~, ia, ~] = unique(S);
ia = [ia;numel(S)+1]; % Additional one entry for the last loop
ia = sort(ia); % In case ia is not sorted in the right way.
%% Remove Bg
spcBgRmvd = zeros(sum(~bgInx),size(spc,2));
bgcor = zeros(sum(~bgInx),size(spc,2));
j = 1;
for i=1:(numel(ia)-1)
    crrntSpc = spc(ia(i):ia(i+1)-1,:);
    crrntBgInx = bgInx(ia(i):ia(i+1)-1);
    if sum(crrntBgInx) == 1
        [spcBgRmvdTemp,~,bgcorTemp,~,~,~,~] = ...
            SMIRFCode(crrntSpc(~crrntBgInx,:),0,bgRange,30,crrntSpc(crrntBgInx,:));
    else
        [spcBgRmvdTemp,~,bgcorTemp,~,~,~,~] = ...
            SMIRFCode(crrntSpc(~crrntBgInx,:),0,bgRange,30,mean(crrntSpc(crrntBgInx,:),1));
    end
    
    spcBgRmvd(j:j+sum(~crrntBgInx)-1,:) = spcBgRmvdTemp;
    bgcor(j:j+sum(~crrntBgInx)-1,:) = bgcorTemp;
    
    j = j + sum(~crrntBgInx);
end

%% Updata the object
thisSpecr.data.spc{end+1} = spcBgRmvd;
thisSpecr.data.wavenum{end+1} = thisSpecr.data.wavenum{targetData}(~bgInx,:);
thisSpecr.data.bgcor{end+1} = bgcor;
thisSpecr.label.history{1,end+1} = 'background removed with SMIRF method within same FOV';
thisSpecr.label.history{2,end} = datetime('now');
thisSpecr.data.removed{end+1} = [];