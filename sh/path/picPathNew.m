function wsPath = picPathNew(siz, n, shp, varargin)
% Put motion along the synthetic path.
%
% Input
%   siz     -  size of image, 1 x 2
%   n       -  #frames
%   shp     -  shape of synthetic path, 'l' | 's' | 'o'
%   varargin
%     dx    -  offset for 1st frame, {[0; 0]}
%     amp   -  amplitude, {4}
%     debg  -  debug flag, 'y' | {'n'}
%
% Output
%   wsPath
%     X     -  2 x n
%     Box   -  dim (=3) x 2 x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-27-2008
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% function option
dx = ps(varargin, 'dx', [0; 0]);
amp = ps(varargin, 'amp', 4);
isDebg = psY(varargin, 'debg', 'n');

% original path
X0 = picPathIni(siz, n);
gaps = pathGap(X0, amp, true);

% position
X = genPath(shp, gaps, dx);

% angle
s = [1, n + 1];
[angs, idx, ang0s] = pathNew(X0, X, s);

% adjust
Box = pathBox(X, angs, siz);

% store
wsPath.X = X;
wsPath.angs = angs;
wsPath.idx = idx;
wsPath.ang0s = ang0s;
wsPath.Box = Box;

% debug
if isDebg
    fig = ps(varargin, 'fig', 1);
    rows = 2; cols = 2;
    axs = iniAx(fig, rows, cols, [300 * rows, 300 * cols]);

    set(gcf, 'CurrentAxes', axs{1, 1});
    plot(X0(1, :), X0(2, :), '-ro'); axis equal;
    hold on; plot(X0(1, 1), X0(2, 1), '-b*');
    title('original path');

    set(gcf, 'CurrentAxes', axs{1, 2});
    plot(X(1, :), X(2, :), '-ro'); axis equal;
    hold on; plot(X(1, 1), X(2, 1), '-b*');
    title('new path');
    
    XX = reshape(Box(1, :, :), [2 n]);
    YY = reshape(Box(2, :, :), [2 n]);
    XX = [XX; nan(1, n)];
    YY = [YY; nan(1, n)];
    plot(XX(:), YY(:), '--bs');

    set(gcf, 'CurrentAxes', axs{2, 2});
    hold on;
    plot(angs, '-or'); axis equal;
    plot(ang0s, '--b');
    idx2 = idx(s(1 : end - 1));
    plot(idx2, ang0s(idx2), 'ob');
    title('new direction');
end
