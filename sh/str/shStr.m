function ha = shStr(str, varargin)
% Show string.
%
% Input
%   str       -  string
%   varargin
%     show option
%     ftCl    -  string color, {[.4 .4 .4]}
%     ftBkCl  -  background color, {'none'}
%     ftNm    -  font name, {'Monoca'}
%     ftSiz   -  font size, {23}
%     axis    -  flag of showing axis, 'y' | {'n'}
%
% Output
%   ha        -  handle container
%     hStr    -  string handle
%
% History
%   create    -  Feng Zhou (zhfe99@gmail.com), 12-31-2008
%   modify    -  Feng Zhou (zhfe99@gmail.com), 08-09-2013

% show option
psSh(varargin);

% function option
ftCl = ps(varargin, 'ftCl', [.4 .4 .4]);
ftNm  = ps(varargin, 'ftNm', 'Monoca');
ftSiz = ps(varargin, 'ftSiz', 23);
isAxis = psY(varargin, 'axis', 'n');
ftBkCl = ps(varargin, 'ftBkCl', 'none');

% turn off the axis
if ~isAxis
    set(gca, 'visible', 'off');
end

% show string
ha.hStr = text('Position', [.5, .5], 'HorizontalAlignment', 'center', ...
               'Units', 'Normalized', 'String', str, 'Color', ftCl, ...
               'BackgroundColor', ftBkCl, 'LineWidth', 1, 'FontName', ...
               ftNm, 'FontSize', ftSiz, 'FontWeight', 'bold', 'Interpreter', 'none');
