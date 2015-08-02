function varargout = vdoRMs(hr, pFs, varargin)
% Read a sequence of frames.
%
% Input
%   hr         -  video handle
%   pFs        -  frame index, 1 x nF
%   varargin   -  filed names, 1 x m (cell)
%
% Output
%   varargout  -  value set, 1 x m (cell)
%
% History
%   create     -  Feng Zhou (zhfe99@gmail.com), 01-03-2009
%   modify     -  Feng Zhou (zhfe99@gmail.com), 07-15-2013

% dimension
nF = length(pFs);

for i = 1 : nargout
    varargout{i} = cell(1, nF);
end

% read frames
for iF = 1 : nF
    pF = pFs(iF);

    %% read
    mat = vdoR(hr, pF);

    %% store
    for i = 1 : nargout
        varargout{i}{iF} = mat.(varargin{i});
    end
end
