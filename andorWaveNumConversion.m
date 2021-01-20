function [ spectra ] = andorWaveNumConversion( spectra_input,targetWaveNum )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
spectra = spectra_input;

index = contains(spectra.propertyName,'Wavelength (nm)');
if  spectra.propertyValue{index} == num2str(targetWaveNum)
else
    spectra.wavenum = spectra.oriWaveNum - 10^7*(1/targetWaveNum - 1/str2double(spectra.propertyValue{index}));

end

