function [outputSpec] = spcmergedata(varargin)
%SPCMERGE Merges multiple spectra into one structure array
%   This function only merges data from the last operation in the original
%   data set.
load initialfields.mat labelfield

outputSpec = specr;
n = numel(varargin);


for j = 1:n
    
    outputSpec.data.spc = [outputSpec.data.spc;varargin{j}.data.spc(end)];
    outputSpec.data.wavenum = [outputSpec.data.wavenum;varargin{j}.data.wavenum(end)];
end


for j = 1:n  
    for i = 1:length(labelfield)
        outputSpec.label.(labelfield{i}) = [outputSpec.label.(labelfield{i}),varargin{j}.label.(labelfield{i})];
    end
end

end


