function shCtr(Ctr, varargin)
% Show contour in 2-D.
%
% Input
%   Ctr      -  contour line (returned by matlab function contourc), 2 x nCtr
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 11-08-2010
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% #lines
maM = 1000;
Xs = cell(1, maM);
vs = zeros(1, maM);
m = 0;
head = 1;
while head <= size(Ctr, 2)
    m = m + 1;
    vs(m) = Ctr(1, head);
    len = Ctr(2, head);
    Xs{m} = Ctr(:, head + 1 : head + len);
    Xs{m} = [Xs{m}, Ctr(:, head + 1)];
    
    head = head + len + 1;
end
Xs(m + 1 : end) = [];
vs(m + 1 : end) = [];

% main plot
hold on;
for i = 1 : m
    plot(Xs{i}(1, :), Xs{i}(2, :), '-');
end
