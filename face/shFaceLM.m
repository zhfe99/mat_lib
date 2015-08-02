function h = shFaceLM(trk, varargin)
% Show face landmarks.
%
% Input
%   trk      -  landmark points, 132 x 1
%   varargin
%     h0     -  initial handle, {[]}
%     part   -  facial part, {'all'}
%     bpart  -  facial part for computing boundary, {'all'}
%               See function indFaceLM for more details
%     mkSiz  -  marker size, {5}
%     mkCol  -  marker color, {'r'}
%     lnWid  -  line width, {1}
%     mk     -  marker, {'.'}
%     rev    -  reverse flag, {'y'} | 'n'
%     vis    -  visible flag, {'y'} | 'n'
%     dyn    -  dynamic boundary flag, {'n'} | 'y'
%     bound  -  boundary flag, {'y'} | 'n'
%     squ    -  square flag, 'y' | {'n'}
%
% Output
%   h        -  figure handle
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 01-04-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 08-22-2013

% show option
psSh(varargin);

% function option
h0 = ps(varargin, 'h0', []);
part = ps(varargin, 'part', 'all');
bpart = ps(varargin, 'bpart', 'all');
mkSiz = ps(varargin, 'mkSiz', 5);
mkCol = ps(varargin, 'mkCol', 'r');
mk = ps(varargin, 'mk', '.');
rev = psY(varargin, 'rev', 'y');
isVis = psY(varargin, 'vis', 'y');
isDyn = psY(varargin, 'dyn', 'n');
box0 = ps(varargin, 'box0', []);
siz0 = ps(varargin, 'siz0', []);
w2h0 = ps(varargin, 'w2h0', []);
h2w0 = ps(varargin, 'h2w0', []);
isBound = psY(varargin, 'bound', 'y');
isSqu = psY(varargin, 'squ', 'n');
lnWid = ps(varargin, 'lnWid', 1);
mar = ps(varargin, 'mar', .1);

if size(trk, 2) == 1
    pts = reshape(trk, [66 2]);
end

% point index
[~, idxCs] = indFaceLM(part);
n = length(idxCs);

Xs = cell(1, n);
for i = 1 : n
    ind = idxCs{i};
    Xs{i} = [pts(ind, 1), pts(ind, 2)]';
end

% draw facial parts
hRegs = ps(h0, 'hRegs', []);
if isempty(hRegs)
    hRegs = cell(1, n);

    hold on;
    for i = 1 : n
        if isVis
            hRegs{i} = plot(Xs{i}(1, :), Xs{i}(2, :), 'Color', mkCol, 'LineWidth', lnWid);
            if mkSiz > 0
                set(hRegs{i}, 'Marker', mk, 'MarkerSize', mkSiz);
            end
        end
    end
    h.hRegs = hRegs;

    %% boundary
    if isBound
        idx = indFaceLM(bpart);
        Yx = trk(idx);
        Yy = trk(idx + 66);
        Y = [Yx'; Yy'];
        cen = mean(Y, 2);

        if isSqu
            siz = max(Y, [], 2) - min(Y, [], 2);

            si = max(siz);
            box0 = [cen - si * .5, cen + si * .5];
        end

        h.cen = cen;
        if ~isempty(box0)
            h.box = setBound(Y, 'mar', mar, varargin{:}, 'box0', box0);
        elseif ~isempty(siz0)
            h.box = setBound(Y, 'mar', mar, varargin{:}, 'siz0', siz0);
        elseif ~isempty(w2h0)
            h.box = setBound(Y, 'mar', mar, varargin{:}, 'w2h0', w2h0);
        elseif ~isempty(h2w0)
            h.box = setBound(Y, 'mar', mar, varargin{:}, 'h2w0', h2w0);
        else
            h.box = setBound(Y, 'mar', mar, varargin{:});
        end
    end

    %% axis direction
    if rev
        set(gca, 'YDir', 'reverse');
    end

else
    for i = 1 : n
        if isVis
            set(hRegs{i}, 'XData', Xs{i}(1, :), 'YData', Xs{i}(2, :));
        end
    end
    h.hRegs = hRegs;

% boundary
    if isDyn && isBound
        idx = indFaceLM(bpart);
        Yx = trk(idx);
        Yy = trk(idx + 66);
        Y = [Yx'; Yy'];
        cen = mean(Y, 2);

        if isSqu
            siz = max(Y, [], 2) - min(Y, [], 2);

            si = max(siz);
            box0 = [cen - si * .5, cen + si * .5];
        end

        h.cen = cen;
        if ~isempty(box0)
            h.box = setBound(Y, 'mar', mar, varargin{:}, 'box0', box0);
        elseif ~isempty(siz0)
            h.box = setBound(Y, 'mar', mar, varargin{:}, 'siz0', siz0);
        elseif ~isempty(w2h0)
            h.box = setBound(Y, 'mar', mar, varargin{:}, 'w2h0', w2h0);
        elseif ~isempty(h2w0)
            h.box = setBound(Y, 'mar', mar, varargin{:}, 'h2w0', h2w0);
        else
            h.box = setBound(Y, 'mar', mar, varargin{:});
        end
    end
end
