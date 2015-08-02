function as = ccat(ass)
% Cell concatenation.
%
% Input
%   ori     -  orientation, 'diag' | 'vert' | 'horz' | 'full'
%   Ms      -  matrix set, m1 x m2 (cell), d_i x n_i
%
% Output
%   M       -  matrix
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-27-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 05-17-2014

% dimension
m = length(ass);
ms = zeros(1, m);
for i = 1 : m
    ms(i) = length(ass{i});
end
n = sum(ms);
ns = [0 cumsum(ms)];

as = cell(1, n);
for i = 1 : m
    head = ns(i) + 1;
    tail = ns(i + 1);
    for j = head : tail
        as{j} = ass{i}{j - head + 1};
    end
end