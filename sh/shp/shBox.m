function h = shBox(Box, varargin)
% Show bounding box.
%
% Input
%   Box     -  bounding boxs, dim x 2 x m
%   varargin
%     show option
%     col    -  box boundary color, {'r'}
%     mk     -  box boundary marker, {'-'}
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
cl = ps(varargin, 'cl', 'r');
mk = ps(varargin, 'mk', '-');
lnWid = ps(varargin, 'lnWid', 1);

% dimension
m = size(Box, 3);

% main plot
hold on;
hBs = cell(1, m);
for i = 1 : m
    head = Box(:, 1, i);
    tail = Box(:, 2, i);
    x = [head(2), tail(2), tail(2), head(2), head(2)];
    y = [head(1), head(1), tail(1), tail(1), head(1)];
    hBs{i} = plot(x, y, mk, 'Color', cl, 'LineWidth', lnWid);
end

% store
h.hBs = hBs;
