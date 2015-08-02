function shArrUpd(ha, DI, DJ, varargin)
% Show arrows in 2-D figure (updating).
%
% Input
%   ha       -  handle
%   DI       -  velocity in i axis, h x w
%   DJ       -  velocity in j axis, h x w
%   varargin
%     show option
%     reSca  -  flag of rescaling, 'y' | {'n'}
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 10-05-2010
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
isReSca = psY(varargin, 'reSca', 'n');

% old data
[body, head, dxI, dxJ, xI, xJ, lens, lenMa, sca, isHead, angH, scaH] ...
    = stFld(ha, 'body', 'head', 'dxI', 'dxJ', 'xI', 'xJ', 'lens', 'lenMa', 'sca', 'isHead', 'angH', 'scaH');

% dimension
[h, w] = size(DI);
n = h * w;
na = NaN(n, 1);

% scaling
dI0 = DI(:);
dJ0 = DJ(:);
if isReSca
    lens = sqrt((dI0 / dxJ) .^ 2 + (dI0 / dxJ) .^ 2);
    lenMa = max(lens);
end
dI = dI0 * sca / (lenMa + eps);
dJ = dJ0 * sca / (lenMa + eps);

% arrow body
yI = xI + dI;
yJ = xJ + dJ;
BI = [xI, yI, na]';
BJ = [xJ, yJ, na]';
set(body, 'XData', BJ(:), 'YData', BI(:));

% arrow head
if isHead
    angs = atan2(dI / dxI, dJ / dxJ);
    angHAs = pi / 2 - angs - angH;
    angHBs = pi / 2 - angs + angH;
    hAI = yI - lens * scaH * dxI .* cos(angHAs) / (lenMa + eps);
    hAJ = yJ - lens * scaH * dxJ .* sin(angHAs) / (lenMa + eps);

    hBI = yI - lens * scaH * dxI .* cos(angHBs) / (lenMa + eps);
    hBJ = yJ - lens * scaH * dxJ .* sin(angHBs) / (lenMa + eps);

    HI = [hAI, yI, hBI, na]';
    HJ = [hAJ, yJ, hBJ, na]';
    set(head, 'XData', HJ(:), 'YData', HI(:));
end
