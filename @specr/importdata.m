function importdata(thisSpecr,varargin)
%spectrauiopen imports spectral data in txt format to matlab.
%   The output argument is a structure array 
%   .data.spc   
%       original spectra
%   .data.wavenum
%       original wavenumbers

% Parse inputs
p = inputParser;
defaultMode = 'overwrite';
validMode = {'overwrite','append'};
checkMode = @(x) any(validatestring(x,validMode));

defaultDelimiter = ';';
defaultDir = [];

addRequired(p,'thisSpecr',@isobject);
addOptional(p,'mode',defaultMode,checkMode);
addOptional(p,'delimiter',defaultDelimiter);
addOptional(p,'dir',defaultDir)
p.KeepUnmatched = false;

parse(p,thisSpecr,varargin{:});

mode = p.Results.mode;
delimiter = p.Results.delimiter;
directory = p.Results.dir;
%% Open files with GUI / dir provided
if isempty(directory)
    [FileName,PathName,FileIndex] = uigetfile('*','MultiSelect','on');
    if ~FileIndex
        error('No file imported')
    end

    if ~iscell(FileName)    % convert FileName to a cell if only one file is imported
        FileName = cellstr(FileName);
    end
else
    files = struct2cell(dir(directory));
    FileName = files(1,:);
    idcs = strfind(directory,filesep);
    PathName = [directory(1:idcs(end)-1),filesep];
end
    
%% Read data

for i = 1:length(FileName)
    fileID = fopen([PathName FileName{i}]);
    txt_read = textscan(fileID,'%f %f','Delimiter',delimiter);

    % CONSTRUCT: spectra.data.oriWaveNum; spectra.data.oriSpc
    wavenum{1}(i,:) = txt_read{1};
    spc{1}(i,:) = txt_read{2};

    fclose(fileID);
end

switch mode
    case 'overwrite'
        thisSpecr.data.wavenum = wavenum;
        thisSpecr.data.spc = spc;
        thisSpecr.label.fileName = FileName;
        thisSpecr.label.history{1,1} = 'import';
        thisSpecr.label.history{2,1} = datetime('now');
    case 'append'
        thisSpecr.data.wavenum = {[thisSpecr.data.wavenum{1};wavenum{1}]};
        thisSpecr.data.spc = {[thisSpecr.data.spc{1};spc{1}]};
        thisSpecr.label.fileName = [thisSpecr.label.fileName,FileName];
        thisSpecr.label.history{1,1} = [thisSpecr.label.history{1,1}, ' and extra data added'];
        thisSpecr.label.history{2,1} = [thisSpecr.label.history{2,1},datetime('now')];
end
thisSpecr.data.bgcor{1,1} = [];
thisSpecr.data.removed{1,1} = [];
end

