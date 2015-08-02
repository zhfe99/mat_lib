function reMkdir(fold)
% Re-make directory.
%
% Input
%   fold    -  name
%
% History
%   create  -  Feng Zhou (zhfe99@gmail.com), 07-08-2013
%   modify  -  Feng Zhou (zhfe99@gmail.com), 07-08-2013

% delete fold
if exist(fold, 'dir')
    rmdir(fold, 's');
end
mkdir(fold);