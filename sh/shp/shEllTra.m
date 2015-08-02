function shEllTra(mess, Varss, varargin)
% Show ellipses trajectory in 2-D figure.
%
% Input
%   mess     -  mean, 1 x nF (cell), 1 x k_t (cell), 2 x 1
%   Varss    -  variance, 1 x nF (cell), 1 x k_t (cell), 2 x 2
%   varargin
%     show option
%     axis   -  axis flag, {'y'} | 'n'
%     out    -  flag of showing outer boundary, {'y'} | 'n'
%     in     -  flag of showing inner radius , {'y'} | 'n'
%     n      -  #points on the boundary of ellipse, {100}
%     lnWid  -  line width, {1}
%     class  -  flag of show class as color, {'y'} | 'n'
%     lim0   -  predefined limitation, {[]}
%     num    -  number flag, 'y' | {'n'}
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

% dimension
nF = length(mess);
ks = cellDim(mess, 2);
Xs = cell(1, nF);

% per class
hold on;
for iF = 1 : nF
    Xis = cell(1, ks(iF));
    for c = 1 : ks(iF)
        % mean & variance
        me = mess{iF}{c};
        Var = Varss{iF}{c};
        
        % shape of ellipse
        [X, Xx, Xy] = ellipseV(me, Var, n);
        Xis{c} = X;
        
        if isClass
            [~, cl] = genMkCl(c);
        else
            [~, cl] = genMkCl(1);
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
            text(me(1), me(2), sprintf('%d', c), ...
                 'FontSize', ftSiz, 'FontName', 'Time News Roman', 'FontWeight', 'bold', ...
                 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                 'Color', tColor);
        end
    end   
    Xs{iF} = mcat('horz', Xis);
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
