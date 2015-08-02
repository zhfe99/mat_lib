function [Rs, R, s] = tranProLSR(P, Q)
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
%
% Output
%   Rs      -  rotation times scaling, dP x dQ
%   R       -  rotation, dP x dQ
%   s       -  scaling
%           
% History   
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-10-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 08-11-2014

% dimension
[dP, n] = size(P);
dQ = size(Q, 1);

% centralize
BP = P;
BQ = Q;

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
    % tmp2 = trace(ones(n, dQ) * (BQ .^ 2));
    tmp = sum(sum((BQ .^ 2)));
    % equal('tmp', tmp, tmp2);
    s = trace(S) / tmp;
else
    RBQ = R * BQ;
    s = sum(sum(RBQ .* BP)) / sum(sum(RBQ .^ 2));
end

Rs = R * s;
