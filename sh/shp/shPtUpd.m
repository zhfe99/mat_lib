function shPtUpd(ha, Pt)
% Show one point in the 2-D figure.
%
% Input
%   ha      -  original figure content handle
%   Pt      -  point position, d x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-03-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 01-24-2014

% dimension
d = size(Pt, 1);

if d == 2
    set(ha.haPt, 'XData', Pt(1, :), 'YData', Pt(2, :));
else
    set(ha.haPt, 'XData', Pt(1, :), 'YData', Pt(2, :), 'ZData', Pt(3, :));
end
