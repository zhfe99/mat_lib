function pars = clfyParK(alg, cs, epis, gs)
% Generate parameters for training classifiers.
%
% Input
%   alg     -  algorithm name
%   cs      -  all Cs, 1 x mC
%   epis    -  all epislons, 1 x mE
%   gs      -  gammar, 1 x mG
%
% Output
%   pars    -  parameters, 1 x mPar (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-05-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 08-03-2012

% dimension
mC = length(cs);
mE = length(epis);
mG = length(gs);
m = mC * mE * mG;

% per location
pars = cell(1, m);
co = 0;

for iC = 1 : mC
    for iE = 1 : mE
        for iG = 1 : mG
            co = co + 1;
            pars{co} = st('alg', alg, 'c', cs(iC), 'epi', epis(iE), 'g', gs(iG));
        end
    end
end
