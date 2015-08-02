function siz = figSizBest(siz0, rows, cols, sizMa)
% Adjust the figure size to fit with the maximum width constraint.
%
% Input
%   siz0    -  original size, 1 x 2
%   sizMa   -  maximum size, 1 x 2
%
% Output
%   siz     -  new size, 1 x 2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-24-2013
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-06-2013

siz0 = siz0([1 2]) .* [rows, cols];
siz = figSizFit(siz0, sizMa);