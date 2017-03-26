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
fclose(code_file);

alpha=gf(2,7);
H=gf(zeros(2*t,n),7);
for i=1:2*t
    for j=1:n
        H(i,j)=alpha.^((j-1)*i);
    end
end
rx = read_file('rx.txt',127);
S=gf(zeros(1,2*t),7);
for i=1:2*t
    ch=H(i,:).*rx(1,:);
    for j=1:n
        S(i)=S(i)+ch(j);
    end
end
sigma=gf(zeros(t+2,t+1),7);
k=1;
sigma(1,1)=1;
d=gf(zeros(1,2*t),7);
d(k)=gf(1,7);
l(k)=0;
k=k+1;
sigma(2,1)=1;
d(k)=S(1);
l(k)=0;
sigma(3,1)=1;
sigma(3,2)=S(1);
li=k;
l(3)=1;
for(k=3:t+1)
    d(k)=0;
    ch=flip(S(2*k-3-l(k):2*k-3)).*sigma(k,1:l(k)+1);
    for j=1:l(k)+1
        d(k)=d(k)+ch(j);
    end
    if(d(k)==0)
        sigma(k+1,:)=sigma(k,:);
        l(k+1)=l(k);
    else
        corr = d(k).*d(li).^-1.*conv(cat(2,zeros(1,2*(k-li)),[1]),sigma(li,:));
        for p=1:l(k)+1
            corr(p)=sigma(k,p)+corr(p)
        end
        sigma(k+1,1:length(corr))=corr;
        l(k+1)=k-1;
        if(2*k-l(k)>2*li-l(li))
            li=k;
        end
    end
    k=k+1;
end
sigma(k,:)
j=1;
beta = roots(sigma(k,:));
for i=1:length(beta)
    if(beta(i)~=0)
        err(j)=log(beta(i));
        j=j+1;
    end
end
err

