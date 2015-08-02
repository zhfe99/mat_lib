function [tran, PP, nIt, obj, E, L, nItIns] = tranProL1(P, Q, tran0, maIn, maOut, rho, muMa, tol)
% L1 Procrustes analysis.
%
% Original Problem
%   min  ||R Q + b 1' - P||_1
%   s.t. R' * R = I
%
% Relaxed Problem via augumented Lagrange multiplier
%   min  ||E - P||_1 + tr(L' * (R Q + b 1' - E)) + .5 * mu ||R Q + b 1' - E ||_F^2
%   s.t. R' * R = I
%
% Input
%   P       -  2D data matrix, dP x k
%   Q       -  3D data matrix, dQ x k
%   tran0   -  initial transformation
%   maIn    -  maximum #iteration of inner loop, 100 | ...
%   maOut   -  maximum #iteration of outer loop, 500 | ...
%   rho     -  increasing ratio of the penalty parameter mu, 1.05 | ...
%   mu      -  mu, 1e20 | ...
%   tol     -  tolerance, 1e-8 | ...
%
% Output
%   tran
%     R     -  rotation, dP x dQ
%     b     -  translation, dP x 1
%   PP      -  transformed point, dP x k
%   nIt     -  #iteration
%   obj     -  L1-norm error
%   E       -  E variable, dP x k
%   L       -  Lagrange multiplier, dP x k
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 12-13-2013
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-09-2014

% function option
tol = tol * norm(P, 'fro');
prIn('tranProL1');

% dimension
[dQ, k] = size(Q);
dP = size(P, 1);

% initial variable
[E, L] = zeross(dP, k);
mu = 1e-6;
mu1 = 1 / mu;

% outer loop
objs = []; 
nIt = 0;
nItIns = zeros(1, maOut);
prCIn('outer', maOut, 50);
for nItOut = 1 : maOut
    prC(nItOut);

    % inner loop for tran and E
    obj0 = 1e20;
    for nItIn = 1 : maIn
        nIt = nIt + 1;

        % update R and b
        temp = E + L / mu;
        [tran, Q2] = tranProLS(temp, Q);

        % update E
        temp1 = Q2 - L / mu;
        temp = P - temp1;
        E = max(0, temp - 1 / mu) + min(0, temp + 1 / mu);
        E = P - E;

        % evaluate current objective
        obj = sum(sum(abs(P - E))) + sum(sum(L .* (E - Q2))) + mu / 2 * norm(E - Q2, 'fro') ^ 2;

        % stop condition for inner loop
        if abs(obj - obj0) <= 1e-8 * abs(obj0)
            break;
        end

        obj0 = obj;
    end
    nItIns(nItOut) = nItIn;

    %% difference
    Dif = E - Q2;
    stopC = norm(Dif, 'fro');

    %% obj
    obj = sum(sum(abs(P - Q2)));
    objs = [objs, obj];

    % if nItOut == 1 || mod(nItOut, 50) == 0
    %     pr('nItOut %d, mu %2.1e, obj %.2f, diff %2.3e', nItOut, mu, obj, stopC);
    % end

    %% stop condition
    if stopC < tol
        break;
    end
    
    %% update Lagrange multiplier
    L = L + mu * Dif;

    %% update penalty parameter
    mu = min(muMa, mu * rho);
end
prCOut(nItOut);
nItIns(nItOut + 1 : end) = [];

% error
PP = Q2;

prOut;
