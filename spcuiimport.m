function [spectra] = spcuiimport(varargin)
%SPCUIIMPORT Opens and import spectra data to matlab
%   Detailed explanation goes here

%% Open spectra and intialize
spectra = spcuiopen();
spectra = spcinitialize(spectra);
%% Parse inputs
p = inputParser;
defaultIfSepBg = false;
defaultIdentifier = 'none';
defaultIsIdentifierFront = true;
defaultBgExp = 'none';

addParameter(p,'ifSeparateBackground',defaultIfSepBg,@islogical);
addParameter(p,'identifier',defaultIdentifier,@ischar);
addParameter(p,'isIdentifierFront',defaultIsIdentifierFront,@islogical);
addParameter(p,'backgroundExpression',defaultBgExp,@ischar);

p.KeepUnmatched = false;

parse(p,varargin{:});

ifSeparateBackground = p.Results.ifSeparateBackground;
identifier = p.Results.identifier;
isIdentifierFront = p.Results.isIdentifierFront;
backgroundExpression = p.Results.backgroundExpression;

%% Separate background
if ifSeparateBackground % subtract the background
    spectra.label.spcID(1,:) = spcgetid(spectra,'identifier',identifier,...
                                        'isIdentifierFront',isIdentifierFront);
    spectra = spcbgsub(spectra,backgroundExpression,'norm2Si–O–Si');
else % if not subtraction equate original data to spc and wavenum
    spectra.data.spc = spectra.data.oriSpc;
    spectra.data.wavenum = spectra.data.oriWaveNum;
    spectra.label.spcID(1,:) = spcgetid(spectra);
end

