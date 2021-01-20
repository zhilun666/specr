function [ propertyName,propertyValue ] = readAndorProperty( fileID )
%READANDORPROPERTY Reads the acquisition properties from a text file header

time = textscan(fileID,'%s %s %s %s',1,'Delimiter',':');
time{1,2} = [time{1,2}{1,1} ...
                ':' time{1,3}{1,1}...
                ':' time{1,4}{1,1}];
time(3:end)=[];
property = textscan(fileID,'%s %s','Delimiter',':');
property = [time{:,:};property{:,:}];
propertyName = property(:,1);
propertyValue = property(:,2);

end

