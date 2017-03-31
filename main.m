clear
% File name to store/read the message word
msg_file_name = 'msg.txt';
% File name to store the codeword
code_file_name = 'codeword.txt';

out_file_name = 'decoderOut.txt';

% Design parameters of the code
m = 7;
n = 2^m-1;
d = 15;
t = fix((d-1)/2);

bch_code = bch(m, d);
bch_code = bch_code.generator_polynomial();
% Read messages from file
messages = read_file(msg_file_name, bch_code.k);
[s, k] = size(messages);
code_words = bch_code.encode(messages);

% Write code words to output file
code_file = fopen(code_file_name, 'w');
for i = 1:s
     fprintf(code_file, '%2d', code_words(i, :));
     fprintf(code_file, '\n');
end
fclose(code_file);

rx = read_file('rx.txt', n);
[rec_corrected, messages] = bch_code.decode_with_erasures(rx);

out_file = fopen(out_file_name, 'w');
for i = 1:s
     fprintf(out_file, '%2d', rec_corrected(i, :));
     fprintf(out_file, '\n');
     fprintf(out_file, '%2d', messages(i, :));
     fprintf(out_file, '\n');
end
fclose(out_file);
