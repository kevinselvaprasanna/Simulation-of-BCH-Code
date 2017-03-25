fileID = fopen('msg.txt','w');
msg = unidrnd(2,[1,78])-1;
fprintf(fileID,'%2d',msg);
for i=1:10
    fprintf(fileID,'\n');
    msg = unidrnd(2,[1,78])-1;
    fprintf(fileID,'%2d',msg);
end
fprintf(fileID,'\n');
fclose (fileID);