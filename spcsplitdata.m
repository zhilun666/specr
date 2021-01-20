function [splitData] = spcsplitdata(inputData,inputLabel,testProportion)
%SPCSPLITDATA Splits the input data into training data and testing data
%according to the training proportion
%   Input arguments:
%       inputData: row data that is to be split
%       inputLabel: the labels
%       testProportion: the percentage of testing data
%   Output argument:
%       splitData.xTr: row training data
%       splitData.yTr: row training labels
%       splitData.xTe: row testing data
%       splitData.yTe: row testing labels

N = size(inputData,1);  % total number of rows 
tf = false(N,1);    % create logical index vector
tf(1:round((1-testProportion)*N)) = true;     
tf = tf(randperm(N));   % randomise order
splitData.xTr = inputData(tf,:);
splitData.yTr = inputLabel(tf,:);
splitData.xTe = inputData(~tf,:);
splitData.yTe = inputLabel(~tf,:);

end

