function h = shPoly(L0, b0, varargin)
% Plot polyhedron in 3-D figure.
%
% Input
%   L0       -  constraint, m0 x 3
%   b0       -  constraint, m0 x 1
%   varargin
%     show option
%     mi     -  minimum, 3 x 1
%     ma     -  maximum, 3 x 1
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 12-30-2008
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% shw option
psSh(varargin);

% function option
mi = ps(varargin, 'mi', [-1 -1 -1]);
ma = ps(varargin, 'ma', [1 1 1]);
alpha = ps(varargin, 'alpha', .5);
faceCl = ps(varargin, 'faceCl', []);
egCl = ps(varargin, 'egCl', 'k');

% constraint
L = [L0; eye(3); -eye(3)];
b = [b0; ma(:); -mi(:)];
m = size(L, 1);

% vertex
X = zeros(3, m ^ 2);
co = 0;
for i = 1 : m
    for j = i + 1 : m
        for k = j + 1 : m
            A = L([i j k], :);
            if rank(A) == 3
                co = co + 1;
                X(:, co) = A \ b([i j k]);
            end
        end
    end
end
X(:, co + 1 : end) = [];

% feasiblity
n = size(X, 2);
vis = zeros(1, n);
for i = 1 : n
    if all(L * X(:, i) <= b + eps)
        vis(i) = 1;
    end
end
Y = X(:, vis == 1);

% convex hull
K = convhulln(Y');

% plot face
hold on;
faces = cell(1, size(K, 1));
for i = 1 : size(K, 1)
    f = K(i, :);
    if isempty(faceCl)
        [~, faceCl] = genMkCl(i);
    end

    % fact
    faces{i} = patch(Y(1, f), Y(2, f), Y(3, f), faceCl, 'Facealpha', alpha, 'EdgeColor', egCl);
end

% plot vertex
% plot3(Y(1, :), Y(2, :), Y(3, :), 'bo', 'MarkerFaceColor', 'b');

axis([mi(1) ma(1) mi(2) ma(2) mi(3) ma(3)]);
grid on;
view([15 45]);

h.faces = faces;
