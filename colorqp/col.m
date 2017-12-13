function [nI]=col(gI, cI)
nI=gI;
n=size(gI,1); m=size(gI,2);
imgSize=n*m; %nombre de pixels image
ind = reshape([1:imgSize],n,m);

M=calcM(gI);
H=M'*M;
f=sparse(imgSize,1);
A=sparse(imgSize,imgSize);
b=f;

for t=2:3
r=ones(imgSize,1);
c=r;
v=r;
l=0;
for i=1:n
    for j=1:m
        if(cI(i,j,1))
           l=l+1;
           r(l)=ind(i,j);
           v(l)=cI(i,j,t);
        end
    end
end
beq=sparse(r(1:l),c(1:l),v(1:l),imgSize,1);
Aeq=double(sparse(r(1:l),r(1:l),ones(l,1),imgSize,imgSize));
lb=-ones(imgSize,1).*0.6;
ub=ones(imgSize,1).*0.6;

options = optimoptions(@quadprog, 'OptimalityTolerance', 1e-20);
new_vals=quadprog(H,f,A,b,Aeq,beq,lb,ub,beq,options);
nI(:,:,t)=reshape(new_vals,n,m);
end

nI=ntsc2rgb(nI);