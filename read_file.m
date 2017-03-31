function data = read_file(file_name, k)
	
	% Reads data from a file and stores it into a 2D array
	% file_name - Name of the file to read
	% k - size of each word

    fileID = fopen(file_name,'r');
    sizeA = [k Inf];
    data = fscanf(fileID,'%d',sizeA);
    data =data';
    fclose(fileID);
end
