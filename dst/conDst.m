function D = conDst(X1, X2, varargin)
% Compute (squared) distance matrix.
%
% Remark
%   Dij is the squared Euclidean distance between the i-th point in X1 and j-th point in X2.
%   i.e., D(i,j) = || X1(:, i) - X2(:, j) ||_2^2
%
% Usage
%   input   -  X1 = rand(3, 5); X2 = rand(3, 6);
%   call    -  D = conDst(X1, X2);
%
% Input
%   X1      -  1st sample matrix, dim x n1
%   X2      -  2nd sample matrix, dim x n2
%   varargin
%     dst   -  distance type, {'e'} | 'b'
%              'e': Euclidean distance
%              'b': binary distance
%
% Output
%   D       -  squared distance matrix, n1 x n2
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-05-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-01-2013

% function option
dst = ps(varargin, 'dst', 'e');

% dimension
n1 = size(X1, 2);
n2 = size(X2, 2);
if size(X1, 1) == 1
    X1 = [X1; zeros(1, n1)];
    X2 = [X2; zeros(1, n2)];
end
XX1 = sum(X1 .* X1); XX2 = sum(X2 .* X2);

% compute
X12 = X1' * X2;
D = repmat(XX1', [1, n2]) + repmat(XX2, [n1, 1]) - 2 * X12;

% Euclidean distance
if strcmp(dst, 'e')

% binary distance
elseif strcmp(dst, 'b')
    D = real(D > 1e-8);

else
    error(['unknown distance type: ' dst]);
end
