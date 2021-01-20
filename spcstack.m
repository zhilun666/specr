function [outputSpec] = spcstack(thisSpecr)
%SPCSTACK Stacks merged specr object.
%   spcstack(specr1,spcr2,...) Stacks cell arrays in each field of merged
%   specr object.

%% Set possible fields

load initialfields.mat datafield
%% Check if a field is already created, if not, setfield
outputSpec = specr;

for i = 1:length(datafield)
    for j = 1:size(thisSpecr.data.(datafield{i}),2)
        outputSpec.data.(datafield{i}){1,j} = cell2mat(thisSpecr.data.(datafield{i})(:,j));
    end
end


outputSpec.label = thisSpecr.label;



end


