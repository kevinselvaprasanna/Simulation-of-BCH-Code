function gen_msg(file_name, k)
file = fopen(file_name, 'w');
for i = 1:10
    msg = unidrnd(2, [1, k]) - 1;
    fprintf(file, '%2d', msg);
    fprintf(file, '\n');
end
fprintf(file, '\n');
fclose(file);
