function delete(thisSpecr,data2del)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load initialfields.mat datafield
%% 
for i = 1:length(datafield)    
        thisSpecr.data.(datafield{i})(:,data2del) = [];
end

thisSpecr.label.history(:,data2del) = [];





end

