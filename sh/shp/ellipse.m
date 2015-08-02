function [X, Xx, Xy] = ellipse(me, r, a, n)
% Obtain the coordinate of the boundary of 2-D ellipse.
%
% Input
%   me       -  mean, 2 x 1
%   r        -  radius, 2 x 1
%   a        -  angle of rotation
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

rx = r(1);
ry = r(2);
R = [cos(a), -sin(a); sin(a), cos(a)];

% outer boundary
angs = linspace(0, pi * 2, n);
Ang = [cos(angs) * rx; sin(angs) * ry];
X = R * Ang + repmat(me, 1, n);

% inner radius
angs = [0, pi, pi / 2, pi * 1.5];
Ang = [cos(angs) * rx; sin(angs) * ry];
Xx = R * Ang(:, 1 : 2) + repmat(me, 1, 2);
Xy = R * Ang(:, 3 : 4) + repmat(me, 1, 2);
