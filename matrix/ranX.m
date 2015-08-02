function varargout = ranX(varargin)
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
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-02-2013

% dimension
m = length(varargin);

for i = 1 : m
    xs = varargin{i}(:);
    mi = min(xs);
    ma = max(xs);
    varargout{i} = [mi; ma];
end
