function ds = conDstHst(Hst1, Hst2)
% Calculate the chi-square distance of two histograms.
%   \chi(P, Q) = .5 * \sum_i (P_i - Q_i)^2 / (P_i + Q_i)
%
% Remark
%   Notice that chi-square distance is not a metric (i.e., not satisfied triangle inequality).
%
% Input
%   Hst1    -  1st histogram, nB x n
%   Hst2    -  2nd histogram, nB x n
%
% Output
%   ds      -  squared distance matrix, 1 x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-11-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-01-2013

% dimension
[nB, n] = size(Hst1);

% normalization
hist1 = sum(Hst1) + eps;
Hst1 = Hst1 ./ repmat(hist1, nB, 1);

hist2 = sum(Hst2) + eps;
Hst2 = Hst2 ./ repmat(hist2, nB, 1);

ds = sum((Hst1 - Hst2) .^ 2 ./ (Hst1 + Hst2 + eps), 1);
ds = ds * .5;
