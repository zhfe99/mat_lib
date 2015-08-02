function shImgUpd(ha, F)
% Update image in 2-D.
%
% Input
%   ha      -  handle
%   F       -  image
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 02-13-2009
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-02-2013

% normalize
ran = ha.ran;
if ~isempty(ran)
    F = ranNor(F, ran);
end

set(ha.haImg, 'CData', F);
