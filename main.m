% File name to store/read the message word
msg_file_name = 'msg.txt';
% File name to store the codeword
code_file_name = 'codeword.txt';

% Design parameters of the code
m = 7;
n = 2^m-1;
d = 15;
t = fix((d-1)/2);

% Minimum polynomials of all element of the field
min_poly = gfminpol([1:2*t]', m);

% Generator polynomial obtained from lcm of minimal polynomials
gen_poly = 1;
for i = 1:2:(2*t-1)
    gen_poly = gfconv(min_poly(i, :), gen_poly);
end

% To display the generator polynomial
gfpretty(gen_poly)

% Uncomment for generating the message words
[i, n_k] = size(gen_poly);
gen_msg(msg_file_name, n - n_k + 1);

% Read messages from file
messages = read_file(msg_file_name, n - n_k + 1);
[s, k] = size(messages);
% Systematic encoding
for i = 1:s
    code_words(i, :) = conv(messages(i, :), cat(2, zeros(1, n-k), 1));
    [quo, rem] = gfdeconv(code_words(i,:), gen_poly);
    code_words(i, 1:length(rem))=rem;
end

% Write code words to output file
code_file = fopen(code_file_name, 'w');
for i = 1:s
     fprintf(code_file, '%2d', code_words(i, :));
     fprintf(code_file, '\n');
end
