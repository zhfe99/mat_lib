function X = ranNor(X0, ran)
% Normalize each dimension spearately with respect to the variance of distance.
%
% Input
%   X0      -  original image, h x w
%   ran     -  range, 2 x 1
%
% Output
%   X       -  new image, h x w
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-02-2013

X = (X0 - ran(1)) / (ran(2) - ran(1) + eps);
