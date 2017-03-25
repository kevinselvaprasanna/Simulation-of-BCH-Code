function data = read_file(file_name, k)
file = fopen(file_name, 'r');
data = fscanf(file, '%d');
data = reshape(data, [length(data)/k k]);
fclose(file);