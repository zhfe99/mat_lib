function x = optLP(lpTool, f, AEq, bEq, AIn, bIn, blx, bux, AEqK, bEqK)
% Solving linear programming using LP solvers.
%
% Math
%   minimize     f' * x
%   subject to   AEq * x = bEq
%                AIn * x <= bIn
%                blx <= x <= bux
%
% Input
%   alg     -  LP solver, 'matlab' | 'mosek'
%   f       -  d x 1
%   AEq     -  eqivalent constraint, cEq x d
%   bEq     -  eqivalent constraint, cEq x 1
%   AIn     -  ineqivalent constraint, cIn x d
%   bIn     -  ineqivalent constraint, cIn x 1
%   blx     -  lower bound of x, d x 1
%   bux     -  upper bound of x, d x 1
%
% Output
%   x       -  solution, d x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 10-16-2010
%   modify  -  Feng Zhou (zhfe99@gmail.com), 02-23-2014

% matlab
if strcmp(lpTool, 'matlab')
    options = optimset('LargeScale', 'on', 'Display', 'off', 'Simplex', []);
    % hTi = tic;
    x = linprog2(f, AIn, bIn, AEq, bEq, blx, bux, [], options);
    % t1 = toc(hTi);

    % hTi = tic;
    % x = linprog2(f, AIn, bIn, AEq, bEq, blx, bux, [], options);
    % t2 = toc(hTi);
    % fprintf('t1 %.2f, t2 %.2f\n', t1, t2);
    % equal('obj', x' * f, x2' * f);

% lpsolve
elseif strcmp(lpTool, 'lpsolve')
    flags = zeros(length(bEq), 1);
    lp = lp_maker(f, AEq, bEq, flags, blx, [], [], [], []);
    hTi = tic;
    solvestat = mxlpsolve('solve', lp);
    obj = mxlpsolve('get_objective', lp);
    x = mxlpsolve('get_variables', lp);
    mxlpsolve('delete_lp', lp);
    t1 = toc(hTi);
    
    hTi = tic;
    options = optimset('LargeScale', 'on', 'Display', 'off');
    x2 = linprog(f, AIn, bIn, AEq, bEq, blx, bux, [], options);
    t2 = toc(hTi);
    fprintf('t1 %.2f, t2 %.2f\n', t1, t2);
    equal('obj', x' * f, x2' * f);

% mosek
elseif strcmp(lpTool, 'mosek')
    if isempty(AEq)
        blc = [];
        buc = bIn;
    else
        if isempty(AIn)
            AIn = AEq;
            blc = bEq;
            buc = bEq;
        else
            AIn0 = AIn;
            AIn = [AIn0; AEq];
            blc = [-inf(size(AIn0, 1), 1); bEq];
            buc = [bIn; bEq];
        end
    end
    
    parMsk = struct('MSK_IPAR_LOG', 0, ...
                    'MSK_IPAR_LOG_INTPNT', 0, ...
                    'MSK_IPAR_LOG_SIM', 0, ...
                    'MSK_IPAR_LOG_BI', 0, ...
                    'MSK_IPAR_LOG_PRESOLVE', 0);
    cmd = 'minimize info echo(0) statuskeys(1) symbcon';
    res = msklpopt(f, AIn, blc, buc, blx, bux, parMsk, cmd);
    x = res.sol.itr.xx;

% cvx
elseif strcmp(lpTool, 'cvx')
    if ~isempty(AIn)
        error('unsupported');
    end
    
    d = length(f);
    idx = find(blx == 0);
    AIn = -eye(d);
    AIn = AIn(idx, :);
    bIn = zeros(length(idx), 1);

    cvx_begin
        variable x(d)
        minimize(f' * x)
        subject to
          AEq * x == bEq;
          AIn * x <= 0;
          norm(AEqK * x, 1) == bEqK;
    cvx_end
    
    %% check with matlab
    % options = optimset('LargeScale', 'on', 'Display', 'off');
    % x2 = linprog(f, AIn, bIn, AEq, bEq, [], [], [], options);
    % obj = f' * x;
    % obj2 = f' * x2;

else
    error('unknown LP toolbox: %s\n', lpTool);
end

% testing
% obj2 = sum(sum(C .* X * lam));
% for i = 1 : m
%     obj2 = obj2 + sum(sum(XPs{i} + XNs{i}, 2) .* weis(:));
% end
% equal('obj', obj, obj2);
