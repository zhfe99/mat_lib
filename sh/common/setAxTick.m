function setAxTick(pos, form, ticks, vals)
% Set axis tick of current axes.
%
% Example
%   setAxTick('x', '%.1f', [1, 2, 3], [0.1, 0.2, 0.3])
%
% Input
%   pos      -  position, 'x' | 'y'
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
%   create   -  Feng Zhou (zhfe99@gmail.com), 2009-01
%   modify   -  Feng Zhou (zhfe99@gmail.com), 2015-11

% dimension
n = length(ticks);

labels = cell(1, n);
for i = 1 : n
    labels{i} = sprintf(form, vals(i));
end

if strcmp(pos, 'x')
    set(gca, 'XTick', ticks, 'XTickLabel', labels);
elseif strcmp(pos, 'y')
    set(gca, 'YTick', ticks, 'YTickLabel', labels);
else
    error('unknown position: %s', pos);
end
