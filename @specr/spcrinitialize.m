function [spectra] = spcrinitialize(inputSpc)
%SPCinitialize Creates all the fields if not have been done so

%% Set possible fields
% datafield = {
%             'bgcor';...
%             'spc';...
%             'wavenum'...
%             'removed'...
%             };
% labelfield = {
%             'propertyName';...
%             'propertyValue';...
%             'oriFileName';...
%             'fileName';...
%             'cellType';...
%             'cellProbes';...
%             'history';...
%             };
% statsfield = {
%             'spcMean';...
%             'spcStd';...
%             'spcResolution';...
%             'cellNum';...
%             };

load initialfields.mat datafield labelfield statsfield
%% Check if a field is already created, if not, setfield
for i = 1:length(datafield)    
    if ~spcisfield(inputSpc,datafield{i})
        inputSpc.data.(datafield{i}) = {};
    end
end

for i = 1:length(labelfield)
    if ~spcisfield(inputSpc,labelfield{i})
        inputSpc.label.(labelfield{i}) = {};
    end
end

for i = 1:length(statsfield)
    if ~spcisfield(inputSpc,statsfield{i})
        inputSpc.stats.(statsfield{i}) = {};
    end
end

spectra = inputSpc;

end

