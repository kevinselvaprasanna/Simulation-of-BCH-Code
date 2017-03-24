function [Lambda, B, L] = berlekampmassey( v, Lambda, B, L, r )
%BERLEKAMPMASSEY  Berlekamp-Massey algorithm.
%
%  LAMBDA = BERLEKAMPMASSEY( V ) solves the Newton identity given by V and
%  LAMBDA:
% 
%   [  V(N)   V(N-1)  ...   V(1)  ] [  LAMBDA(2)  ]  = [ -V(N+1)  ]
%   [ V(N+1)   V(N)   ...   V(2)  ] [  LAMBDA(3)  ]  = [ -V(N+2)  ]
%   [   .       .      .     .    ] [      .      ]  = [    .     ]
%   [ V(2N-2) V(2N-1)  ... V(N-1) ] [  LAMBDA(N)  ]  = [ -V(2N-1) ]
%   [ V(2N-1) V(2N-2) ...   V(N)  ] [ LAMBDA(N+1) ]  = [  -V(2N)  ]
%
%  V has a length of 2*N. The returned column vector LAMBDA has N+1
%  elements with the first component set to one, LAMBDA(1) = 1.
%  
%
%  For further details have a look at:
%  Blahut, R.E.: Algebraic methods for signal processing and communications
%  coding, 1992, Springer
%
%
%  Version 1.1
%
%  Copyright 2004 Stefan Nikolaus
%

%
%  [LAMBDA,B,L] = BERLEKAMPMASSEY( V, LAMBDA, B, L ) is only used for
%  internal recursion.
%

n = length(v) / 2;

if( nargin < 2 )
    Lambda = zeros(n+1,1); % one index extra for Lambda_0
    Lambda(1) = 1;
    B = zeros(n+1,1); % one index extra for B_0
    B(1) = 1;
    L = 0;
    r = 1;
elseif( nargin ~= 5 )
    error('Either 1 or 5 input arguments are required.');
end

% inserting zeros at the beginning
temp = zeros(3*n,1); 
temp(n+1:end) = v(:);
Delta = Lambda(1:n+1).'  *  temp( (r+n) : -1 : (r+n)-n );
clear temp;

if( Delta & 2*L <= r-1 )
    delta = 1;
else
    delta = 0;
end

L = delta * ( r - L ) + ( 1 - delta ) * L;

OL = eye(n+1);
OR = eye(n+1) * -Delta;
OR = [zeros(1,n+1); OR(1:end-1,:) ]; %  *x
if( delta )
    UL = eye(n+1) * Delta.^-1;
else
    UL = zeros(n+1);
end
UR = eye(n+1) * (1-delta);
UR = [zeros(1,n+1); UR(1:end-1,:) ]; %  *x

temp = [ OL OR; UL UR ] * [Lambda; B];
Lambda = temp(1:n+1);
B = temp(n+2:end);
clear temp;

if( r < 2*n )
    [Lambda, B, L] = berlekampmassey( v, Lambda, B, L, r+1 );
end