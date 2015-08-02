function [tran, PP] = tranProLSG(P, Q, G)
% Procrustes analysis for matching two sets of points.
%
% Remark
%   This function can handle both 
%        the balanced (eg, 3D to 3D or 2D to 2D)
%    and the unbalanced (eg, 3D to 2D) problems.
%
% Math
%   min  || s R Q + b 1' - P ||_F^2
%   s.t. R' * R = I
%
% Input
%   P       -  1st point set, dP x n
%   Q       -  2nd point set, dQ x n
%   G       -  group label, k x n
%
% Output
%   tran    -  optimal transformation
%   PP      -  new 2nd points set, dP x n
%           
% History   
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-10-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 02-08-2014

% dimension
[dP, n] = size(P);
dQ = size(Q, 1);
k = size(G, 1);
prIn('tranProLSG', 'dP %d, dQ %d, n %d, k %d', dP, dQ, n, k);

% centralize
[BP, bP] = cenP(P, G);
[BQ, bQ] = cenP(Q, G);

% balanced case
if dP == dQ
    Tmp = BP * BQ';

% unbalanced case
else
    Tmp = BP * BQ' / (BQ * BQ');
end
[U, S, V] = svd(Tmp, 'econ');

% optimal rotation
R = U * V';

% optimal scale
if dP == dQ
    tmp = trace(ones(n, dQ) * (BQ .^ 2));
    s = trace(S) / tmp;
else
    RBQ = R * BQ;
    s = sum(sum(RBQ .* BP)) / sum(sum(RBQ .^ 2));
end

% optimal translation
bs = cell(1, k);
for c = 1 : k
    idx = find(G(c, :));
    nc = length(idx);

    bs{c} = bP(:, c) - s * R * bQ(:, c);
end

% apply transformation
PP = s * R * Q + repmat(b, 1, n);

% store
tran = st('s', s, 'R', R, 'b', b);
tran.R = s * R;

prOut;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [BP, B] = cenP(P, G)
% Centralize point set.
%
% Input
%   P   -  original point set, d x n
%   G   -  group label, k x n
%
% Output
%   BP  -  new points set, d x n
%   B   -  mean, d x k


% dimension
d = size(P0, 1);
[k, n] = size(G);

B = zeros(d, k);
BP = zeross(d, n);
for c = 1 : k
    idx = find(G(c, :));
    nc = length(idx);

    B(:, c) = sum(P(:, idx), 2) / nc;
    
    BP(:, idx) = P(:, idx) - repmat(B(:, c), 1, nc);
end
