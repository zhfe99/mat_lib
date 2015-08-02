function F = imgMed(F0, wF)
% Image blurring.
%
% Input
%   img0    -  initial image
%   par     -  parameter
%     blur  -  radius of gaussian filter, {[]} | 1 | 2 | ...
%
% Output

%   img     -  transformed image
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-24-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-18-2013

F = F0;
for i = 1 : 3
    F(:, :, i) = medfilt2(F0(:, :, i), [0 0] + wF);
end
