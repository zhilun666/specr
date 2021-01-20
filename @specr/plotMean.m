function plotMean(thisSpecr,varargin)
%plotMean plot the mean spectra
%   Detailed explanation goes here


%% Parse input
p = inputParser;

defaultPlot = length(thisSpecr.data.spc);

defaultShifter = 0;
defaultbslshift = 0;

defaultLgnd = 'cellType';
validLgnd = {'cellType','fileName'};
checkLgnd = @(x) any(validatestring(x,validLgnd));

addRequired(p,'spectra',@isobject);
addParameter(p,'data',defaultPlot,@isscalar);
addParameter(p,'shifter',defaultShifter,@isscalar);
addParameter(p,'bslshift',defaultbslshift,@isscalar);
addParameter(p,'legend',defaultLgnd,checkLgnd);

parse(p,thisSpecr,varargin{:});

plotfig = p.Results.data;
shifter = p.Results.shifter;
bslshifter = p.Results.bslshift;
lgnd = p.Results.legend;

x = thisSpecr.data.wavenum{plotfig};
y = thisSpecr.data.spc{plotfig};


shifterArray = shifter*(0:1:size(y,1)-1)' + bslshifter;
shifterArray = repmat(shifterArray,1,size(y,2));

y = y + shifterArray;

%% Plot

yy = mean(y,1);
xx = mean(x,1);

plot(xx,yy,'LineWidth',0.5)

%% Add labels

xlabel('Raman shift (cm^{-1})')
ylabel('intensity (A.U.)')


pos = get(gcf,'pos');
set(gcf,'pos',[pos(1) pos(2) 600 400])
set(gca,'color','none')
%set(lgnd,'color','none')



end

