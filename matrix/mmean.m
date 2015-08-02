function [Me, Dev] = mmean(Ms)
% Compute the mean and standard deviation.
%
% Input
%   Ms      -  matrix set, 1 x m (cell), h x w
%
% Output
%   Me      -  mean matrix, h x w
%   Dev     -  standard deviation matrix, h x w
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 08-08-2013
%   modify  -  Feng Zhou (zhfe99@gmail.com), 08-08-2013

if iscell(Ms)
    Ms = cat(3, Ms{:});
end

Me = mean(Ms, 3);
Dev = std(Ms, 0, 3);