function [VisP, VisN] = clfyFd(nP, nN, mFd)
% Partition the data set into parts used for training and testing respectively.
%
% Input
%   nP      -  #positive samples
%   nN      -  #negative samples
%   mFd     -  #folds
%
% Output
%   VisP    -  binary indicators matrix for positive samples, mFd x nP (binary)
%   VisN    -  binary indicators matrix for negative samples, mFd x nN (binary)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-05-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-16-2012

% divide data
VisP = partVis(nP, mFd, 1);
VisN = partVis(nN, mFd, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Vis = partVis(n, m, isRand)
% Generate the training indicator matrix for k-fold method.
%
% Input
%   n       -  #samples
%   m       -  #folds
%   isRand  -  random flag, 1 | 0
%
% Output
%   Vis     -  binary indicators matrix, m x n (binary)

pos = select(isRand, randperm(n), 1 : n);
poss = vec2block(pos, m);

Vis = zeros(m, n);
for i = 1 : m
    pos = poss{i};
    Vis(i, pos) = 1;
end
Vis = Vis == 1;
