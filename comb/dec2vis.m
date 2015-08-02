function vis = dec2vis(dec, m)
% Convert decimal to binary number in binary vector.
%
% Example
%   input   -  dec = 10
%   call    -  vis = dec2vis(dec)
%   output  -  vis = [0; 1; 0; 1]
%
% Input
%   dec     -  decimal value
%   m       -  number of bits, (optional)
%
% Output
%   vis     -  binary vector, m x 1
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-27-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

s = dec2bin(dec);
s = s(end : -1 : 1);
m0 = length(s);

if ~exist('m', 'var')
    m = m0;
end

vis = zeros(m, 1);
for i = 1 : min(m, m0);
    if strcmp(s(i), '1')
        vis(i) = 1;
    end
end
