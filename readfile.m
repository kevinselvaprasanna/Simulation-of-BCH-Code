fileID = fopen('msg.txt','r');
formatSpec = '%d';
sizeA = [10 Inf];
A = fscanf(fileID,formatSpec,sizeA)
fclose(fileID);
A=A(:,1:78);