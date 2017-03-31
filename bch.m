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
              ch = H(i,:).*rx;
              for j = 1:obj.n
                  S(i) = S(i)+ch(j);
              end
          end
      end
      function [rec_corrected, messages, err, status] = decode(obj, rec_words)
          status = 1;
          H = parity_check(obj);
          [tot_r, r_size] = size(rec_words);
          rec_corrected = rec_words;
          for p = 1:tot_r
              S = syndrome(obj, rec_words(p, :), H);
              syndrome_exp = gflog(S);
              syndrome_exp
              sigma = berlekamp_massey(S, obj.t, obj.m);
              beta = roots(sigma);
              j = 1;
              err = zeros(1, obj.t+1)-1;
              for i = 1:length(beta)
                  if(beta(i) ~= 0)
                      rec_corrected(p, log(beta(i))+1) = rem(rec_words(p, log(beta(i))+1) + 1, 2);
                      err(j) = log(beta(i));
                      j = j + 1;
                  end
              end
              syndrome_check = obj.syndrome(rec_corrected,H);
              if(syndrome_check~=0)
                  status = 0;
                  err = zeros(1, obj.t+1)-1;    
                  rec_corrected = zeros(1,obj.n)-1;
                  messages = zeros(1,obj.k)-1;
              else
                  err = err(err~=-1)
              end
          end
          messages = rec_corrected(:, obj.n-obj.k+1:obj.n);
          % Incomplete
      end
      function  [rec_corrected, messages] = decode_with_erasures(obj, rec_words)
          rec_words_with_zero = rec_words;
          if(length(find(rec_words==2))>0)
              rec_words_with_zero(rec_words==2) = 0;
              [rec_corrected_with_zero, mess_zero, err_zero, status_zero] = obj.decode(rec_words_with_zero);
              rec_words_with_one = rec_words;
              rec_words_with_one(rec_words==2) = 1;
              [rec_corrected_with_one, mess_one, err_one, status_one] = obj.decode(rec_words_with_one);
              if(length(err_zero)<length(err_one) & status_zero==1)
                  rec_corrected = rec_corrected_with_zero;
                  rec_corrected
                  messages = mess_zero;
              else if(status_one==1)
                  rec_corrected = rec_corrected_with_one;
                  rec_corrected
                  messages = mess_one;
                  else
                      'Error'
                  end
              end
          else
              [rec_corrected messages err status] = obj.decode(rec_words);
              rec_corrected
              if(status~=1)
                  'Error'
              end
          end
      end
   end
end