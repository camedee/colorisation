function [M]=calcM(m,n)
s=n*m;
ind=reshape([1:s],n,m);
ri=ones(s*9,1);
ci=ones(s*9,1);
v=ones(s*9,1);
len=0;
clen=0;

for j=1:m
    for i=1:n
        tlen=0;
        clen=clen+1;
        for ii=max(1,i-1):min(n,i+1)
            for jj=max(1,j-1):min(m,j+1)
                if (jj~=j)|(ii~=i)
                    len=len+1;
                    tlen=tlen+1;
                    ri(len)=clen;
                    ci(len)=ind(ii,jj);
                end
            end
        end
        v(len-tlen+1:len)=-1/(tlen);
        len=len+1;
        ri(len)=clen;
        ci(len)=clen;
    end
end

ri=ri(1:len);
ci=ci(1:len);
v=v(1:len);
M=sparse(ri,ci,v,s,s);