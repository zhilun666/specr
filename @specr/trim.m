function trim( thisSpecr,lowerEdge,upperEdge,varargin )
%spectratrim Trims the original spectra from lowerEdge to upperEdge by
%lookuping the closest wavenum of these inputs and then trim.

p = inputParser;
defaultData = length(thisSpecr.data.spc);
addRequired(p,'thisSpecr',@isobject);
addParameter(p,'data',defaultData,@isscalar);
parse(p,thisSpecr,varargin{:});

targetdata = p.Results.data;



% Find minimum distance for lowerEdge
[~, indexAtMin] = min(abs(thisSpecr.data.wavenum{targetdata} - lowerEdge),[],2);
% Find minimum distance for upperEdge
[~, indexAtMax] = min(abs(thisSpecr.data.wavenum{targetdata} - upperEdge),[],2);

% Trim the spectrum
thisSpecr.data.wavenum{end+1} = thisSpecr.data.wavenum{targetdata}(:,indexAtMin:indexAtMax);
thisSpecr.data.spc{end+1} = thisSpecr.data.spc{targetdata}(:,indexAtMin:indexAtMax); 

% Add history
thisSpecr.label.history{1,end+1} = ['trimed from ',num2str(lowerEdge),' to ',num2str(upperEdge)];
thisSpecr.label.history{2,end} = datetime('now');

% Fill the empty spaces
thisSpecr.data.bgcor{end+1} = [];
thisSpecr.data.removed{end+1} = [];
end

