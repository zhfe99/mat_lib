function clfy = svmTr(X, G, par)
% Train a SVM classifier from the given data set.
%
% Input
%   X       -  sample matrix, d x n
%   G       -  label matrix, k x n
%   par
%     alg   -  algorithm, {'svr'} | 'svc' | 'ksvr'
%     c     -  value of C
%     epi   -  value of epislon
%     pb    -  flag of using probability output, 'y' | {'n'}
%     ap    -  flag of using approximated model, 'y' | {'n'}
%
% Output
%   clfy    -  classifier model
%     alg   -  algorithm
%     svm   -  svm model
%     ti    -  time cost
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-05-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-26-2014

% function option
alg = ps(par, 'alg', 'svr');
isPb = psY(par, 'pb', 'n');
isAp = psY(par, 'ap', 'n');

% dimension
[k, n] = size(G);

% label
l = G2L(G);

% SVR
hT = tic;
if strcmp(alg, 'svr')
    str = sprintf('-s 3 -t 0 -c %f -p %f -q', par.c, par.epi);
    pr('svr, %s', alg, str);

    % train
    svm = svmtrain(l', X', str);

    ti = toc(hT);
    pr('#SV %d, time %.2f secs', length(svm.sv_coef), ti);

% SVC
elseif strcmp(alg, 'svc')
    str = sprintf('-s 0 -t 0 -c %f -p %f -q', par.c, par.epi);
    pr('svc, %s', str);

    % train
    svm = svmtrain(l', X', str);
    ti = toc(hT);

else
    error('unknown, alg %s', alg);
end

% store
clfy.alg = alg;
clfy.svm = svm;
clfy.ti = ti;
clfy.isPb = isPb;
clfy.isAp = isAp;
