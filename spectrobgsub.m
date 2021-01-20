function [ spectra ] = spectrobgsub( input_spectra,identifier,isIdentifierFront,bgexpression )
%SPECTOBGSUN Finds the signal and background files and subtracts bg from
%signal
%   input_spectra: the spectra to be parsed
%   identifier: the keywords behind/prior to which the indexes are labeled
%   isIdentifierFront: if the identifier is in front of the index or behind
%   bgexpression: the keywords to identify background files

%% initial sorting based on acquisition conditions
% sort based on condition
% spectra = spectrosort(input_spectra);
spectra = input_spectra;
%% reorganize spectra based on the same cells
% find index of same cells
[startIDIndex,endIDIndex] = regexp(spectra.fileName,identifier);
startIDIndex = cell2mat(startIDIndex);
endIDIndex = cell2mat(endIDIndex);

ID = zeros(1,length(spectra.fileName));
for i = 1:length(spectra.fileName)
    if isIdentifierFront
        ID(i) = str2double(spectra.fileName{i}(startIDIndex(i)-1));
    else
        ID(i) = str2double(spectra.fileName{i}(endIDIndex(i)+1));
    end
end

% sort different spectra of the same cells
[ID,sortSeq] = sort(ID);
spectra = spectrosort(spectra,sortSeq);
spectra.cellID = ID;

% get the index of the same cells
%[uniqueID, ia, ic] = unique(ID,'sorted');

%% sort based on exporsure among each group of spactra of the same cells, but seems unnecessary
% if length(uniqueID) > 1
%     index = contains(spectra.propertyName,'Exposure Time (secs)');
%     exposureTime = spectra.propertyValue(index,:);
%     [~,s] = sort(str2double(exposureTime(ic==1)));
%     for i=2:length(uniqueID)       
%        [~,ss] = sort(str2double(exposureTime(ic==i)));
%        s = [s,ss + length(s)];
%     end
%     spectra = spectrosort(spectra,s);
% end

%% find background and subtract bg
bgID = regexp(spectra.fileName,bgexpression);
bgID = ~cellfun(@isempty,bgID);
spectra.spectrum = spectra.oriSpectrum(:,~bgID) - spectra.oriSpectrum(:,bgID);


spectra.cellID(bgID) = [];
%spectra.propertyValue(:,bgID) = [];
spectra.cell_num = spectra.cell_num/2;
end

