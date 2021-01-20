function [spcID] = spcgetid(spectra,varargin)
%SPCGETID Gets the index of each spectra.
%   -If the function is called with optional parameters, the function
%   returens index by matching regular expression provided
%   -If the function is call without optional parameter, the function
%   assigns index sequentially

%% Parse inputs
p = inputParser;
defaultIdentifier = 'none';
defaultIsIdentifierFront = true;

addRequired(p,'spectra',@isstruct);
addParameter(p,'identifier',defaultIdentifier,@ischar);
addParameter(p,'isIdentifierFront',defaultIsIdentifierFront,@islogical);

p.KeepUnmatched = false;

parse(p,spectra,varargin{:});

identifier = p.Results.identifier;
isIdentifierFront = p.Results.isIdentifierFront;


%% 
if ~strcmp(identifier,'none')
    ID = zeros(1,length(spectra.label.oriFileName));
    for i = 1:length(ID)
        if isIdentifierFront
            expr = ['\d+(?=',identifier,')'];
            ID(i) = str2double(regexp(spectra.label.oriFileName{i},expr, 'match'));
        else
            expr = ['(?<=',identifier,')','\d+',];
            ID(i) = str2double(regexp(spectra.label.oriFileName{i},expr, 'match'));
        end
    end
else
    ID = 1:size(spectra.data.oriSpc,2);
end

spcID = ID;

end

