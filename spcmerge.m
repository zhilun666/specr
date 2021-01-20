function [outputSpec] = spcmerge(varargin)
%SPCMERGE Merges multiple specr into one specr class
%   

%% Set possible fields

load initialfields.mat datafield labelfield statsfield

%% Check if a field is already created, if not, setfield
outputSpec = specr;
n = numel(varargin);

for j = 1:n
    for i = 1:length(datafield)
        outputSpec.data.(datafield{i}) = [outputSpec.data.(datafield{i});varargin{j}.data.(datafield{i})];
    end
end

for j = 1:n  
    for i = 1:length(labelfield)
        outputSpec.label.(labelfield{i}) = [outputSpec.label.(labelfield{i}),varargin{j}.label.(labelfield{i})];
    end
end


for j = 1:n
    for i = 1:length(statsfield)
        outputSpec.stats.(statsfield{i}) = [outputSpec.stats.(statsfield{i});varargin{j}.stats.(statsfield{i})];
    end
end



end


