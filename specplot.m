figure()
hold on
for i = 1:spectra.cell_num
    plot(spectra.wavenum(:,i),spectra.spectrum(:,i),...
    'LineWidth',1)
end

lgndtxt = cell(spectra.cell_num,1);
for i = 1:spectra.cell_num
    lgndtxt{i} = [spectra.cell_type,' ', spectra.probes, ' cell' int2str(i)];
end

xlabel('Raman shift (cm^{-1})')
ylabel('intensity (A.U.)')
lgnd=legend(lgndtxt);

pos = get(gcf,'pos');
set(gcf,'pos',[pos(1) pos(2) 600 400])
set(gca,'color','none')
set(lgnd,'color','none')

hold off