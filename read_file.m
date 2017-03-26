function data = read_file(file_name, k)
fileID = fopen(file_name,'r');
sizeA = [k Inf];
data = fscanf(fileID,'%d',sizeA);
data =data';
fclose(fileID);
