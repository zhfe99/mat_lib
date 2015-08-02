function ha = shArr(XI, XJ, DI, DJ, varargin)
% Show arrows in 2-D.
%
% Input
%   XI       -  center position in i axis, h x w
%   XJ       -  center position in j axis, h x w
%   DI       -  velocity in i axis, h x w
%   DJ       -  velocity in j axis, h x w
%   varargin
%     show option
%     cl     -  color of arrow body and head, {'b'}
%     lnWid  -  line width of arrow body and head, {1}
%     sca    -  scale of arrow body, {1}
%     head   -  flag of plotting arrow head, {'y'} | 'n'
%     angH   -  direction of arrow head, {15}
%     scaH   -  scale of arrow head, {.1}
%
% Output
%   ha       -  handle
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 10-05-2010
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
cl = ps(varargin, 'cl', 'b');
lnWid = ps(varargin, 'lnWid', 1);
sca = ps(varargin, 'sca', 1);
isHead = psY(varargin, 'head', 'n');
angH = ps(varargin, 'angH', 15); angH = angH * pi / 180;
scaH = ps(varargin, 'scaH', .3);

% dimension
[h, w] = size(XI);
n = h * w;
na = NaN(n, 1);

% scaling
xI = XI(:);
xJ = XJ(:);
dxI = (max(xI) - min(xI)) / h;
dxJ = (max(xJ) - min(xJ)) / w;

dI0 = DI(:);
dJ0 = DJ(:);
lens = sqrt((dI0 / dxI) .^ 2 + (dJ0 / dxJ) .^ 2);
lenMa = max(lens);
dI = dI0 * sca / (lenMa + eps);
dJ = dJ0 * sca / (lenMa + eps);

% arrow body
yI = xI + dI;
yJ = xJ + dJ;
BI = [xI, yI, na]';
BJ = [xJ, yJ, na]';
hold on;
ha.body = plot(BJ(:), BI(:), '-', 'Color', cl, 'LineWidth', lnWid);

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
    ha.head = plot(HJ(:), HI(:), '-', 'Color', cl, 'LineWidth', lnWid);
else
    ha.head = [];
end

% store
ha.dxI = dxI;
ha.dxJ = dxJ;
ha.xI = xI;
ha.xJ = xJ;
ha.lens = lens;
ha.lenMa = lenMa;
ha.sca = sca;
ha.isHead = isHead;
ha.angH = angH;
ha.scaH = scaH;
