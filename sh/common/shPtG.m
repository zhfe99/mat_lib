function h = shPtG(X, G, varargin)
% Show point set with labels.
%
% Input
%   Xs       -  point set, dim x n
%   G        -  class label, k x n
%   varargin
%     show option
%     parMk  -  marker parameter
%     parAx  -  axis parameter
%
% Output
%   h        -  figure handle
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 03-31-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 06-27-2014

% show option
psSh(varargin);

% function option
parMk = ps(varargin, 'parMk', st('lnWid', 0));
parAx = ps(varargin, 'parAx', []);

% dimension
[k, n] = size(G);

% label
if isempty(G)
    G = ones(1, n);
end
l = G2L(G);

% main plot
hold on;
for c = 1 : k
    idx = find(l == c);
    plotmk(X(:, idx), c, parMk);
end

% axis
h.box = xBox(cat(2, X), parAx);
setAx(h.box, parAx);
