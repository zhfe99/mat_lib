function clfy = clfyTrLog(XP, XN, par)
% Train a logistic regression.
%
% Model
%   E(Y) = 1 ./ (1+exp(-A*X))
%
% Input
%   XP      -  sample matrix, d x nP
%   XN      -  negative matrix, d x nN
%   par     -  parameter
%     w     -  weights, [] | n x 1
%     ridge -  term, {1e-5}
%              RIDGE can be either a vector with length equal to the number of regressors, or
%              a scalar (the latter being synonymous to a vector with all entries the
%              same).
%     maxiter  -  an iteration limit, {200}
%     verbose  -  whether to print diagnostic information, {0}
%     epsilon  -  used to test convergence, {1e-10}
%     maxprint -  how many regression coefficients to print if VERBOSE == 1, {5}
%
% Output
%   x       -  regression coefficients, m x 1
%
% History
%   create  -  Geoffrey J. Gordon (zhfe99@gmail.com), 06-01-2007
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-16-2012

% parameter
w = ps(par, 'w', []);
ridge = ps(par, 'ridge', 1e-5);
maxiter = ps(par, 'maxiter', 200);
verbose = ps(par, 'verbose', 0);
epsilon = ps(par, 'epsilon', 1e-10);
maxprint = ps(par, 'maxprint', 5);
prIn('clfyTrLog');

% dimension
nP = size(XP, 2);
nN = size(XN, 2);

% augument
XP = [XP; ones(1, nP)];
XN = [XN; ones(1, nN)];

a = [XP, XN]';

y = [ones(nP, 1); zeros(nN, 1)];

% dimension
[n, m] = size(a);

% process parameters
if isempty(w)
    w = ones(n, 1);
end
if length(ridge) == 1
    ridgemat = speye(m) * ridge;
elseif length(ridge(:)) == m
    ridgemat = spdiags(ridge(:), 0, m, m);
else
    error('ridge weight vector should be length 1 or %d', m);
end

% do the regression
x = zeros(m, 1);
oldexpy = -ones(size(y));
for iter = 1 : maxiter
    adjy = a * x;
    expy = 1 ./ (1 + exp(-adjy));
    deriv = expy .* (1 - expy); 
    wadjy = w .* (deriv .* adjy + (y - expy));
    weights = spdiags(deriv .* w, 0, n, n);

    x = inv(a' * weights * a + ridgemat) * a' * wadjy;

    if verbose
        len = min(maxprint, length(x));
        fprintf('%3d: [',iter);
        fprintf(' %g', x(1:len));
        if (len < length(x))
            fprintf(' ... ');
        end
        fprintf(' ]\n');
    end

    if (sum(abs(expy-oldexpy)) < n * epsilon)
        if verbose
            fprintf('Converged.\n');
        end
        break;
    end
    
    oldexpy = expy;
end

% save
clfy.alg = 'log';
clfy.x = x;

prOut;