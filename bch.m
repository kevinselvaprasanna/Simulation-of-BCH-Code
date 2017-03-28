classdef bch
   properties
       % Design parameters of the code
       m;
       n;
       d;
       t;
       k;
       gen_poly;
   end
   methods
      function obj = bch(m, d)
          obj.m = m;
          obj.d = d;
          obj.n = 2^m-1;
          obj.t = fix((d-1)/2);
          obj.gen_poly = 1;
      end
      function obj = generator_polynomial(obj)
          % Minimum polynomials of all element of the field
          min_poly = gfminpol([1:2*obj.t]', obj.m);

          % Generator polynomial obtained from lcm of minimal polynomials
          for i = 1:2:(2*obj.t-1)
              obj.gen_poly = gfconv(min_poly(i, :), obj.gen_poly);
          end
          obj.k = obj.n - length(obj.gen_poly) + 1;
      end
      function code_words = encode(obj, messages)
         [s, obj.k] = size(messages);
         % Systematic encoding
         for i = 1:s
           code_words(i, :) = conv(messages(i, :), cat(2, zeros(1, obj.n-obj.k), 1));
           [quo, rem] = gfdeconv(code_words(i,:), obj.gen_poly);
           code_words(i, 1:length(rem))=rem;
         end
      end
      function H = parity_check(obj)
          alpha = gf(2, obj.m);
          H = gf(zeros(2*obj.t, obj.n), obj.m);
          for i = 1:2*obj.t
              for j = 1:obj.n
                  H(i, j) = alpha.^((j-1)*i);
              end
          end
      end
      function S = syndrome(obj, rx, H)
          S = gf(zeros(1, 2*obj.t), obj.m);
          for i = 1:2*obj.t
              ch = H(i,:).*rx(1,:);
              for j = 1:obj.n
                  S(i) = S(i)+ch(j);
              end
          end
      end
      function [rec_corrected, messages] = decode(obj, rec_words)
          H = parity_check(obj);
          [tot_r, r_size] = size(rec_words);
          rec_corrected = rec_words;
          for p = 1:tot_r
              S = syndrome(obj, rec_words(p, :), H);
              sigma = berlekamp_massey(S, obj.t, obj.m);
              beta = roots(sigma);
              j = 1;
              err = zeros(1, obj.t)-1;
              for i = 1:length(beta)
                  if(beta(i) ~= 0)
                      rec_corrected(p, log(beta(i))+1) = rem(rec_words(p, log(beta(i))+1) + 1, 2);
                      err(j) = log(beta(i));
                      j = j + 1;
                  end
              end
              err
          end
          messages = rec_corrected(:, obj.n-obj.k+1:obj.n);
          % Incomplete
      end
   end
end