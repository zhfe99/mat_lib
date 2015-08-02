function shBoxUpd(h, Box)
% Show bounding box (updating).
%
% Input
%   h       -  original handle
%   Box     -  bounding boxs, dim x 2 x m
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% dimension
m = length(h.hBs);

% main plot
for i = 1 : m
    head = Box(:, 1, i);
    tail = Box(:, 2, i);
    x = [head(2), tail(2), tail(2), head(2), head(2)];
    y = [head(1), head(1), tail(1), tail(1), head(1)];
    set(h.hBs{i}, 'XData', x, 'YData', y);
end
