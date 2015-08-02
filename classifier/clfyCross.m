function [par, res, Res] = clfyCross(XP, XN, VisP, VisN, pars, varargin)
% Perform cross validation on the given dataset.
%
% Input
%   XP      -  positive sample matrix, d x nP
%   XN      -  positive sample matrix, d x nN
%   VisP    -  binary indicators matrix for positive samples, mFd x nP (binary)
%   VisN    -  binary indicators matrix for negative samples, mFd x nN (binary)
%   pars    -  classification parameter, 1 x mPar (cell)
%   varargin
%
% Output
%   par     -  optimal parameter
%   res     -  result, 1 x mPar
%   Res     -  result of all classification, mFd x mPar
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-05-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 08-28-2012

% dimension
mFd = size(VisP, 1);
mPar = length(pars);
Res = zeros(mFd, mPar);
prIn('clfyCross', 'mFd %d, mPar %d', mFd, mPar);

% only one parameter, no need cross validation
if mPar == 1
    par = pars{1};
    res = 0;
    prOut;
    return;
end

% per parameters
prCIn('par', mPar, 1);
for iPar = 1 : mPar
    prC(iPar);

    % select parameter
    par = pars{iPar};
    
    % disable probability
    par = stAdd(par, 'pb', 'n', 'ap', 'n');

    % per fold
    for iFd = 1 : mFd
        % select samples
        XTrP = XP(:, VisP(iFd, :));
        XTrN = XN(:, VisN(iFd, :));
        XTeP = XP(:, ~VisP(iFd, :));
        XTeN = XN(:, ~VisN(iFd, :));

        % train
        clfy = clfyTr(XTrP, XTrN, par);

        % test
        [lP, lN] = clfyTe(XTeP, XTeN, clfy);
        
        % response
        resP = mean((lP - 1) .^ 2);
        resN = mean((lN - 0) .^ 2);
        res = (resP + resN) / 2;

        % store
        Res(iFd, iPar) = res;
        
        pr('res %f, resP %f, resN %f', res, resP, resN);
    end
end
prCOut(mPar);

% result
res = sum(Res) / mFd;

% pick the best parameter
[resOpt, idx] = min(res);
par = pars{idx};

if strcmp(par.alg, 'cksvc') || strcmp(par.alg, 'rsvr') || strcmp(par.alg, 'svr')
    pr('best par, c %f', par.c);
else
    pr('best par, res %f, c %f, epi %f, g %f', resOpt, par.c, par.epi, par.g);
end

prOut;
