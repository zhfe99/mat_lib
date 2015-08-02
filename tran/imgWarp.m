function img = imgWarp(img0, A)
% Warp image by affine transformation.
%
% Input
%   img0    -  original image, h x w x 3 (uint8) or h x w (double)
%   A       -  affine transformation matrix in homogenous coordinates, 3 x 3
% 
% Output
%   img     -  new image after transformation, h x w x 3 (uint8) or h x w (double)
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-19-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-11-2014

% image size
siz = size(img0);
dim = select(length(siz) == 2, 1, 3);
siz = [siz(1), siz(2)];
siz2 = siz(1) * siz(2);

% coordinates after transformation
[x0, y0] = meshgrid(1 : siz(2), 1 : siz(1));
coords = [x0(:)'; y0(:)'];

% transformation (homogenous coordinates)
a = A(1 : 2, 1 : 2); 
b = A(1 : 2, 3);

% warpx
warpedCoords = a \ (coords - repmat(b, 1, siz2));
xprime = warpedCoords(1, :)';
xprime = reshape(xprime, siz);
yprime = warpedCoords(2, :)';
yprime = reshape(yprime, siz);

% interpolation
img = zeros(siz(1), siz(2), dim);
for d = 1 : dim
    im0 = double(img0(:, :, d));
    img(:, :, d) = interp2(x0, y0, im0, xprime, yprime, 'linear');
end

if dim == 3
    img(isnan(img)) = 0;
    img = round(img);
    img = uint8(img);
end
