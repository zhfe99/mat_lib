function shTable(box, rows, cols, varargin)
% Draw a table.
%
% Input
%   siz     -  figure size
%   rows    -  #rows
%   cols    -  #columns
%   varargin
%     show option
%     lnCl  -  line color, {'k'}
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-02-2012

% show option
psSh(varargin);
lnCl = ps(varargin, 'lnCl', 'k');

% parameter
lineWidth = 1;

hold on;

% horizontal lines
ys = linspace(box(2, 1), box(2, 2), rows + 1);
for r = 1 : rows + 1
    plot(box(1, :), [0 0] + ys(r), '-', 'Color', lnCl, 'LineWidth', lineWidth);
end

% vertical lines
xs = linspace(box(1, 1), box(1, 2), cols + 1);
for c = 1 : cols + 1
    plot([0 0] + xs(c), box(2, :), '-', 'Color', lnCl, 'LineWidth', lineWidth);
end

axis equal;
set(gca, 'xlim', [0, 50], 'ylim', [0, 50]);
set(gca, 'Visible', 'off');
