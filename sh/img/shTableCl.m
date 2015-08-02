function shTableCl(M, box, rows, cols, CMap, varargin)
% Draw table with colors.
%
% Input
%   M       -  matrix, m x n
%   rows    -  #rows
%   cols    -  #columns
%   CMap    -  color map, nc x 3
%   varargin
%     show option
%     lnCl  -  line color, {'k'}
%     axis  -  flag of set axis, {'y'} | 'n'
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 03-18-2013

% show option
psSh(varargin);
lnCl = ps(varargin, 'lnCl', 'k');
isAxis = psY(varargin, 'axis', 'y');
xlim = ps(varargin, 'xlim', [0 30]);
ylim = ps(varargin, 'ylim', [0 30]);

% parameter
lineWidth = 1;

hold on;

% dimension
[m, n] = size(M);
nc = size(CMap, 1);

% per element
hold on;
for i = 1 : m
    for j = 1 : n
        pos0 = [j - 1 + box(1, 1), m - i + 1 + box(2, 1)];
        v = M(i, j);
        
        if v == 0
            continue;
        end
        
        xs = pos0(1) + [0, 0, 1, 1, 0];
        ys = pos0(2) + [0, -1, -1, 0, 0];
        
        idxCl = round((1 - v) * nc);
        idxCl = max(idxCl, 1);
        idxCl = min(idxCl, nc);
        
        ha = fill(xs, ys, CMap(idxCl, :));
        set(ha, 'EdgeColor', 'none');
    end
end

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

if isAxis
    axis equal;
    set(gca, 'xlim', xlim, 'ylim', ylim);
    set(gca, 'Visible', 'off');
end
