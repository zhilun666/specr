function [splitData,varargout] = spcRandomSelectData(inputData,inputLabel,trainNum,testNum,varargin)
%SPCRANDOMSELECTDATA Select randomly a certain number of data point
%specified according to the training proportion
%   Input arguments:
%       inputData: row data that is to be split
%       inputLabel: the labels
%       trainNum: the number of training data specified
%       testNum: the number of testing data specifed
%       /optional input/
%       'exclusion',exc
%           exc is an index array specifying which rows are excluded
%   Output argument:
%       splitData.xTr: row training data
%       splitData.yTr: row training labels
%       splitData.xTe: row testing data
%       splitData.yTe: row testing labels
%       /optional output/
%           [splitData,trIndex,teIndex]
%           trIndex: index array of which training row being selected
%           teIndex: index array of which testing row being selected

%% parse inputs
p = inputParser;

defaultExc = zeros(size(inputData,1),1);

addRequired(p,'inputData');
addRequired(p,'inputLabel');
addRequired(p,'trainNum');
addRequired(p,'testNum');
addOptional(p,'exclude',defaultExc);

p.KeepUnmatched = false;
parse(p,inputData,inputLabel,trainNum,testNum,varargin{:});

exclude = p.Results.exclude;
inputData = p.Results.inputData(~exclude,:);
inputLabel = p.Results.inputLabel(~exclude);
trainNum = p.Results.trainNum;
testNum = p.Results.testNum;

%% split data
if trainNum + testNum > size(inputData,1)
    error('more specified number of data points than in the dataset.')
end

nTr = size(inputData,1);  % total number of rows
trIndex = false(nTr,1);    % create logical index vector
trIndex(1:trainNum) = true;     
trIndex = trIndex(randperm(nTr));   % randomise order
splitData.xTr = inputData(trIndex,:);
splitData.yTr = inputLabel(trIndex,:);

testSetData = inputData(~trIndex,:);
testSetLabel = inputLabel(~trIndex,:);

nTe = size(testSetData,1);  % total number of rows
teIndex = false(nTe,1);     % create logical index vector
teIndex(1:testNum) = true;     
teIndex = teIndex(randperm(nTe));   % randomise order


splitData.xTe = testSetData(~teIndex,:);
splitData.yTe = testSetLabel(~teIndex,:);

if nargout == 3
    varargout{1} = trIndex;
    varargout{2} = teIndex;
end
end