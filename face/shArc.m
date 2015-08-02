function h = shArc(wsGeo, iF, varargin)
% Show face landmarks.
%
% Input
%   wsGeo
%     Z      -  the closest point, dim x nP
%     X      -  the point, dim x nP
%     Y      -  the point on the line, dim x nS x nP
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
arcLnWid = ps(varargin, 'arcLnWid', 2);
arcLnCol = ps(varargin, 'arcLnCol', 'b');

% geo
[X, Arc, Bd] = stFld(wsGeo, 'X', 'Arc', 'Bd');
X = X(:, :, :, iF);
Arc = Arc(:, :, :, iF);
Bd = Bd(:, :, :, iF);

% dimension
[dim, nS, nP] = size(X);

% show
if isempty(h0)
    [hX1s, hX2s, hX3s, hBds, hArcs] = cellss(1, nP);
    for iP = 1 : nP
        if mkSiz > 0
            hX1s{iP} = plot(X(1, 1, iP), X(2, 1, iP), mk, 'MarkerSize', mkSiz, 'Color', mkCol);
            hX2s{iP} = plot(X(1, 2, iP), X(2, 2, iP), mk, 'MarkerSize', mkSiz, 'Color', mkCol);
            hX3s{iP} = plot(X(1, 3, iP), X(2, 3, iP), mk, 'MarkerSize', mkSiz, 'Color', mkCol);
        end
        hBds{iP} = plot(Bd(1, :, iP), Bd(2, :, iP), '--', 'Color', mkCol, 'LineWidth', lnWid);
        hArcs{iP} = plot(Arc(1, :, iP), Arc(2, :, iP), '-', 'Color', arcLnCol, 'LineWidth', arcLnWid);
    end
    h.hX1s = hX1s;
    h.hX2s = hX2s;
    h.hX3s = hX3s;
    h.hBds = hBds;
    h.hArcs = hArcs;

else
    h = h0;
    for iP = 1 : nP
        if ~isempty(h.hX1s{iP});
            set(h.hX1s{iP}, 'XData', X(1, 1, iP), 'YData', X(2, 1, iP));
            set(h.hX2s{iP}, 'XData', X(1, 2, iP), 'YData', X(2, 2, iP));
            set(h.hX3s{iP}, 'XData', X(1, 3, iP), 'YData', X(2, 3, iP));
        end
        set(h.hBds{iP}, 'XData', Bd(1, :, iP), 'YData', Bd(2, :, iP));
        set(h.hArcs{iP}, 'XData', Arc(1, :, iP), 'YData', Arc(2, :, iP));
    end
end
