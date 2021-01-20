function spcplot(spectra,varargin)
%spectraplot Plots the spectra input as a structure array generated by
%spectrauiopen
%   

%% Parse input
p = inputParser;

defaultPlot = 'processed';
validPlot = {'processed','original'};
checkPlot = @(x) any(validatestring(x,validPlot));

defaultShifter = 0;
defaultbslshift = 0;

defaultLgnd = 'cellType';
validLgnd = {'cellType','fileName'};
checkLgnd = @(x) any(validatestring(x,validLgnd));

addRequired(p,'spectra',@isstruct);
addParameter(p,'data',defaultPlot,checkPlot);
addParameter(p,'shifter',defaultShifter,@isscalar);
addParameter(p,'bslshift',defaultbslshift,@isscalar);
addParameter(p,'legend',defaultLgnd,checkLgnd);

p.KeepUnmatched = false;

parse(p,spectra,varargin{:});

plotfig = p.Results.data;
shifter = p.Results.shifter;
bslshifter = p.Results.bslshift;
lgnd = p.Results.legend;

if strcmpi(plotfig,'processed')
    x = spectra.data.wavenum;
    y = spectra.data.spc;
else
    x = spectra.data.oriWaveNum;
    y = spectra.data.oriSpc;
end

shifterArray = shifter*(0:1:size(y,2)-1) + bslshifter;
shifterArray = repmat(shifterArray,size(y,1),1);

y = y + shifterArray;

%% Plot

hold on

plot(x,y,'LineWidth',1.5)


%% Add labels

xlabel('Raman shift (cm^{-1})')
ylabel('intensity (A.U.)')


pos = get(gcf,'pos');
set(gcf,'pos',[pos(1) pos(2) 600 400])
set(gca,'color','none')
%set(lgnd,'color','none')

hold off

end
