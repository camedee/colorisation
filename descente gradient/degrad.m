function U=degrad(A,b,U0)

l=0.3;
limite=1500;
iteration=1;
intres=zeros(limite,1);

U0=U0-l*(A.'*(A*U0))+l*A.'*b;
intres(iteration)=(U0.'*A.'-b')*(A*U0-b);

critere=500.0;

while and(iteration<limite,abs(critere)>0.00001)
    iteration=iteration+1;
    U0=U0-l*(A.'*(A*U0))+l*A.'*b;
%    U0=U0-U0.*(b~=0)+b;
    intres(iteration)=(U0.'*A.'-b')*(A*U0-b);
    critere=intres(iteration-1)-intres(iteration);
end
critere=[l, iteration, critere]
% figure(); plot(1:iteration,intres(1:iteration));
U=U0;


% U=A\b;
