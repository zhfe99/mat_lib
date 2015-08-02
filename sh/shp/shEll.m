function shEll(mes, Vars, varargin)
% Show ellipses in 2-D figure.
%
% Input
%   mes      -  mean, 1 x k (cell), 2 x 1
%   Vars     -  variance, 1 x k (cell), 2 x 2
%   varargin
%     show option
%     axis   -  axis flag, {'y'} | 'n'
%     out    -  flag of showing outer boundary, {'y'} | 'n'
%     in     -  flag of showing inner radius , {'y'} | 'n'
%     n      -  number of points on the boundary, {100}
%     lnWid  -  line width, {1}
%     lim0   -  predefined limitation, {[]}
%     num    -  flag of whether ploting number, 'y' | {'n'}
%     sNums  -  string of number, {[]} | 1 x k (cell)
%     lEll   -  ellipse label, {[]} | 1 x k
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 07-17-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
isAxis = psY(varargin, 'axis', 'y');
isOut = psY(varargin, 'out', 'y');
isIn = psY(varargin, 'in', 'y');
n = ps(varargin, 'n', 100);
lnWid = ps(varargin, 'lnWid', 1);
isClass = psY(varargin, 'class', 'y');
lim0 = ps(varargin, 'lim0', []);
isNum = psY(varargin, 'num', 'n');
sNums = ps(varargin, 'sNums', []);
lEll = ps(varargin, 'lEll', []);

% dimension
k = length(mes);
Xs = cell(1, k);

% label
if isempty(lEll)
    lEll = ones(1, k);
end

hold on;

% per class
for c = 1 : k
    % mean & variance
    me = mes{c};
    Var = Vars{c};
    
    % coordinate
    [X, Xx, Xy] = ellipseV(me, Var, n);
    Xs{c} = X;
    
    % marker & color
    if lEll(c) == 0
        cl = [.7 .7 .7];
    else
        [~, cl] = genMkCl(lEll(c));
    end

    if isOut
        plot(X(1, :), X(2, :), '-', 'LineWidth', lnWid, 'Color', cl);
    end

    if isIn
        plot(Xx(1, :), Xx(2, :), '-', 'LineWidth', lnWid, 'Color', cl);
        plot(Xy(1, :), Xy(2, :), '-', 'LineWidth', lnWid, 'Color', cl);
    end

    % show number
    if isNum
        ftSiz = ps(varargin, 'ftSiz', 12);
        tColor = [1 1 1] * 0;
        if isempty(sNums) || isempty(sNums{c})
            sNum = sprintf('%d', c);
        else
            sNum = sNums{c};
        end
        
        text(me(1), me(2), sNum, ...
            'FontSize', ftSiz, 'FontName', 'Time News Roman', 'FontWeight', 'bold', ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
            'Color', tColor);
    end
end
X = mcat('horz', Xs);

% axis boundary
if isAxis
    axis square;
    
    % ax
    parAx = st('mar', [.1 .1]);
    h.box = xBox(X, parAx);
    setAx(h.box, parAx);
end
