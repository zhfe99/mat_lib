function [G, Y] = cluScOut(K0, k, mi)
% Spectral clustering with outlier detection.
%
% Input
%   K0      -  kernel matrix, n x n
%   k       -  cluster number
%   mi      -  minimal size of the cluster
%
% Output
%   G       -  indicator matrix, k x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 08-12-2014
%   modify  -  Feng Zhou (zhfe99@gmail.com), 08-13-2014

% function option
nItMa = 100;

% dimension
n = size(K0, 1);
G = zeros(k, n);

% index of inliers and outliers
idxIn = 1 : n;
idxOut = [];

nIt = 0;
K = K0;
for nIt = 1 : nItMa
    Gi = cluSc(K, k);

    % check the small cluster
    cos = sum(Gi, 2);
    idxC = find(cos < mi);
    
    % stop condition
    if isempty(idxC)
        G(:, idxIn) = Gi;
        break;
    end
    
    % update the index
    is = find(sum(Gi(idxC, :), 1));
    idxOut = [idxOut, idxIn(is)];
    idxIn(is) = [];

    % update the kernel
    K = K0(idxIn, idxIn);
end

if nIt == nItMa
    error('cannot find solution');
end
