function exponent = gflog(element)

	% Takes the log of a gf element.

    exponent = zeros(size(element));
    exponent(element ~= 0) = log(element(element ~= 0));
    exponent(element == 0) = -1;
end