function [calibAxis] = spccalibstd(data,varargin)
%SPCCALIBSTD(DATA,VARARGIN) Takes a spectrum of standard reference to
%calibrate the wavenumber axis.
%
%   CALIBAXIS : the standard calibrated wavenumber axis
%
%   DATA : the spectrum of the reference of choice
%
%   -Name value pair options:
%       'standard','option'
%           valid options include 'DMSO','polystyrene', 'intrinsic', 'A/T'
%       'mode','option'
%           valid options include 'auto','manual'. When manual is used, the
%          input data should be the CCD index of the main peaks.
%   Explanation:
%       This function first finds the peaks in the input standard spectrum
%       with pre-defined parameters.Then a Lorentz function is fit to each 
%       peak to locate the centers. Then a polynomial function is fit to
%       the peaks to correlate the wavenumber to CCD indexes. The output is
%       thus the reference calibrated wavenumber axis.
%
%% Parse input
p = inputParser;

defaultStd = 'DMSO';
validStd = {'DMSO','polystyrene','intrinsic','fingerprint','A/T'};
checkStd = @(x) any(validatestring(x,validStd));

defaultMode = 'auto';
validMode = {'auto','manual'};
checkMode = @(x) any(validatestring(x,validMode));

defaultLength = 1600;

addRequired(p,'data')
addParameter(p,'standard',defaultStd,checkStd);
addParameter(p,'peakDetectionMode',defaultMode,checkMode);
addParameter(p,'xlength',defaultLength,@isscalar);
parse(p,data,varargin{:});

stdrd = p.Results.standard;
data = p.Results.data;
mode = p.Results.peakDetectionMode;
xlength = p.Results.xlength;

%% Peak assignment
dmso = [667,698,1417,2913,2994]; % J. Raman Spectrosc. 2002;33:84-91
%intri = [1005,1446,1661,2069,2940]; % Appl Spectrosc Rev 42, 493–541 (2007)
intri = [1005,1446,1661,2103,2940]; % Appl Spectrosc Rev 42, 493–541 (2007)
% ASTM E1840-96 
at = [786.5,919.0,1003.6,1030.6,1211.4,1605.1,2253.7,2940.8,3057.1];

%polystyrene = [];
switch stdrd
    case 'DMSO'
        ref = dmso;
    case 'polystyrene'
        ref = polystyrene;
    case 'intrinsic'
        ref = intri;
    case 'A/T'
        ref = at;
    otherwise
        warning('no type of standard specified')
end

%% Fit peaks with 3rd order polynomial
switch mode
    case 'auto'
        [pkloc] = spcpksfit(data,'standard',stdrd);
    case 'manual'
        [pkloc] = data;
end
f = polyfit(pkloc,ref,3);
cfun = @(x,f) f(1,1)*x.^3+f(1,2)*x.^2+f(1,3)*x+f(1,4);
% f = polyfit(pkloc,ref,4);
% cfun = @(x,f) f(1,1)*x.^4+f(1,2)*x.^3+f(1,3)*x.^2+f(1,4)*x+f(1,5);

x = 1:1:xlength; % x is the pixel index

calibAxis = cfun(x,f);
end

