function ha = shMNum(M, varargin)
% Show matrix with number.
%
% Input
%   M        -  matrix, n1 x n2
%   varargin
%     show option
%     dis    -  display type, {'imagesc'} | 'contour'
%     clMap  -  color map, {'gray'}
%     bar    -  bar flag, 'y' | {'n'}
%     eq     -  axis equal flag, 'y' | {'n'}
%     P      -  warping path, {[]}
%     lnWid  -  line width, {1}
%     lnCl   -  line color (for boundary), {'r'}
%     numM   -  number matrix, {M}
%     form   -  number display form, {'%d'}
%     ftSiz  -  font size, {12}
%
% Output
%   ha       -  figure handle
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-29-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 01-24-2013

% show option
psSh(varargin);

% function option
dis = ps(varargin, 'dis', 'imagesc');
clMap = ps(varargin, 'clMap', 'gray');
isBar = psY(varargin, 'bar', 'n');
isEq = psY(varargin, 'eq', 'y');
isSq = psY(varargin, 'sq', 'n');
P = ps(varargin, 'P', []);
Ps = ps(varargin, 'Ps', []);
lnMk = ps(varargin, 'lnMk', '-');
lnWid = ps(varargin, 'lnWid', 1);
lnCl = ps(varargin, 'lnCl', 'r');
numM = ps(varargin, 'numM', M);
form = ps(varargin, 'form', '%d');
ftSiz = ps(varargin, 'ftSiz', 12);
cmap = ps(varargin, 'cmap', []);
clim = ps(varargin, 'clim', []);

% matrix
[n1, n2] = size(M);
if strcmp(dis, 'imagesc')
    if strcmp(clMap, 'grayc')
        M = repmat(M, [1 1 3]);
    end

    if isempty(clim)
        ha.M = imagesc(M);
    else
        ha.M = imagesc(M, clim);
    end
elseif strcmp(dis, 'contour')
    ha.M = contour(M);
else
    error(['unknown display type: ' dis]);
end

% color map
if ~isempty(cmap)
    ha.cmap = colormap(cmap);
elseif strcmp(clMap, 'gray')
    ha.cmap = colormap(gray);
elseif strcmp(clMap, 'grayc')
    ha.cmap = colormap('jet');
elseif strcmp(clMap, 'hsv')
    ha.cmap = colormap(hsv);
elseif strcmp(clMap, 'jet')
    ha.cmap = colormap(jet);
else
    error('unknown color map: %s', clMap);
end

% axis
if isEq
    axis equal;
end
if isSq
    axis square;
end
axis([1 - .5, n2 + .5, 1 - .5, n1 + .5]);
axis ij;
hold on;
set(gca, 'ticklength', [0 0]);
%set(gca, 'XTick', 1 : n2, 'YTick', 1 : n1);

% color bar
if isBar
    colorbar;
end

% warping path
if ~isempty(P)
    plot(P(:, 2), P(:, 1), lnMk, 'Color', lnCl, 'LineWidth', lnWid);
end
if ~isempty(Ps)
    for i = 1 : length(Ps)
        P = Ps{i};
        plot(P(:, 2), P(:, 1), '--', 'Color', 'g', 'LineWidth', lnWid);
    end    
end

% number

if strcmp(form, '%d')
    M = round(M);
end

[n1, n2] = size(M);
ma = max(max(M));
mi = min(min(M));

% color of background
colorMap = (M - mi) / ((ma - mi) + eps);

% per element
for i = 1 : n1
    for j = 1 : n2
% color of font
        c = colorMap(i, j); 
        p = .7;
        if c < .5
            tColor = [1 1 1] * .95 - p * c;
        elseif c > .5
            tColor = [1 1 1] * p * (1 - c);
        else
            tColor = [1 1 1] * .2 * .5;
        end

        text(j, i, vec2str(numM(i, j), form), 'HorizontalAlignment', 'center', ...
             'FontSize', ftSiz, 'FontName', 'Time News Roman', 'FontWeight', 'bold', ...
             'Color', tColor);
    end
end
