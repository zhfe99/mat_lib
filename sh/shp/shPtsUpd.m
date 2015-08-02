function shPtsUpd(h, X)
% Update multiple points in the 2-D figure.
%
% Input
%   h       -  original figure content handle
%   x       -  point position, 1 x 2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-03-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

set(h, 'XData', X(1, :), 'YData', X(2, :));
