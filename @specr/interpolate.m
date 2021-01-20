function interpolate(thisSpecr,x,varargin)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
%% Parsing inputs
p = inputParser;
defaultData = length(thisSpecr.data.spc);

addRequired(p,'thisSpecr',@isobject);
addRequired(p,'x',@isvector);
addParameter(p,'data',defaultData,@isscalar);

parse(p,thisSpecr,x,varargin{:});

targetdata = p.Results.data;

%% Function starts
a = zeros(size(thisSpecr.data.spc{targetdata},1),size(x,2));

for i = 1:size(a,1)
    a(i,:)= spline(thisSpecr.data.wavenum{targetdata}(i,:),thisSpecr.data.spc{targetdata}(i,:),x);
end

thisSpecr.data.spc{end+1} = a;
thisSpecr.data.wavenum{end+1} = repmat(x,size(thisSpecr.data.spc{targetdata},1),1);


%% Adding labels
% Add history
thisSpecr.label.history{1,end+1} = ['interpote from ',num2str(x(1)),' to ',num2str(x(end))];
thisSpecr.label.history{2,end} = datetime('now');

% Fill the empty spaces
thisSpecr.data.bgcor{end+1} = [];
thisSpecr.data.removed{end+1} = [];

end

