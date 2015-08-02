function ran = ranUpd(ranA, ranB)
% Obtain the range of a matrix.
%
% Input
%   X       -  matrix
%
% Output
%   ran     -  range, [min max]
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-19-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-01-2013

ran = [min(ranA(1), ranB(1)), max(ranA(2), ranB(2))];