function i = randInt(n)
% Randomly pick one integer in (1 : n).
%
% Input
%   n       -  number of sampling times
%
% Output
%   i       -  integer
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-04-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-26-2013

i = round(rand(1) * (n - 1)) + 1;