function pars = clfyPar(alg, cs, epis)
% Generate parameters for training classifiers.
%
% Input
%   alg     -  algorithm name
%   cs      -  all Cs, 1 x mC
%   epis    -  all epislons, 1 x mE
%
% Output
%   pars    -  parameters, 1 x mPar (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-05-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 08-03-2012

% grid
[C, Epi] = meshgrid(cs, epis);
c2s = C(:);
epi2s = Epi(:);

% dimension
m = length(c2s);

% per location
pars = cell(1, m);
for i = 1 : m
    pars{i} = st('alg', alg, 'c', c2s(i), 'epi', epi2s(i));
end