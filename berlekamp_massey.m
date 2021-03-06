function [sigma] = berlekamp_massey(S, t, m)
    sigma=gf(zeros(t+2,t+1), m);
    k = 1;
    sigma(1, 1) = 1;
    d=gf(zeros(1, 2*t), m);
    d(k)=gf(1, m);
    l(k) = 0;
    k = k + 1;
    sigma(2, 1) = 1;
    d(k) = S(1);
    l(k) = 0;
    sigma(3, 1) = 1;
    sigma(3, 2) = S(1);
    li = k;
    l(3) = 1;
    for k = 3:t+1
        d(k) = 0;
        ch=flip(S(2*k-3-l(k):2*k-3)).*sigma(k, 1:l(k)+1);
        for j = 1:l(k)+1
            d(k) = d(k)+ch(j);
        end
        if(d(k) == 0)
            sigma(k+1, :) = sigma(k, :);
            l(k+1) = l(k);
        else
            corr = d(k).*d(li).^-1.*conv(cat(2, zeros(1, 2*(k-li)), [1]), sigma(li, :));
            for p = 1:l(k)+1
                corr(p) = sigma(k, p) + corr(p);
            end
            sigma(k+1, 1:length(corr)) = corr;
            l(k+1) = k-1;
            if(2*k-l(k) > 2*li-l(li))
                li = k;
            end
        end
        k = k+1;
    end
    sigma = sigma(k, :);
end
