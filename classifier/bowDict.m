function bow = bowDict(Xs, par)
% Build the bag-of-words dictionary from the data.
%
% Input
%   Xs      -  sample matrix, 1 x m (cell), d0 x ni
%   par
%     d     -  #clusters, {10}
%     rSmp  -  #samples / #total samples, {.1}
%
% Output
%   bow     -  BoW model
%     Me    -  cluster centers, d0 x d
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-05-2014
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-29-2014

% function option
d = ps(par, 'd', 10);
rSmp = ps(par, 'rSmp', .1);
prIn('bowDict', 'd %d, rSmp %.2f', d, rSmp);

% all samples
X = mcat('horz', Xs);

% dimension
[d0, n] = size(X);

% randomly sample a subset
idx = randperm(n);
nSmp = round(n * rSmp);
Y = X(:, idx(1 : nSmp));

% clustering
G = kmean(Y, d);

% cluster centers
Me = zeros(d0, d);
for c = 1 : d
    idx = find(G(c, :));
    Me(:, c) = sum(Y(:, idx), 2) / length(idx);
end

% store
bow.Me = Me;
bow.nSmp = nSmp;

prOut;
