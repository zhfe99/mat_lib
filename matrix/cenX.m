function [X, me] = cenX(X0, dire)
% Centerize the sample matrix.
%
% Input
%   X0      -  original sample matrix, dim x n
%   dire    -  column-wise or row-wise sample arrangement in matrix, {1} | 0
%                1: column-wise arrangment, X0(:, i) is i-th sample
%                2: row-wise arrangment, X0(i, :) is i-th sample
%
% Output
%   X       -  new sample matrix, dim x n
%   me      -  mean, dim x 1 (if dire == 1) or 1 x n (if dire == 2)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-19-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-22-2014

% default dire
if ~exist('dire', 'var')
    dire = 1;
end

if dire == 2
    X0 = X0';
end

n = size(X0, 2);
me = sum(X0, 2) / n;
X = X0 - repmat(me, 1, n);

if dire == 2
    me = me';
    X = X';
end
