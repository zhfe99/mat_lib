function shMFrac(M, denom, varargin)
% Show 2-D matrix.
%
% Input
%   M       -  2-D matrix, n1 x n2
%   varargin
%     show option
%     bar   -  bar flag, 'y' | {'n'}
%     seg   -  segmentation parameter, []
%     num   -  number flag, 'y' | {'n'}
%     numM  -  number matrix, {[]}. if numM is [], then numM = M;
%     form  -  form of showing number, {'%d'}
%     C     -  correspondence matrix, {[]}
%     tick  -  flag of showing x and y ticks, {'y'} | 'n'
%     lnWid   -  line width, {1}
%     lnCl  -  line color, {'r'} | 'y'
%     ftSiz -  font size, {12}
%     eq    -  equal flag, 'y' | 'n'
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
isBar = psY(varargin, 'bar', 'n');
seg = ps(varargin, 'seg', []);
isNum = psY(varargin, 'num', 'n');
numM = ps(varargin, 'numM', []);
form = ps(varargin, 'form', '%d');
C = ps(varargin, 'C', []);
isTick = psY(varargin, 'tick', 'y');
lnWid = ps(varargin, 'lnWid', 1);
lnCl = ps(varargin, 'lnCl', 'r');
ftSiz = ps(varargin, 'ftSiz', 12);
isEq = psY(varargin, 'eq', 'n');

% matrix
M2 = M;
M2(M == 1) = 1.8;
imagesc(M2);
colormap(gray);

% boundary
n1 = size(M, 1); n2 = size(M, 2);

if isEq
    axis equal;
else
    axis square;
end
axis([1 - .5, n2 + .5, 1 - .5, n1 + .5]);
axis ij;
hold on;
set(gca, 'ticklength', [0 0]);

if isBar, colorbar; end

% boundary of segment
if ~isempty(seg)
    st = seg.st;
    m = length(st) - 1;
    n = size(M, 1);
    hold on;
    for i = 2 : m
        line([st(i) st(i)] - .5, [0 n] + .5, 'Color', [.5 .5 1], 'LineWidth', 1);
        line([0 n] + .5, [st(i) st(i)] - .5, 'Color', [.5 .5 1], 'LineWidth', 1); 
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
                tColor = [1 1 1] * 1 - p * c;
                if c == 0
                end
            else
                c = 1 - c;
                tColor = [1 1 1] * p * c;
            end
%             fprintf('%d %d %d %d %d\n', i, j, tColor(1), tColor(2), tColor(3));
            if tColor(1) < 1
                tColor = [0 0 0];
            end

            if numM(i, j) == 0
                s = '0';
                ftSiz2 = ftSiz;
            else
                s = sprintf('$\\frac{%d}{%d}$', numM(i, j), denom);
                ftSiz2 = ftSiz + 4;
                
            end
%             disp(s);
            text(j + 0, i, s, ...
                'FontSize', ftSiz2, 'FontWeight', 'bold', ...
                'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                'Color', tColor, 'Interpreter', 'latex', 'FontName', 'Arial');
        end
    end
end

% x and y ticks
if ~isTick
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
end
