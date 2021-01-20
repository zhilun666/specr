S = cellfun(@(x) x(1:end-8), a.label.fileName,'un',0);
[~, ia, ~] = unique(S);
bgIdntfer = cellfun(@(x) regexp(x,'bg'), a.label.fileName,'un',0);
bgInx = cellfun(@(x) ~isempty(x), bgIdntfer,'un',1);