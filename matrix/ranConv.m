function varargout = ranConv(wF, dire, varargin)
% Find the maximum value over a window.
%
% Input
%   wF         -  window
%   dire       -  direction, 'left' | 'right' | 'both'
%   varargin   -  1 x m (cell)
%     Ran0     -  original range, 2 x n
%
% Output
%   varargout  -  1 x m (cell)
%   Ran        -  new range, 2 x n
%
% History
%   create     -  Feng Zhou (zhfe99@gmail.com), 03-10-2011
%   modify     -  Feng Zhou (zhfe99@gmail.com), 07-05-2013

% each matrix
for i = 1 : length(varargin)

    %% dimension
    n = size(varargin{i}, 2);

    %% conv
    varargout{i} = zeros(2, n);
    varargout{i}(1, :) = minConv(varargin{i}(1, :), wF, dire);
    varargout{i}(2, :) = maxConv(varargin{i}(2, :), wF, dire);
end
