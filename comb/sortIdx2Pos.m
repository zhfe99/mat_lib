function pos = sortIdx2Pos(idx)

% dimension
n = length(idx);

pos = zeros(1, n);
for i = 1 : n
    pos(idx(i)) = i;
end