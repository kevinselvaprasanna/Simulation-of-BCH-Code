pol = gfminpol([1:14]',7);
g=1;
for i=1:2:13
g=gfconv(pol(i,:),g);
end
gfpretty(g)
generate
readfile
[a b] = size(A);
% for i=1:a
%     codeword(i,:) = conv(A(i,:),g);
% end
% codeword=rem(codeword,2);
for i=1:a
    codeword(i,:) = conv(A(i,:),cat(2,zeros(1,49),[1]));
    [quo rem] = gfdeconv(codeword(i,:),g);
    codeword(i,1:length(rem))=rem;
end
fileId = fopen('codeword.txt','w');
for i=1:a
     fprintf(fileID,'%2d',codeword(i,:));
     fprintf(fileID,'\n');
end



