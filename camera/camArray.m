function [camss, ns] = camArray(r, m, nMa)
% Build a camera array.
%
% Input
%   r       -  radius
%   m       -  #level
%   nMa     -  #maximum cameras
%
% Output
%   camss   -  camera, 1 x m (cell), 1 x ni (cell)
%   ns      -  #camera in each level, 1 x m (cell)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 06-13-2012
%   modify  -  Feng Zhou (zhfe99@gmail.com), 12-21-2013

% default parameter
if nargin == 0
    r = 50;
    m = 8;
    nMa = 40;
    
    % r = 50;
    % m = 3;
    % nMa = 10;
end

bs = linspace(-pi / 2, 0, m);
[Rss, tss, camss] = cellss(1, m);
ns = zeros(1, m);

% each level
for i = 1 : m
    b = bs(i);
    ns(i) = round(cos(b) * nMa);
    n = ns(i);
    [Rss{i}, tss{i}, camss{i}] = cellss(1, n);
    
    as = linspace(0, 2 * pi, n);
    zs = sin(b) * r + zeros(1, n);
    xs = sin(as) * cos(b) * r;
    ys = cos(as) * cos(b) * r;
    
    %% each angle
    for j = 1 : n
        a = 2 * pi - as(j);
        R1 = [ cos(a), 0, sin(a); ...
                    0, 1,      0; ...
              -sin(a), 0, cos(a)];
        R2 = [cos(b), -sin(b), 0; ...
              sin(b),  cos(b), 0; ...
                   0,       0, 1];
        R3 = [1,      0,       0; ...
              0, cos(b), -sin(b); ...
              0, sin(b),  cos(b)];
        Rss{i}{j} = R3 * R1;
        tss{i}{j} = [xs(j); ...
                     zs(j); ...
                     ys(j)];
        camss{i}{j} = st('R', Rss{i}{j}, 't', tss{i}{j});
    end
end
