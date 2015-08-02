function X = genPath(shp, gaps, dx, varargin)
% Generate the curve in 2-D space.
%
% Input
%   shp     -  curve shape, 'l' | 's' | 'o'
%              'l': line
%              's': S
%              'o': circle
%   gaps    -  gap between consecutive frames, 1 x (n - 1)
%   dx      -  offset for 1st frame
%   varargin
%     debg  -  flag of debugging, 'y' | {'n'}
%
% Output
%   X       -  points on the curve, 2 x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-27-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
isDebg = psY(varargin, 'debg', 'n');

% dimension
n = length(gaps) + 1;

% direction
if strcmp(shp, 'l')
    XD = [ones(1, n - 1); ...
          zeros(1, n - 1)];

elseif strcmp(shp, 's')
    x = [0  .2 .4 .50 .8   1];
    y = [0 -.1  0 .15 .3 .25];
    m = 4;
    
    polyfun = polyfit(x, y, m);
    xs = linspace(0, 1, n);
    ys = polyval(polyfun, xs);
    XD = diff([xs; ys], 1, 2);

elseif strcmp(shp, 'o')
    deg = linspace(0, pi * 2, n);
    r = 1;
    X0 = [cos(deg); sin(deg)] * r;
    XD = diff(X0, 1, 2);

else
    error('unknown shape: %s', shp);
end

% normalize
XD = XD ./ repmat(sqrt(sum(XD .^ 2)), 2, 1) .* repmat(gaps, 2, 1);

% gap -> position
XC = cumsum(XD, 2);
x0 = [0; 0];
X = [x0, XC];
X = X + repmat(dx, 1, n);

% debug
if isDebg
    fig = ps(varargin, 'fig', 1);
    rows = 1; cols = 1;
    axs = iniAx(fig, rows, cols, [400 * rows, 400 * cols]);

    set(gcf, 'CurrentAxes', axs{1, 1});
    hold on;
    plot(X(1, :), X(2, :), '-ro');
    axis equal;
end
