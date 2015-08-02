function [lP, lN, res] = clfyTe(XP, XN, clfy)
% Classify the given data set and report the result.
%
% Input
%   XP      -  sample matrix, d x nP
%   XN      -  negative matrix, d x nN
%   clfy    -  classifier model
%     alg   -  classifier algorithm, 'svm' | 'svr' | 'log'
%     svm   -  svm model
%
% Output
%   lP      -  label of positive samples, 1 x nP
%   lN      -  label of negative samples, 1 x nN
%   res     -  result
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-05-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-26-2014

% function option
alg = clfy.alg;

% dimension
nP = size(XP, 2);
nN = size(XN, 2);

% data
X = [XP, XN];
X = double(X);

% label
lT = [ones(1, nP), zeros(1, nN)];

hT = tic;

% SVR
if strcmp(alg, 'svr')
    svm = clfy.svm;

    % fast computation
%     ti = tic;
    coefs = svm.sv_coef;
    SVs = svm.SVs;
    rho = svm.rho;
    lNew = coefs' * SVs * X - rho;

    % test
%     ti = tic;
%     [lNew, acc, dec] = mySvmpredict(lT', X', svm);
%     lNew = lNew';
%     fprintf('lib: %.2f\n', toc(ti));
%     fprintf('dif: %f\n', max(abs(l2 - lNew)));
    
% RootSIFT + SVR
elseif strcmp(alg, 'rsvr')
    
    pr('test, %s, nP %d, nN %d', alg, nP, nN);
    
    % normalize
    X = norX2(X, 'l1');
    X = real(sqrt(X));    

    % svm
    svm = clfy.svm;

    % fast computation
    coefs = svm.sv_coef;
    SVs = svm.SVs;
    rho = svm.rho;
    lNew = coefs' * SVs * X - rho;
    
    ti = toc(hT);
    pr('time %.2f secs', ti);    

% SVR (RBF kernel)
elseif strcmp(alg, 'ksvr')
    svm = clfy.svm;
    
    pr('test, ksvr, nP %d, nN %d', nP, nN);    

%    fprintf('#SV %d, #sample %d \n', length(svm.sv_coef), size(X, 2));
%     svm.totalSV = 1000;
%     svm.sv_coef = svm.sv_coef(1 : 1000);
%     svm.SVs = svm.SVs(1 : 1000, :);

    % fast computation by block matrix computation
%     ti = tic;
     coefs = svm.sv_coef;
     SVs = svm.SVs;
     rho = svm.rho;  
     sig = svm.Parameters(4);
     lNew2 = conRBF(X, SVs', coefs', sig, 'len', 4000) - rho;
     lNew = lNew2';
%     fprintf('my: %.2f\n', toc(ti));

     ti = toc(hT);
     pr('time %.2f secs', ti);

    % test
%      ti = tic;
%      [lNew, acc, dec] = mySvmpredict(lT', X', svm);
%      lNew = lNew';
%      fprintf('clfyTe ksvr: %.2f\n', toc(ti));
%      fprintf('dif: %f\n', max(abs(lNew2 - lNew)));
%     return;
     
% SVR (root SIFT + RBF kernel)
elseif strcmp(alg, 'rksvr')
    % normalize
    X = norX2(X, 'l1');
    X = real(sqrt(X));
    
    svm = clfy.svm;

    pr('test, %s, nP %d, nN %d, #SV %d', alg, nP, nN, length(svm.sv_coef));

    % fast computation by block matrix computation
     coefs = svm.sv_coef;
     SVs = svm.SVs;
     rho = svm.rho;  
     sig = svm.Parameters(4);
     lNew2 = conRBFRoot(X, SVs', coefs', sig, 'len', 4000) - rho;
     lNew = lNew2';

     ti = toc(hT);
     pr('time %.2f secs', ti);
     
%      hT = tic;
%      lNew3 = conRBFRoot(X, SVs', coefs', sig, 'len', 4000) - rho;
%      lNew3 = lNew3';
%      equal('lNew', lNew, lNew3);
%      ti = toc(hT);
%      pr('time2 %.2f secs', ti);

% SVR (root SIFT2 + RBF kernel)
elseif strcmp(alg, 'r2ksvr')
    % normalize
    X = norX2(X, 'l12');
    X = real(sqrt(X));
    
    svm = clfy.svm;
    pr('test, %s, nP %d, nN %d', alg, nP, nN);

    % fast computation by block matrix computation
     coefs = svm.sv_coef;
     SVs = svm.SVs;
     rho = svm.rho;  
     sig = svm.Parameters(4);
     lNew2 = conRBFRoot(X, SVs', coefs', sig, 'len', 4000) - rho;
     lNew = lNew2';

     ti = toc(hT);
     pr('time %.2f secs', ti);
     
     
% SVR (Chi-squared kernel)
elseif strcmp(alg, 'cksvr')
    % normalize
%    X = norX2(X, 'l1');

    svm = clfy.svm;
    
    pr('test, cksvr, nP %d, nN %d', nP, nN);    

    % fast computation by block matrix computation
    [lNew, acc, dec] = mySvmpredict(lT', X', svm);
    lNew = lNew';

     ti = toc(hT);
     pr('time %.2f secs', ti);
     
% SVR (l1 normalized chi-squared kernel)
elseif strcmp(alg, 'ncksvr')
    % normalize
    X = norX2(X, 'l12');

    svm = clfy.svm;
    pr('test, %s, nP %d, nN %d', alg, nP, nN);

    % fast computation by block matrix computation
    [lNew, acc, dec] = mySvmpredict(lT', X', svm);
    lNew = lNew';

    ti = toc(hT);
    pr('time %.2f secs', ti);

% Chi-squared kernel SVC
elseif strcmp(alg, 'cksvc')
    X = norX2(X, 'l1');

    isPb = clfy.isPb;
    isAp = clfy.isAp;
    pr('test, cksvc, nP %d, nN %d', nP, nN);    

    % approximate model
    if isAp
        svmA = clfy.svmA;
        if isPb
            d = svmpredict_approx(X', svmA, 1);
            lNew = d(:, 1)';
        else
            d = svmpredict_approx(X', svmA);
            lNew = d';
        end
        ti = toc(hT);
%        err = mean(abs(d - dec));
        err = 0;
        pr('PWLApprox, time %.2f secs, err %f', ti, err);

    % LIBSVM        
    else
        svm = clfy.svm;
        if isPb
            [lNew, acc, dec] = svmpredict2(lT', X', svm, '-b 1');
            lNew = lNew';
        else
            [lNew, acc, dec] = svmpredict2(lT', X', svm);
            lNew = lNew';
        end
        ti = toc(hT);
        pr('LIBSVM, time %.2f secs, acc %f', ti, acc(1));
    end

% SVC
elseif strcmp(alg, 'svc')
    svm = clfy.svm;

    coefs = svm.sv_coef;
    SVs = svm.SVs;
    rho = svm.rho;
    lNew = coefs' * SVs * X - rho;

% logistic 
elseif strcmp(alg, 'log')
    x = clfy.x;

    n = size(X, 2);
    X1 = [X; ones(1, n)];
    lNew = 1 ./ (1 + exp(-x' * X1));

else
    error('unknown, alg %s', alg);
end

% label
lP = lNew(1 : nP);
lN = lNew(nP + 1 : end);

% result
res = mean((lT - lNew) .^ 2);
