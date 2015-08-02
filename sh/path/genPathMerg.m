function Xs = genPathMerg(N, gap, r0, XD, varargin)
% Generate the curve in 2-D.
%
% Input
%   N       -  #points, 3 x m
%   gap     -  gap
%   r0      -  radius
%   XD      -  2 x m
%   varargin
%     debg  -  flag of debugging, 'y' | {'n'}
%
% Output
%   Xs      -  points on the curve, 2 x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-27-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 04-21-2013

% function option
isDebg = psY(varargin, 'debg', 'n');

% dimension
m = size(N, 2);

% head
[XHs, XTs, XBs, Xs] = cellss(1, m);
rs = zeros(1, m);
rr = (max(max(N([1 3], :))) - 1) * gap * 1.3;
for i = 1 : m
    % sampling points
    nH = N(1, i);
    nB = N(2, i);
    nT = N(3, i);
    
    % half size
    hf = .5 * (nB - 1) * gap;
%     hf = (max(nH, nT) - 1) * gap;

    % radius
    if i <= floor(m / 2)
        j = i;
        c = 1;
    else
        j = m - i + 1;
        c = -1;
    end
    if j == (m + 1) / 2
        rs(i) = rr * 1e6 / r0;
    else
        rs(i) = rr * j / r0;
    end
    

    % head
    if nH > 0
        ang = (1 : nH) * gap / rs(i);
        ang = ang(end : -1 : 1);
        dx = sin(ang) * rs(i);
        dy = cos(ang) * rs(i);
        XHs{i} = [-hf - dx; ...
                 (rs(i) - dy) * c] + repmat(XD(:, i), 1, nH);
    end

    % body
    XBs{i} = [linspace(-hf, hf, nB); ...
              zeros(1, nB)] + repmat(XD(:, i), 1, nB);

    % tail
    if nT > 0
        ang = (1 : nT) * gap / rs(i);
        dx = sin(ang) * rs(i);
        dy = cos(ang) * rs(i);
        XTs{i} = [hf + dx; ...
                  (rs(i) - dy) * c] + repmat(XD(:, i), 1, nT);
    end

    Xs{i} = [XHs{i}, XBs{i}, XTs{i}];
end

% debug
if isDebg
    fig = ps(varargin, 'fig', 1);
    rows = 1; cols = 1;
    axs = iniAx(fig, rows, cols, [500 * rows, 500 * cols]);
    
    set(gcf, 'CurrentAxes', axs{1, 1});
    hold on;
    for i = 1 : m
        if ~isempty(XHs{i})
            plot(XHs{i}(1, :), XHs{i}(2, :), '-b*');
        end
        plot(XBs{i}(1, :), XBs{i}(2, :), '-ro');
        if ~isempty(XTs{i})
            plot(XTs{i}(1, :), XTs{i}(2, :), '-g+');
        end
    end
    axis equal;
end
