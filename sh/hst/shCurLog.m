function shCurLog(Me, Dev, varargin)
% Plot curves in log in 2-D.
%
% Input
%   Me        -  mean, k x n
%   Dev       -  deviation, k x n
%   varargin
%     show option
%     algs    -  algorithm names, {[]}
%     xs      -  x axis value, {[]}
%     cs      -  class of algorithm, {[]}
%     lnWid   -  line width, {1}
%     lns     -  line markers, {[]}
%     mkSiz   -  size of markers, {5}
%     mkEg    -  flag of marker edge, 'y' | {'n'}
%     dev     -  dev flag, {'y'} | 'n'
%     devWid  -  width of deviation line in terms of the 'barWid', {1} <= 1
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 01-15-2010
%   modify    -  Feng Zhou (zhfe99@gmail.com), 05-14-2015

% show option
psSh(varargin);

% function option
algs = ps(varargin, 'algs', []);
xs = ps(varargin, 'xs', []);
cs = ps(varargin, 'cs', []);
lnWid = ps(varargin, 'lnWid', 1);
mkSiz = ps(varargin, 'mkSiz', 5);
isMkEg = psY(varargin, 'mkEg', 'n');
isDev = psY(varargin, 'dev', 'y');
devWid = ps(varargin, 'devWid', .1);
plFun = ps(varargin, 'plFun', 'plot');
plFun2 = ps(varargin, 'plFun2', 'plot');

% dimension
[k, n] = size(Me);

% width
devWid = devWid * 1;

% x position
if isempty(xs)
    xs = 1 : n;
end

% cs
if isempty(cs)
    cs = 1 : k;
end

% plot deviation
dx = diff(xs);
wid2 = dx(1);
if isDev && ~isempty(Dev)
    cls = ps([], 'cls', {[1 0 0], [0 0 1], [0 1 0], [1 0 1], [0 0 0], [1 .5 0], [.7 .7 .7], [.1 .1 .1], [.4 .4 .7], [.1 .1 .1], [1 .8 0], [1, .4, .6]});
    dx = diff(xs);
    wid2 = dx(1) / 2;
    
    for c = 1 : k
        % color
        [~, cl] = genMkCl(c);
        for i = 1 : n
            xi = xs(i);
            mei = Me(c, i);
            dei = Dev(c, i);
            
            if strcmp(plFun2, 'plot')
                plot([xi(i) xi(i)], [-de(i) de(i)] + me(i), '-', 'Color', cl, 'LineWidth', lnWid);
                plot([-wid2, wid2] * varWid + xi(i),  [1 1] * de(i) + me(i), '-', 'Color', cl, 'LineWidth', lnWid);
                plot([-wid2, wid2] * varWid + xi(i), -[1 1] * de(i) + me(i), '-', 'Color', cl, 'LineWidth', lnWid);
                
            elseif strcmp(plFun2, 'loglog')
                loglog([xi(i) xi(i)], [-de(i) de(i)] + me(i), '-', 'Color', cl, 'LineWidth', lnWid);
                loglog([-wid2, wid2] * varWid + xi(i),  [1 1] * de(i) + me(i), '-', 'Color', cl, 'LineWidth', lnWid);
                loglog([-wid2, wid2] * varWid + xi(i), -[1 1] * de(i) + me(i), '-', 'Color', cl, 'LineWidth', lnWid);
                
            elseif strcmp(plFun2, 'semilogx')
                semilogx([xi(i) xi(i)], [-de(i) de(i)] + me(i), '-', 'Color', cl, 'LineWidth', lnWid);
                semilogx([-wid2, wid2] * varWid + xi(i),  [1 1] * de(i) + me(i), '-', 'Color', cl, 'LineWidth', lnWid);
                semilogx([-wid2, wid2] * varWid + xi(i), -[1 1] * de(i) + me(i), '-', 'Color', cl, 'LineWidth', lnWid);
                
            elseif strcmp(plFun2, 'semilogy')
                semilogy([xi xi], [-dei dei] + mei, '-', 'Color', cl, 'LineWidth', lnWid);
                semilogy([-wid2, wid2] * devWid + xi,  [1 1] * dei + mei, '-', 'Color', cl, 'LineWidth', lnWid);
                semilogy([-wid2, wid2] * devWid + xi, -[1 1] * dei + mei, '-', 'Color', cl, 'LineWidth', lnWid);
            end
        end
    end
end

% plot mean
mes = cell(1, k);
for c = 1 : k
    mes = Me(c, :);

    if strcmp(plFun, 'plot')
        hTmp = loglog(xs, mes, '-', 'LineWidth', lnWid);
    elseif strcmp(plFun, 'loglog')
        hTmp = loglog(xs, mes, '-', 'LineWidth', lnWid);
    elseif strcmp(plFun, 'semilogx')
        hTmp = semilogx(xs, mes, '-', 'LineWidth', lnWid);
    elseif strcmp(plFun, 'semilogy')
        hTmp = semilogy(xs, mes, '-', 'LineWidth', lnWid);
    else
        error('unknown plot fun: %s', plFun);
    end

    % color
    [mk, cl] = genMkCl(c);
    set(hTmp, 'Color', cl);
    if mkSiz > 0
        set(hTmp, 'Marker', mk, 'MarkerSize', mkSiz, 'MarkerFaceColor', cl);
        if isMkEg
            set(hTmp, 'MarkerEdgeColor', 'k');
        end
    end
    
    if c == 1
        hold on;
    end
end

% legend
if ~isempty(algs)
    legend(algs{:});
end
%return;
