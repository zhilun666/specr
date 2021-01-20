function [ indexAtMin,indexAtMax ] = spcfindregion( thisSpecr,lowerEdge,upperEdge,varargin )
%SPECTRAFINDREGION Finds the cloeset positions to the lower and upper edges
%input and returns the cooresponding indexes

%% parse inputs
p = inputParser;
defaultData = length(thisSpecr.data.spc);

addRequired(p,'spectrainput');
addRequired(p,'lowerEdge',@isnumeric);
addRequired(p,'upperEdge',@isnumeric);
addOptional(p,'data',defaultData,@isscalar);

p.KeepUnmatched = false;

parse(p,thisSpecr,lowerEdge,upperEdge,varargin{:});

spc = p.Results.spectrainput;
lowerEdge = p.Results.lowerEdge;
upperEdge = p.Results.upperEdge;
data = p.Results.data;

%% find the indexes of desired wavenumber
% the operation acts on each row so the results are a column vector
% containing the indexes for each sample

% Find minimum distance for lowerEdge
[~, indexAtMin] = min(abs(spc.data.wavenum{data} - lowerEdge),[],2);
% Find minimum distance for upperEdge
[~, indexAtMax] = min(abs(spc.data.wavenum{data} - upperEdge),[],2);
    

end

