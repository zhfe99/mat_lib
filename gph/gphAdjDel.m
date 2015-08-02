function A = gphAdjDel(Pt)
% Delaunay triangulation to connect nodes.
%
% Input
%   Pt      -  graph node, 2 x n
%
% Output
%   A       -  node-node adjacency, n x n
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 08-11-2011
%   modify  -  Feng Zhou (zhfe99@gmail.com), 06-23-2014

% dimension
n = size(Pt, 2);

% run matlab built-in function
Tri = delaunay(Pt(1, :)', Pt(2, :)');

% convert triangle to an adjacency matrix
nTri = size(Tri, 1);
A = zeros(n, n);
% per triangle
for iTri = 1 : nTri
    i1 = Tri(iTri, 1);
    i2 = Tri(iTri, 2);
    i3 = Tri(iTri, 3);
    is = sort([i1 i2 i3]);

    A(is(1), is(2)) = 1;
    A(is(1), is(3)) = 1;
    A(is(2), is(3)) = 1;
end
A = A + A';