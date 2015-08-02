function varargout = ranXCol(varargin)
% Obtain the range of a matrix.
%
% Input
%   X       -  matrix
%
% Output
%   ran     -  range, [min max]
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 01-19-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-09-2013

% dimension
m = length(varargin);

for i = 1 : m
    X = varargin{i};
    %% dimension
    [~, nF] = size(X);

    %% min & max
    R = [min(X); max(X)];

    %% store
    varargout{i} = R;
end
