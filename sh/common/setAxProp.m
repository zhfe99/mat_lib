function setAxProp(axs, nm, val)
% Set properties of current axes.
%
% Input
%   box      -  bounding box, d x 2
%   parAx    -  parameter
%     set    -  setting flag, {'y'} | 'n'
%     grid   -  grid on flag, 'y' | {'n'}
%     eq     -  axis equal flag, 'y' | {'n'}
%     sq     -  axis square flag, 'y' | {'n'}
%     ij     -  axis ij flag, 'y' | {'n'}
%     ax     -  axis flag, {'y'} | 'n'
%     tick   -  tick flag, {'y'} | 'n'
%     label  -  label flag, 'y' | {'n'}
%     ang    -  view angle, {[]}
%
% History
%   create   -  Feng Zhou (zhfe99@gmail.com), 01-29-2009
%   modify   -  Feng Zhou (zhfe99@gmail.com), 07-14-2013

m = length(axs);
for i = 1 : m
    set(axs{i}, nm, val);
end