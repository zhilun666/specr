function spectraplot1(spectra,varargin)
%spectraplot Plots the spectra input as a structure array generated by
%spectrauiopen
%   
hold on
for i = 1:spectra.cell_num  
    plot(spectra.wavenum,spectra.spectrum(:,i),...
    'Linewidth',1)
end

lgndtxt = cell(spectra.cell_num,1);
for i = 1:spectra.cell_num
    lgndtxt{i} = ['cell',num2str(spectra.cellID(i)),' ',spectra.propertyValue{8,i},' s exposure'];
end

xlabel('Raman shift (cm^{-1})')
ylabel('intensity (A.U.)')
lgnd=legend(lgndtxt);

pos = get(gcf,'pos');
set(gcf,'pos',[pos(1) pos(2) 600 400])
set(gca,'color','none')
set(lgnd,'color','none')

hold off

end

