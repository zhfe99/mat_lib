function shMs(Ms, varargin)
% Show matrix.
%
% Input
%   M        -  matrix, k1 x k2 x m1 x m2
%   varargin
%     show option
%     bar    -  bar flag, 'y' | {'n'}
%     seg    -  segmentation, []
%     num    -  number flag, 'y' | {'n'}
%     numM   -  number matrix, {[]}. if numM is [], then numM = M;
%     form   -  number display form, {'%d'}
%     ftSiz  -  font size, {12}
%     C      -  correspondence matrix, {[]}
%     tick   -  flag of showing x and y ticks, {'y'} | 'n'
%     lnWid  -  line width, {1}
%     bdWid  -  line width (for boundary), {1}
%     bdCl   -  line color (for boundary), {'r'} | 'y'
%     eq     -  axis equal flag, 'y' | {'n'}
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
psShow(varargin);
isBar = psY(varargin, 'bar', 'n');
seg = ps(varargin, 'seg', []);
isNum = psY(varargin, 'num', 'n');
numM = ps(varargin, 'numM', []);
form = ps(varargin, 'form', '%d');
ftSiz = ps(varargin, 'ftSiz', 12);
C = ps(varargin, 'C', []);
isTick = psY(varargin, 'tick', 'y');
lnWid = ps(varargin, 'lnWid', 1);
bdWid = ps(varargin, 'bdWid', 1);
bdCl = ps(varargin, 'bdCl', [.5 .5 1]);
lnCl = ps(varargin, 'lnCl', 'r');
isEq = psY(varargin, 'eq', 'n');

% matrix
[k1, k2, m1, m2] = size(Ms);
n1 = k1 * m1;
n2 = k2 * m2;
M = zeros(n1, n2);
s1 = n2s(ones(1, m1) * k1);
s2 = n2s(ones(1, m2) * k2);
for i1 = 1 : m1
    idx1 = s1(i1) : s1(i1 + 1) - 1;
    for i2 = 1 : m2
        idx2 = s2(i2) : s2(i2 + 1) - 1;
        M(idx1, idx2) = Ms(:, :, i1, i2);
    end
end

imagesc(M);
colormap(gray);

% axis
if isEq
    axis equal;
else
    axis square;
end
axis([1 - .5, n2 + .5, 1 - .5, n1 + .5]);
axis ij;
hold on;
set(gca, 'ticklength', [0 0]);

% color bar
if isBar
    colorbar;
end

% segmentation boundary
seg.s = s1;
if ~isempty(seg) && bdWid > 0
    s = seg.s;
    m = length(s) - 1;
    n = size(M, 1);
    hold on;
    for i = 2 : m
        line([s(i) s(i)] - .5, [0 n] + .5, 'Color', bdCl, 'LineWidth', bdWid);
        line([0 n] + .5, [s(i) s(i)] - .5, 'Color', bdCl, 'LineWidth', bdWid); 
    end
end

% correspondence (path)
if ~isempty(C)
    plot(C(2, :), C(1, :), '-', 'Color', lnCl, 'LineWidth', lnWid);
end

% show number
if isNum
    if isempty(numM)
        numM = M;
    end

    [n1, n2] = size(M);
    ma = max(max(M));
    mi = min(min(M));
    colorMap = (M - mi) / (ma - mi);
    for i = 1 : n1
        for j = 1 : n2
            c = colorMap(i, j); p = .7;
            if c < .5
                tColor = [1 1 1] * .95 - p * c;
                if c == 0
                end
            else
                c = 1 - c;
                tColor = [1 1 1] * p * c;
            end

            text(j + 0, i, vec2str(numM(i, j), form), 'HorizontalAlignment', 'center', ...
                'FontSize', ftSiz, 'FontName', 'Time News Roman', 'FontWeight', 'bold', ...
                'Color', tColor);
        end
    end
end

% x and y ticks
if ~isTick
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);    
end
