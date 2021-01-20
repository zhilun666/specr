function [accuracy] = spcknneval(X,Y,k,xTe,yTe)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
Mdl = fitcknn(X,Y,'NumNeighbors',k,'Standardize',0);
yfit = predict(Mdl,xTe);
accuracy = sum(yfit==yTe)/length(yTe);

end

