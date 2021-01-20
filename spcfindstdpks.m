function [loc,width] = spcfindstdpks(data,varargin)
%SPCFINDSTDPKS Uses the findpeaks function to automatically detect peak
%position and width for pre-defined standards

%% Parse input
p = inputParser;

defaultStd = 'DMSO';
validStd = {'DMSO','polystyrene','A/T'};
checkStd = @(x) any(validatestring(x,validStd));

addRequired(p,'data');
addParameter(p,'standard',defaultStd,checkStd);

parse(p,data,varargin{:});

stdrd = p.Results.standard;
data = p.Results.data;

%%
%data = normalize(data,2,'norm');
data = data - mean(data,2);
data = data ./ sqrt(sum(data.^2, 2));

switch stdrd
    case 'DMSO'
        [~,loc,width,~] = findpeaks(data,'Annotate','extents','MinPeakProminence',0.02,'MaxPeakWidth',15);
    case 'A/T'
        [~,loc,width,~] = findpeaks(data,'Annotate','extents','MinPeakProminence',0.02,'MaxPeakWidth',15);
        loc(6)=[];
    otherwise
        warning('no type of standard specified')
end
end

