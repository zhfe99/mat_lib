function [siz, rat] = imgSizFit(siz0, sizMa)
% Adjust the figure size to fit with the maximum size constraint but keeping the ratio.
%
% Input
%   siz0    -  original size, 1 x 2
%   sizMa   -  maximum size, 1 x 2
%
% Output
%   siz     -  new size, 1 x 2
%   rat     -  ratio
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 05-24-2013
%   modify  -  Feng Zhou (zhfe99@gmail.com), 02-12-2014

% original size
h0 = siz0(1);
w0 = siz0(2);

% maximum size
hMa = sizMa(1);
wMa = sizMa(2);

% error
if hMa == 0 && wMa == 0
    siz = siz0;
    rat = 1;
    return;
end

% fit already
if h0 <= hMa && w0 <= wMa
    siz = [h0, w0];
    rat = 1;
    return;
end

% adjust height
if h0 > hMa
    sca = w0 / h0;

    h0 = hMa;
    w0 = round(sca * h0);
end

% adjust width
if w0 > wMa
    sca = h0 / w0;

    w0 = wMa;
    h0 = round(sca * w0);
end

% store
siz = [h0, w0];
rat = mean(siz ./ siz0);