function [output] = myspecr(dir,t)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
output = specr;
output.importdata('dir',dir)
%output.importdata()
output.removeLowSNR('threshold',t)
%output.data.wavenum{1} = output.data.wavenum{1} + 20;
output.removeBg()
output.removeBg('fct','nqc')
%output.trim(650,1750)
output.normalize('fct','amide')
%output.calibrate(stdrd)
% output.removeOutliner('threshold',0.9)
% output.trim(1975,2250,'data',6)
%output.trim(2000,2350)
% output.trim(620,1850,'data',5)

end

