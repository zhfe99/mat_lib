function [tran, PP] = tranProLS(P, Q)
% L2 Procrustes analysis for matching two sets of points.
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
%
% Output
%   tran    -  optimal transformation
%   PP      -  new 2nd points set, dP x n
%           
% History   
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-10-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 02-17-2014

% dimension
[dP, n] = size(P);
dQ = size(Q, 1);
prIn('tranProLS', 'dP %d, dQ %d, n %d', dP, dQ, n);

% centralize
[BP, bP] = cenP(P);
[BQ, bQ] = cenP(Q);

% balanced 
if dP == dQ
    Tmp = BP * BQ';

% unbalanced
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
b = bP - s * R * bQ;

% apply transformation
PP = s * R * Q + repmat(b, 1, n);

% store
tran = st('s', s, 'R', R, 'b', b);
tran.R = s * R;

prOut;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [BP, bp] = cenP(P)
% Centralize point set.
%
% Input
%   P   -  1st point set, d x n
%
% Output
%   BP  -  new points set, d x n
%   bp  -  mean, d x 1

% dimension
n = size(P, 2);

bp = sum(P, 2) / n;
BP = P - repmat(bp, 1, n);