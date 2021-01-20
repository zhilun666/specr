function [ spectra ] = spcuiopen()
%spectrauiopen imports spectral data in txt format to matlab.
%   The output argument is a structure array 
%   .data.oriSpc   
%       original spectrua
%   .data.oriWaveNum
%       original wavenumbers
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

%% Open files with GUI
[FileName,PathName,FileIndex] = uigetfile('*.txt','MultiSelect','on');
if ~FileIndex
    error('No file imported')
end

if ~iscell(FileName)    % convert FileName to a cell if only one file is imported
    FileName = cellstr(FileName);
end

% Prompts to ask cell type and probes used
prompt = {'Enter cell type:','Enter conditions:'};
title = 'Specify conditions';
options.Interpreter = 'tex';
options.Resize = 'on';
answer = inputdlg(prompt,title,[1 40;1 40],{'cell type','probes'},options);

% CONSTRUCT: spectra.label.cellType; spectra.label.cellProbes
spectra.label.cellType = answer{1};
spectra.label.cellProbes = answer{2};

%% Read data

for i = 1:length(FileName)
    fileID = fopen([PathName FileName{i}]);
    txt_read = textscan(fileID,'%f %f');

    % CONSTRUCT: spectra.data.oriWaveNum; spectra.data.oriSpc
    spectra.data.oriWaveNum(:,i) = txt_read{1};
    spectra.data.oriSpc(:,i) = txt_read{2};

    oriWaveNumMin = min(min(spectra.data.oriWaveNum));
    oriWaveNumMax = max(max(spectra.data.oriWaveNum));
    oriWaveNumResolution = (oriWaveNumMax - oriWaveNumMin) ...
        / (length(spectra.data.oriWaveNum(:,i)) - 1);

    % CONSTRUCT: spectra.stats.spcResolution
    spectra.stats.oriSpcResolution{1,i} = [oriWaveNumMin oriWaveNumMax];
    spectra.stats.oriSpcResolution{2,i} = oriWaveNumResolution;

    fclose(fileID);        
end

%% Initializing
spectra.label.oriFileName = FileName;



    
