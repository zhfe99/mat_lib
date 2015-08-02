function [xs, ys] = imgPtFit(x0s, y0s, siz)
% Adjust the figure size to fit with the maximum size constraint but keeping the ratio.
%
% Input
%   x0s     -  point x position, 1 x n
%   y0s     -  point x position, 1 x n
%   siz     -  new size, 1 x 2
%
% Output
%   xs      -  point x position, 1 x n
%   ys      -  point y position, 1 x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-24-2013
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-09-2013

h = siz(1);
w = siz(2);

xs = max(1, x0s);
xs = min(w, xs);
ys = max(1, y0s);
ys = min(h, ys);