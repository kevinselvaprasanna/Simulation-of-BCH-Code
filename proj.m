pol = gfminpol([1:14]',7);
g=1;
for i=1:2:13
g=conv(g,pol(i,:));
end
g=rem(g,2);
gfpretty(g)
generate
readfile
for i=1:10
sent(i,:) = conv(g,A(i,:));
end
sent=rem(sent,2)
