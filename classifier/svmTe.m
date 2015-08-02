function wsTe = svmTe(X, GT, clfy)
% Classify the given data set.
%
% Input
%   X       -  sample matrix, d x n
%   GT      -  ground-truth label, k x n
%   clfy    -  classifier model
%     alg   -  classifier algorithm, 'svm' | 'svr' | 'log'
%     svm   -  svm model
%
% Output
%   wsTe
%     ti    -  time
%     G     -  label, k x n
%     Dec   -  decision, k x n
%     accs  -  accuracy, 1 x k
%     l     -  label, 1 x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-05-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-27-2014

% function option
alg = clfy.alg;

% dimension
n = size(X, 2);
X = double(X);

% ground-truth label
lT = G2L(GT);

% SVR
hTi = tic;
if strcmp(alg, 'svr')
    svm = clfy.svm;

    % fast computation
%     ti = tic;
    coefs = svm.sv_coef;
    SVs = svm.SVs;
    rho = svm.rho;
    lNew = coefs' * SVs * X - rho;

    % test
%     [lNew, acc, dec] = svmpredict(lT', X', svm);
%     lNew = lNew';
%     fprintf('lib: %.2f\n', toc(ti));
%     fprintf('dif: %f\n', max(abs(l2 - lNew)));

% SVC
elseif strcmp(alg, 'svc')
    svm = clfy.svm;

    % fast
    % coefs = svm.sv_coef;
    % SVs = svm.SVs;
    % rho = svm.rho;
    % lNew = coefs' * SVs * X - rho;
    
    % slow
    [lNew, acc, dec] = svmpredict(lT', X', svm);

else
    error('unknown, alg %s', alg);
end

% label
G = L2G(lNew);

% result
% res = mean((lT - lNew) .^ 2);

% store
wsTe.ti = toc(hTi);
wsTe.G = G;
wsTe.l = lNew';
wsTe.accs = acc';
wsTe.Dec = dec';
