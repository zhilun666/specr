function spcmarkpeaks(varargin)
%SPCMARKPEAKS Adds assignment to common features in the spectra
%   Reference: Raman Spectroscopy of Biological Tissues. Zanyar Movasaghi et al., Applied Spectroscopy Reviews 2007
database = {
    752, 'DNA';
    782, 'DNA(U,T,C)';
    831, 'nucleic acids (PO^2-)';
    1004, 'phenylalanine';
    1031, 'phenylalanine';
    1095, 'lipid';
    1127, 'v(C-N)';
    1172, 'v(C-H)';
    1250, 'amide III';
    1304, 'lipid';
    1333, 'nucleic acids (guanine)';
    1442, 'fatty acids';
    1575, 'DNA';  
    1602, 'phenylalanine';
    1614, 'tyrosine';
    1650, 'amide I';    
    };
shift=0;
for i = 1:size(database,1)
    hold on
    line([database{i,1}+shift database{i,1}+shift],[0 0.03])
    text(database{i,1},0.03-0.003*rem(i,3),database{i,2})
end
    hold off
end

