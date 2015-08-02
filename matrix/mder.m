function F = mder(n)
% Obtain the differential operator used for computing derivative.
%
% Input
%   n       -  #sample
%
% Output
%   F       -  1st order differential operator, (n - 1) x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-18-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-16-2013

F = mtril(ones(n), -1) - eye(n);
F(end, :) = [];