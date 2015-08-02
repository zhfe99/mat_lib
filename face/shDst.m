function h = showDst(wsGeo, iF, varargin)
% Show face landmarks.
%
% Input
%   wsGeo
%     X1     -  position of 1st point set, dim x nP
%     X2     -  position of 2nd point set, dim x nP
%     DstLn  -  the distance line, dim x 2 x nP
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
dstLnWid = ps(varargin, 'dstLnWid', 2);
dstLnCol = ps(varargin, 'dstLnCol', 'b');

% geo
[X1, X2, DstLn] = stFld(wsGeo, 'X1', 'X2', 'DstLn');
X1 = X1(:, :, iF);
X2 = X2(:, :, iF);
DstLn = DstLn(:, :, :, iF);

% dimension
[dim, nP] = size(X1);

% show
if isempty(h0)
    [hX1s, hX2s, hDstLns] = cellss(1, nP);
    for iP = 1 : nP
        if mkSiz > 0
            hX1s{iP} = plot(X1(1, iP), X1(2, iP), mk, 'MarkerSize', mkSiz, 'Color', mkCol);
            hX2s{iP} = plot(X2(1, iP), X2(2, iP), mk, 'MarkerSize', mkSiz, 'Color', mkCol);
        end
        hDstLns{iP} = plot(DstLn(1, :, iP), DstLn(2, :, iP), '-', 'Color', dstLnCol, 'LineWidth', dstLnWid);
    end
    h.hX1s = hX1s;
    h.hX2s = hX2s;
    h.hDstLns = hDstLns;

else
    h = h0;
    
    for iP = 1 : nP
        if ~isempty(h.hX1s{iP});
            set(h.hX1s{iP}, 'XData', X1(1, iP), 'YData', X1(2, iP));
            set(h.hX2s{iP}, 'XData', X2(1, iP), 'YData', X2(2, iP));
        end
        set(h.hDstLns{iP}, 'XData', DstLn(1, :, iP), 'YData', DstLn(2, :, iP));
    end
end
