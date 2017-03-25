fileID = fopen('msg.txt','r');
A = fscanf(fileID,'%d');
A = reshape(A,[length(A)/78 78]);
fclose(fileID);