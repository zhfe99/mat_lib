function h = showDstLn(wsGeo, iF, varargin)
% Show face landmarks.
%
% Input
%   wsGeo
%     X      -  the point, dim x nP
%     Y      -  the point on the line, dim x nS x nP
%     Z      -  the closest point, dim x nP
%     DstLn  -  the distance line, dim x 2 x nP
%     Ln     -  the line, dim x 2 x nP
%   iF       -  frame index
%   varargin
%     h0     -  initial handle, {[]}
%     part   -  specific facial part, {[]}. See function indFaceLM for more details
%     mkSiz  -  marker size, {5}
%     mkCol  -  marker color, {'r'}
%     lnWid  -  line width, {1}
%     mk     -  marker, {'.'}
%     rev    -  reverse flag, {'y'} | 'n'
%     vis    -  visible flag, {'y'} | 'n'
%     dyn    -  dynamic boundary flag, {'n'} | 'y'
%     bound  -  boundary flag, {'y'} | 'n'
%     bpart  -  {'all'}
%     squ    -  square flag, 'y' | {'n'}
%
% Output
%   h        -  figure handle
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 01-04-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% parse option
psShow(varargin);
h0 = ps(varargin, 'h0', []);
mkSiz = ps(varargin, 'mkSiz', 5);
mkCol = ps(varargin, 'mkCol', 'r');
mk = ps(varargin, 'mk', 'o');
lnWid = ps(varargin, 'lnWid', 1);
dstLnWid = ps(varargin, 'dstLnWid', 2);
dstLnCol = ps(varargin, 'dstLnCol', 'b');

% geo
[X, Y, Z, DstLn, Ln] = stFld(wsGeo, 'X', 'Y', 'Z', 'DstLn', 'Ln');
X = X(:, :, iF);
Y = Y(:, :, :, iF);
Z = Z(:, :, iF);
DstLn = DstLn(:, :, :, iF);
Ln = Ln(:, :, :, iF);

% dimension
[dim, nS, nP] = size(Y);

% show
if isempty(h0)
    [hXs, hY1s, hY2s, hZs, hLns, hDstLns] = cellss(1, nP);
    for iP = 1 : nP
        if mkSiz > 0
            hXs{iP} = plot(X(1, iP), X(2, iP), mk, 'MarkerSize', mkSiz, 'Color', mkCol);
            hY1s{iP} = plot(Y(1, 1, iP), Y(2, 1, iP), mk, 'MarkerSize', mkSiz, 'Color', mkCol);
            hY2s{iP} = plot(Y(1, 2, iP), Y(2, 2, iP), mk, 'MarkerSize', mkSiz, 'Color', mkCol);
            hZs{iP} = plot(Z(1, iP), Z(2, iP), mk, 'MarkerSize', mkSiz, 'Color', mkCol);
        end
        hLns{iP} = plot(Ln(1, :, iP), Ln(2, :, iP), '--', 'Color', mkCol, 'LineWidth', lnWid);
        hDstLns{iP} = plot(DstLn(1, :, iP), DstLn(2, :, iP), '-', 'Color', dstLnCol, 'LineWidth', dstLnWid);
    end
    h.hXs = hXs;
    h.hY1s = hY1s;
    h.hY2s = hY2s;
    h.hZs = hZs;
    h.hLns = hLns;
    h.hDstLns = hDstLns;

else
    h = h0;
    
    for iP = 1 : nP
        if ~isempty(h.hXs{iP});
            set(h.hXs{iP}, 'XData', X(1, iP), 'YData', X(2, iP));
            set(h.hY1s{iP}, 'XData', Y(1, 1, iP), 'YData', Y(2, 1, iP));
            set(h.hY2s{iP}, 'XData', Y(1, 2, iP), 'YData', Y(2, 2, iP));
            set(h.hZs{iP}, 'XData', Z(1, iP), 'YData', Z(2, iP));
        end
        set(h.hLns{iP}, 'XData', Ln(1, :, iP), 'YData', Ln(2, :, iP));
        set(h.hDstLns{iP}, 'XData', DstLn(1, :, iP), 'YData', DstLn(2, :, iP));
    end
    
end
