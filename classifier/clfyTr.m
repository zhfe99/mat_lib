function clfy = clfyTr(XP, XN, par)
% Train a classifier from the given data set.
%
% Input
%   XP      -  sample matrix, d x nP
%   XN      -  negative matrix, d x nN
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
nP = size(XP, 2);
nN = size(XN, 2);

% data
X = [XP, XN];
X = double(X);

% label
l = [ones(1, nP), zeros(1, nN)];
hT = tic;

% SVR
if strcmp(alg, 'svr')
    % prepare for LIBSVM
    str = sprintf('-s 3 -t 0 -c %f -p %f -q', par.c, par.epi);
    pr('train, %s, nP %d, nN %d, %s', alg, nP, nN, str);

    % train
    svm = mySvmtrain(l', X', str);

    ti = toc(hT);
    pr('#SV %d, time %.2f secs', length(svm.sv_coef), ti);
    
% RootSIFT SVR
elseif strcmp(alg, 'rsvr')
    % normalize
    X = norX2(X, 'l1');
    X = real(sqrt(X));

    % prepare for LIBSVM
    str = sprintf('-s 3 -t 0 -c %f -p %f -q', par.c, par.epi);
    pr('train, %s, nP %d, nN %d, %s', alg, nP, nN, str);

    % train
    svm = mySvmtrain(l', X', str);

    ti = toc(hT);
    pr('#SV %d, time %.2f secs', length(svm.sv_coef), ti);

% SVR (RBF kernel)
elseif strcmp(alg, 'ksvr')
    % prepare for LIBSVM
    str = sprintf('-s 3 -t 2 -c %f -p %f -q -g %e', par.c, par.epi, 2 ^ par.g);
    pr('train, %s, nP %d, nN %d, g %f, %s', alg, nP, nN, par.g, str);

%     sig = real(sqrt(1 / (2 ^ par.g * 2)));
%      D = conDst(X, X);
%      K = conKnl(D, 'g', 'man', 'nei', sig);
%     shM(D, 'fig', [1 1 2 1]);
%     shM(K, 'fig', [1 1 2 2]);

    % train
    svm = mySvmtrain(l', X', str);

    ti = toc(hT);
    pr('#SV %d, time %.2f secs', length(svm.sv_coef), ti);
    
% SVR (root SIFT + RBF kernel)
elseif strcmp(alg, 'rksvr')
    % normalize
    X = norX2(X, 'l1');
    X = real(sqrt(X));
    
    % prepare for LIBSVM
    str = sprintf('-s 3 -t 2 -c %f -p %f -q -g %e', par.c, par.epi, 2 ^ par.g);
    pr('train, %s, nP %d, nN %d, g %f, %s', alg, nP, nN, par.g, str);

    % train
    svm = mySvmtrain(l', X', str);

    ti = toc(hT);
    pr('#SV %d, time %.2f secs', length(svm.sv_coef), ti);
    
% SVR (root SIFT2 + RBF kernel)
elseif strcmp(alg, 'r2ksvr')
    % normalize
    X = norX2(X, 'l12');
    X = real(sqrt(X));
    
    % prepare for LIBSVM
    str = sprintf('-s 3 -t 2 -c %f -p %f -q -g %e', par.c, par.epi, 2 ^ par.g);
    pr('train, %s, nP %d, nN %d, g %f, %s', alg, nP, nN, par.g, str);

    % train
    svm = mySvmtrain(l', X', str);

    ti = toc(hT);
    pr('#SV %d, time %.2f secs', length(svm.sv_coef), ti);

% SVR (Chi-squared kernel)
elseif strcmp(alg, 'cksvr')
    
    % prepare for LIBSVM
    str = sprintf('-s 3 -t 5 -c %f -p %f -q -g %e', par.c, par.epi, 2 ^ par.g);
    pr('train, %s, nP %d, nN %d, g %f, %s', alg, nP, nN, par.g, str);

%     sig = real(sqrt(1 / (2 ^ par.g * 2)));
%     D = conDstChi(X, X, 'norm', 'n');
%     sigma = bandG(D, nei);
%     K = conKnl(D, 'g', 'man', 'nei', sig);
%     shM(D, 'fig', [1 1 2 1]);
%     shM(K, 'fig', [1 1 2 2]);

    % train
    svm = mySvmtrain(l', X', str);

    ti = toc(hT);
    pr('#SV %d, time %.2f secs', length(svm.sv_coef), ti);
    
% SVR (normalized Chi-squared kernel)
elseif strcmp(alg, 'ncksvr')
    % normalize
    X = norX2(X, 'l12');
    
    % prepare for LIBSVM
    str = sprintf('-s 3 -t 5 -c %f -p %f -q -g %e', par.c, par.epi, 2 ^ par.g);
    pr('train, %s, nP %d, nN %d, g %f, %s', alg, nP, nN, par.g, str);

    % train
    svm = mySvmtrain(l', X', str);

    ti = toc(hT);
    pr('#SV %d, time %.2f secs', length(svm.sv_coef), ti);
    
% Chi-square kernel SVC
elseif strcmp(alg, 'cksvc')
    % normalize
    X = norX2(X, 'l1');

    % prepare for LIBSVM
    str = sprintf('-s 0 -t 6 -c %f -q', par.c);
    if isPb
        str = [str ' -b 1'];
    end
    pr('train, cksvc, nP %d, nN %d, %s', nP, nN, str);

    % train
    svm = svmtrain2(l', X', str);
    ti = toc(hT);
    pr('#SV %d, time %.2f secs', length(svm.sv_coef), ti);
    
    % compute the approximated model
    if isAp
        param = st('NSAMPLE', 100, 'BINARY', 1);
        hT = tic;
        svmA = compute_approx_model(svm, param);
        ti = toc(hT);
        pr('approx model, %.2f secs', ti);
        clfy.svmA = svmA;
    end

% SVC
elseif strcmp(alg, 'svc')
    % prepare for LIBSVM
    str = sprintf('-s 0 -t 0 -c %f -p %f -q', par.c, par.epi);
    pr('svc, %s', str);

    % train
    svm = mySvmtrain(l', X', str);
    ti = toc(hT);

% liblinear
elseif strcmp(alg, 'svcf')
    % prepare for LIBSVM
    str = sprintf('-c %f', par.c);
    pr('svcf, %s', str);

    % train
    XS = sparse(X);
    svm = train(l', XS', str);

% PEGASOS
elseif strcmp(alg, 'pega')
    % prepare for vl_feat
    l = int8(l);
    lam = 0.01;
    pr('pegasos, lam %f', lam);

    % train
    w = vl_pegasos(X, l, lam, 'NumIterations', 1e5);

    % store
    svm.alg = alg;
    svm.w = w;

else
    error('unknown, alg %s', alg);
end

% store
clfy.alg = alg;
clfy.svm = svm;
clfy.ti = ti;
clfy.isPb = isPb;
clfy.isAp = isAp;
