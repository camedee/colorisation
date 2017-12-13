function [nI]=col(gI, cI)

n=size(gI,1); m=size(gI,2);
imgSize=n*m; %nombre de pixels image
ind = reshape([1:imgSize],n,m);

M=calcM(m,n);
H=M'*M;
f=sparse(imgSize,1);
A=sparse(imgSize,imgSize);
b=f;

r=ones(1,1);
c=r;
v=r;
l=1;
for i=1:n
    for j=1:m
        if(cI(i,j))
           r(l)=ind(i,j);
           c(l)=1;
           v(l)=gI(i,j);
           l=l+1;
        end
    end
end
beq=sparse(r,c,v,imgSize,1);
Aeq=double(sparse(r,r,v>0,imgSize,imgSize));
lb=f;
ub=ones(imgSize,1);

new_vals=quadprog(H,f,A,b,Aeq,beq,lb,ub);

nI=uint8(reshape(new_vals,n,m,1).*255); %reshape, voir explications plus haut