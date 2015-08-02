function Ax = iniAxIn(Ax0, pos, varargin)
% Create axes in axes.
%
% Input
%   fig      -  figure number
%   Ax       -  parent axes, rows x cols (cell)
%   pos      -  position of the axes in the figure, {[0 0 1 1]}
%   varargin
%
% Output
%   Ax       -  new axes, rows x cols (cell)
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 01-01-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 06-15-2013

% dimension
[rows, cols] = size(Ax0);

% create axes
Ax = cell(rows, cols);
for row = 1 : rows
    for col = 1 : cols
        pos0 = get(Ax0{row, col}, 'Position');

        pos1 = zeros(1, 4);
        pos1(1) = pos0(1) + pos0(3) * pos(1);
        pos1(2) = pos0(2) + pos0(4) * pos(2);
        pos1(3) = pos0(3) * pos(3);
        pos1(4) = pos0(4) * pos(4);

        Ax{row, col} = axes('Position', pos1);
    end
end
