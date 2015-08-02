function ha = shGphTra(Pts, Egs, varargin)
% Show graph trajectory in 2-D space.
%
% Remark
%   The dimension of feature, d, has to be 2.
%   To plot points with d > 2, you could call function pca in advance, e.g.,
%      X = pca(X, st('d', 2))
%
% Input
%   Pts      -  graph node, 1 x nF (cell), 2 x k_t
%   Egs      -  graph edge, 1 x nF (cell), 2 x l_t
%   varargin
%     show option
%     parMk  -  marker parameter, {[]}, see function plotmk for more details
%     parAx  -  axis parameter, {[]}, see function setAx for more details
%
% Output
%   ha       -  figure handle
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 08-11-2011
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
parMk = ps(varargin, 'parMk', []);
parAx = ps(varargin, 'parAx', []);

% dimension
[d, k] = size(Pt);
l = size(Eg, 2);
if d ~= 2
    error('unsupported dimension: %d', d);
end

% default marker parameter
if isempty(parMk)
    parMk = st('mkSiz', 5, 'lnWid', 0);
end

% default axis parameter
if isempty(parAx)
    parAx = st('eq', 'y');
end

% plot node
hold on;
ha.pt = plotmk(Pt, 1, parMk);

% plot edge
X = [Pt(1, Eg(1, :)); Pt(1, Eg(2, :)); nan(1, l)];
Y = [Pt(2, Eg(1, :)); Pt(2, Eg(2, :)); nan(1, l)];
ha.eg = plot(X(:), Y(:), '-r');

% axis
ha.box = xBox(Pt, parAx);
setAx(ha.box, parAx);
