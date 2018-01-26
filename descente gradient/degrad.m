function U=degrad(A,b,U0)
iteration=0;
l=0.03;
limite=1000;
intres=zeros(limite,1);
%  U0=A\b;
% max(U0(:))
% min(U0(:))
% 
% U0=U0+0.1*randn(size(b));
while iteration<limite
    iteration=iteration+1;
    U0=U0-l*(A.'*(A*U0))+l*A.'*b;
%    U0=U0-U0.*(b~=0)+b;
    intres(iteration)=(U0.'*A.'-b')*(A*U0-b);
end
figure(); plot(1:limite,intres);
U=U0;


% U=A\b;
