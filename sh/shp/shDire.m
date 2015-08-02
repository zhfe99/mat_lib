function shDire(Dire, cen, varargin)
% Show direction in the figure.
%
% Input
%   Dire     -  direction matrix, dim x n
%   cen      -  center vector, dim x 1
%   varargin
%     show option
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 03-16-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

[~, n] = size(Dire);

hold on;
for i = 1 : n
    dire = Dire(:, i) * 10;
    
    line([0, dire(1)] + cen(1), [0, dire(2)] + cen(2));
end
