function shArr3(x, d, varargin)
% Show arrow in 3-D figure.
%
% Input
%   x        -  acceleration vectors, 3 x 1
%   varargin
%     show option
%     nor    -  normalization flag, 'y' | {'n'}
%     lnWid  -  line width, {1}
%     n      -  maximum value in y axis
%     algs   -  algorithm name (used for legend), {[]}
%     cls    -  colors, {[]}
%     eq     -  axis equal flag, 'y' | {'n'}
%     G      -  label, {[]}
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 05-08-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 10-09-2011

% show option
psSh(varargin);

% function option
cls = ps(varargin, 'cls', {'r', 'g', 'b'});
lnWid = ps(varargin, 'lnWid', 1);
sca = ps(varargin, 'sca', 1);
isHead = psY(varargin, 'head', 'n');
angH = ps(varargin, 'angH', 15); angH = angH * pi / 180;
scaH = ps(varargin, 'scaH', 2);
angV = ps(varargin, 'angV', [30 60]);

% center
if isempty(x)
    x = [0; 0; 0];
end

CH = [1, 2, 3; ...
      2, 1, 1];

hold on;
for c = 1 : 3
    y = x;
    y(c) = y(c) + sca * d(c);
    plot3([x(1) y(1)], [x(2) y(2)], [x(3) y(3)], '-', 'Color', cls{c}, 'LineWidth', lnWid);

    if isHead
        i1 = CH(1, c);
        i2 = CH(2, c);
        scaHc = scaH * d(c);

        z1 = y;
        z1(i1) = z1(i1) - scaHc * cos(angH);
        z1(i2) = z1(i2) - scaHc * sin(angH);
        
        z2 = y;
        z2(i1) = z2(i1) - scaHc * cos(-angH);
        z2(i2) = z2(i2) - scaHc * sin(-angH);

        plot3([z1(1) y(1)], [z1(2) y(2)], [z1(3) y(3)], '-', 'Color', cls{c}, 'LineWidth', lnWid);
        plot3([z2(1) y(1)], [z2(2) y(2)], [z2(3) y(3)], '-', 'Color', cls{c}, 'LineWidth', lnWid);
    end
end

z = x + sca * d;
% plot3([x(1) z(1)], [x(2) z(2)], [x(3) z(3)], '-', 'Color', 'k', 'LineWidth', 2);
for c = 1 : 3
    y = z;
    y(c) = x(c);
    plot3([y(1) z(1)], [y(2) z(2)], [y(3) z(3)], ':', 'Color', 'k', 'LineWidth', .5);
    
    for c2 = 1 : 3
        if c2 == c
            continue;
        end
        y2 = x;
        y2(c2) = x(c2) + sca * d(c2);
        
        plot3([y(1) y2(1)], [y(2) y2(2)], [y(3) y2(3)], ':', 'Color', 'k', 'LineWidth', .5);
    end
end

% ang
% view(angV);
% axis on;

% axis
% ma = max(abs(d));
% axis([-ma ma -ma ma -ma ma] * 1.5);
% grid on;
% set(gca, 'XTick', [], 'YTick', [], 'ZTick', []);
