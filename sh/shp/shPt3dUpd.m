function shPt3dUpd(h, x)
% Show one point in the 3-D figure.
%
% Input
%   h       -  original figure content handle
%   x       -  point position, 1 x 3
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-03-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

set(h, 'XData', x(1), 'YData', x(2), 'ZData', x(3));
