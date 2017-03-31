function gen_msg(file_name, k)

	% Generates some random message word. Used for testing.
	% file_name - to store the message words
	% k - Size of message.

    file = fopen(file_name, 'w');
    
    for i = 1:10
        msg = unidrnd(2, [1, k]) - 1;
        fprintf(file, '%2d', msg);
        fprintf(file, '\n');
    end

    fprintf(file, '\n');
    fclose(file);
end