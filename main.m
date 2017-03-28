% File name to store/read the message word
msg_file_name = 'msg.txt';
% File name to store the codeword
code_file_name = 'codeword.txt';

% Design parameters of the code
m = 7;
n = 2^m-1;
d = 15;
t = fix((d-1)/2);

bch_code = bch(m, d);

% Read messages from file
messages = read_file(msg_file_name, n - m*t);

code_words = bch_code.encode(messages);

% Write code words to output file
code_file = fopen(code_file_name, 'w');
for i = 1:s
     fprintf(code_file, '%2d', code_words(i, :));
     fprintf(code_file, '\n');
end
fclose(code_file);

rx = read_file('rx.txt', n);
sigma = bch_code.decode(rx);

% j = 1;
% beta = roots(sigma);
% for i = 1:length(beta)
%     if(beta(i) ~= 0)
%         err(j) = log(beta(i));
%         j = j + 1;
%     end
% end
