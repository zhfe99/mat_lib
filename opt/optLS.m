function w = optLS(alg, L, b, varargin)
% Linear programming for optimizing || L * w - b ||.
%
% Math
%   min_w | L * w - b |
%   st    w^T 1 = 1
%
% Input
%   alg     -  toolbox name, 'l1' | 'l2_reg'
%   L       -  constraint, (d * m + 1) x nVar
%   b       -  value, d * m + 1
%   varargin
%     th    -  threshold, {0}
%
% Output
%   w       -  solution, nVar x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 10-16-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 12-23-2013

% function option

% dimenson
[nCon, nVar] = size(L);

% matlab    
if strcmp(alg, 'l1')
    
    L = L(1 : end - 1, :);
    b = b(1 : end - 1);
    nCon = nCon - 1;

    f = [zeros(nVar, 1); ones(nCon + nCon, 1)];
    AEq = zeros(nCon + 1, nVar + nCon + nCon);
    for iCon = 1 : nCon
        AEq(iCon, 1 : nVar) = L(iCon, :);
        AEq(iCon, nVar + iCon) = 1;
        AEq(iCon, nVar + nCon + iCon) = -1;
    end
    AEq(end, 1 : nVar) = 1;
    bEq = [b; 1];
    
    lb = zeros(nVar + nCon + nCon, 1);
    lb(1 : nVar) = -inf;
    options = optimset('LargeScale', 'on', 'Display', 'off');
    [res, obj, flag] = linprog(f, [], [], AEq, bEq, lb, [], [], options);
    w = res(1 : nVar);

% l2 with regularization    
elseif strcmp(alg, 'l2_reg')
    th = ps(varargin, 'th', 0);

    L = L(1 : end - 1, :);
    b = b(1 : end - 1);
    H = L' * L + th * eye(nVar);
    f = -L' * b;
    A = [];
    blc = [];
    buc = [];
    AEq = ones(1, nVar);
    bEq = 1;
    blx = [];
    bux = [];
    x0 = [];

    w = optQuad('matlab', H, f, AEq, bEq, A, blc, buc, blx, bux, []);
    
else
    error('unknown algorithm: %s', alg);
end
