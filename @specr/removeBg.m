function removeBg(thisSpecr,varargin)
%REMOVEBG Removes background from the input spectra


load 'glass_bg_andor_600I_2400cm_calibrated' bg_glass;

p = inputParser;
defaultMethod = 'SMIRF';
validMethods = {'non-normalized','norm2Si–O–Si','SMIRF','nqc'};
checkMethods = @(x) any(validatestring(x,validMethods));
validNqcfct = {'sh','ah','stq','atq'};
checkNqcfct = @(x) any(validatestring(x,validNqcfct));

defaultData = length(thisSpecr.data.spc);

defaultBg = bg_glass;
defaultOrder = 4;
defaultThreshold = 0.001;
defaultNqcfct = 'atq';
defaultBgRange = [1 900];
defaultNqcGUI = false;

addRequired(p,'thisSpecr',@isobject);
% addRequired(p,'bgexpression',@ischar);
addOptional(p,'fct',defaultMethod,checkMethods);
addOptional(p,'data',defaultData,@isscalar);
addOptional(p,'bg',defaultBg,@isvector);
addOptional(p,'bgRange',defaultBgRange,@isvector);
addOptional(p,'order',defaultOrder,@isscalar);
addOptional(p,'threshold',defaultThreshold,@isscalar);
addOptional(p,'nqcfct',defaultNqcfct,checkNqcfct);
addOptional(p,'nqcGUI',defaultNqcGUI);

p.KeepUnmatched = false;

parse(p,thisSpecr,varargin{:});

thisSpecr = p.Results.thisSpecr;
method = p.Results.fct;
targetData = p.Results.data;
bg = p.Results.bg;
bgRange = p.Results.bgRange;
order = p.Results.order;
threshold = p.Results.threshold;
nqcfct = p.Results.nqcfct;

nqcGUI = p.Results.nqcGUI;

%% find background and subtract bg

switch method
    case 'non-normalized'
        thisSpecr.data.spc = thisSpecr.data.oriSpc(:,~bgID) - thisSpecr.data.oriSpc(:,bgID);
    case 'norm2Si–O–Si'
        [a,b] = spcfindregion(thisSpecr,833,1024,'original');
        bgsum = sum(thisSpecr.data.oriSpc(a:b,bgID),1);
        specsum = sum(thisSpecr.data.oriSpc(a:b,~bgID,1));
        thisSpecr.data.spc = thisSpecr.data.oriSpc(:,~bgID) - (specsum./bgsum).*thisSpecr.data.oriSpc(:,bgID);
    case 'SMIRF'
        [thisSpecr.data.spc{end+1},~,...
            thisSpecr.data.bgcor{end+1},~,~,~,~] = SMIRFCode(thisSpecr.data.spc{targetData}...
                                                    ,0,bgRange,30,bg);
    case 'nqc'
        n = numel(thisSpecr.data.bgcor);
        if nqcGUI
            [~,~,~,ord,s,fct] = backcor(mean(thisSpecr.data.wavenum{targetData},1),...
                mean(thisSpecr.data.spc{targetData},1));
            for i = 1:size(thisSpecr.data.spc{targetData},1)
            [thisSpecr.data.bgcor{n+1}(i,:),~,~] = backcor(thisSpecr.data.wavenum{targetData}(i,:),...
                                                    thisSpecr.data.spc{targetData}(i,:),...
                                                    ord,s,fct);
            end
        else
            for i = 1:size(thisSpecr.data.spc{targetData},1)
            [thisSpecr.data.bgcor{n+1}(i,:),~,~] = backcor(thisSpecr.data.wavenum{targetData}(i,:),...
                                                    thisSpecr.data.spc{targetData}(i,:),...
                                                    order,threshold,nqcfct);
            end
        end
        thisSpecr.data.spc{end+1} = thisSpecr.data.spc{targetData} - thisSpecr.data.bgcor{end};
end
thisSpecr.data.wavenum{end+1} = thisSpecr.data.wavenum{targetData};
thisSpecr.label.history{1,end+1} = ['background removed with ',method,' method'];
thisSpecr.label.history{2,end} = datetime('now');

thisSpecr.data.removed{end+1} = [];
end


