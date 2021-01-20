function [ spectra ] = spectrouiopen()
%spectrauiopen imports spectral data in txt format to matlab.
%   The output argument is a structure array 
%   .cell_type: 
%       information about cell type, specified by the prompt
%   .cell_conditions:
%       information about culturing conditions such as probes used,
%       specified by the prompt
%   .cell_num: 
%       numbers of spectra imported
%   .oriWaveNum: 
%       x axes of the spectra
%   .oriSpectrum: 
%       y axes of the spectra
%   .noiseAt1800To1900:
%       noise estimated as the standard deviation betwen 1800~1900 cm-1


[FileName,PathName,FileIndex] = uigetfile('*.txt','MultiSelect','on');
if ~FileIndex
    error('No file imported')
end

if ~iscell(FileName)    % convert FileName to a cell if only one file is imported
    FileName = cellstr(FileName);
end

prompt = {'Enter cell type:','Enter conditions:'};
title = 'Specify conditions';
options.Interpreter = 'tex';
options.Resize = 'on';

answer = inputdlg(prompt,title,[1 40;1 40],{'cell type','probes'},options);
spectra.cell_type = answer{1};
spectra.cell_conditions = answer{2};


if iscell(FileName)    % if multiple files are opened
    for i = 1:length(FileName)
        fileID = fopen([PathName FileName{i}]);
        txt_read = textscan(fileID,'%f %f');
        spectra.oriWaveNum(:,i) = txt_read{1};
        spectra.oriSpectrum(:,i) = txt_read{2};
        spectra.oriWaveNum_min = min(min(spectra.oriWaveNum));
        spectra.oriWaveNum_max = max(max(spectra.oriWaveNum));
        spectra.oriWaveNum_interval = (spectra.oriWaveNum_max - spectra.oriWaveNum_min) ...
            / (length(spectra.oriWaveNum(:,1)) - 1);
        fclose(fileID);
    end

spectra.cell_num = size(spectra.oriSpectrum,2);
spectra.axis_aligned = false;
spectra.trimed = false;
spectra.normalized = false;
spectra.background_corrected = false;
spectra.smoothed = false;
end

