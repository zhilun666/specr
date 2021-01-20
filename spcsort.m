function [ spectra ] = spcsort( input_spectra,sequence )
%SPCSORT Rearrange the sequence of the contents in each fields
%   

spectra = input_spectra;
fieldname1 = {'data','label'};
for i = 1:numel(fieldname1)
    fieldname2 = fieldnames(spectra.(fieldname1{i}));
    for j = 1:numel(fieldname2)
        try
        spectra.(fieldname1{i}).(fieldname2{j}) = ...
            spectra.(fieldname1{i}).(fieldname2{j})(:,sequence);
        catch
            disp(['Note: .' fieldname1{i} '.' fieldname2{j} ' is not sorted.'])
        end
    end
end

end

