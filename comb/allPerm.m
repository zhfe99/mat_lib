function Idx = allPerm(n)

% nF = factorial(n);
% Idx = zeros(n, nF);
% Idx(:, 1) = 1 : n;
% 
% for iF = 2 : nF
%     Idx(:, iF) = newPerm(Idx(:, 1), iF - 1, n);
% end
Idx = fpermute(n);
Idx = Idx';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function idx = newPerm(idx0, iF, n)

idx = idx0;
for i = 2 : n
    j = mod(iF, i) + 1;
    tmp = idx(j);
    idx(j) = idx(i);
    idx(i) = tmp;
    
    iF = floor(iF / i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function idx = nextPerm(idx0, iF, n)

%%%%%%%%%%%%%%%%%%%%%%%%
function p = fpermute(n)

a=1;
n1=1;
for i=2:n
    p=[];
    n1=n1*(i-1);
    for k=1:i
        x=ones(n1,1)*k;
    for j=1:i-1
        x=[x k+a(:,j)];
    end
    p=[p;x];
    end
    p(p>i)=p(p>i)-i;
    a=p;
end
