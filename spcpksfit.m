function [pkloc] = spcpksfit(data,varargin)
%SPCPKSFIT Fits eack peak with Lorentz functions and return the precise
%peak location
%   This function calls spcfindstdpks funtion for peak auto detection.

%% Parse input
p = inputParser;

defaultStd = 'DMSO';
validStd = {'DMSO','polystyrene','A/T'};
checkStd = @(x) any(validatestring(x,validStd));

addRequired(p,'data')
addParameter(p,'standard',defaultStd,checkStd);

parse(p,data,varargin{:});

stdrd = p.Results.standard;
data = p.Results.data;
%%
[loc,width] = spcfindstdpks(data,'standard',stdrd);

pkloc=zeros(1,length(loc));
for i=1:length(loc)
    pk = data(loc(i)-ceil(width(i)):loc(i)+ceil(width(i)));
    [~,PARAMS,~,~] = lorentzfit(loc(i)-ceil(width(i)):loc(i)+ceil(width(i)),pk);
        % have to use evalc to suppress the disp from lorentzfit
    pkloc(i) = PARAMS(2);
end

