function [X, Xx, Xy] = ellipseV(me, Var, n)
% Obtain the coordinate of the boundary of 2-D ellipse.
% The shape of ellipse is specified by Variance matrix.
%
% Input
%   me       -  mean, 2 x 1
%   Var      -  variance, 2 x 2
%   n        -  number of points on the boundary
%
% Output
%   X        -  coordinate of the boundary, 2 x n
%   Xx       -  coordinate of ends of radius in x, 2 x 2
%   Xy       -  coordinate of ends of radius in y, 2 x 2
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 07-17-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

[V, D] = eig(Var);
D2 = sqrt(D);
r = diag(D2);
a = atan2(V(2, 1), V(1, 1));

[X, Xx, Xy] = ellipse(me, r, a, n);
