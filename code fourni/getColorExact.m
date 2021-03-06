function [nI,snI]=getColorExact(colorIm,ntscIm)

n=size(ntscIm,1); m=size(ntscIm,2);
imgSize=n*m; %nombre de pixels image


nI(:,:,1)=ntscIm(:,:,1);

indsM=reshape([1:imgSize],n,m); % prend un vecteur de valeurs et le s�pare en plusieurs colonnes de sorte � obtenir une matrice n,m avec les valeurs mises les unes � la suites des autres suivant les colonnes. Servira car permetra de retrouver la valeur du vecteur colone en cherchant les coordonn�es du pixel dans cette matrice.
lblInds=find(colorIm); %rend un vecteur avec les valeurs les coordonn�es de chaque point de colorIm qui ne vaut pas 0

wd=1;

len=0;
consts_len=0;
%Le but �tant de stocker les valeurs wrs de chaque voisin d'un pixel, et ce pour tous les pixels.Cr�ation de 3 vecteurs �normes.Deux pour coordoon�s x et y du pixel dans la matrice sparse enorme, 3iem pour la valeur
col_inds=zeros(imgSize*(2*wd+1)^2,1);
row_inds=zeros(imgSize*(2*wd+1)^2,1);
vals=zeros(imgSize*(2*wd+1)^2,1);
gvals=zeros(1,(2*wd+1)^2);


for j=1:m
    for i=1:n
        consts_len=consts_len+1;
        
        if (~colorIm(i,j))%Si ce n'est pas le pixel le pixel en question (on veut traiter ses voisins)
            tlen=0;
            for ii=max(1,i-wd):min(i+wd,n)
                for jj=max(1,j-wd):min(j+wd,m)
                    
                    if (ii~=i)|(jj~=j)
                        len=len+1; tlen=tlen+1;
                        row_inds(len)= consts_len;
                        col_inds(len)=indsM(ii,jj);
                        gvals(tlen)=ntscIm(ii,jj,1);
                    end
                end
            end
            t_val=ntscIm(i,j,1); %intensit� pixel centre du patch
            gvals(tlen+1)=t_val; %on rajout l'intensit� du pixel au milieu
            mr=mean(gvals(1:tlen+1));
            c_var=mean((gvals(1:tlen+1)-mr).^2); %sigma� dans ma formule
            csig=c_var*0.6;
            mgv=min((gvals(1:tlen)-t_val).^2); %minimum du carr� de l'�cart entre le pixel et son entourage afin de cherche le plus proche voisin en intensit�.
            if (csig<(-mgv/log(0.01)))
                csig=-mgv/log(0.01);
            end
            if (csig<0.000002) %si csig torp proche de 0 on lui assigne petite valeur
                csig=0.000002;
            end
            
            gvals(1:tlen)=exp(-(gvals(1:tlen)-t_val).^2/csig);%on applique formule selon wrs pour chaque element de gvals
            %gvals(1:tlen)=1+((gvals(1:tlen)-mr).*((t_val-mr)/csig));%on applique une autre formule selon wrs pour chaque element de gvals
            
            gvals(1:tlen)=gvals(1:tlen)/sum(gvals(1:tlen)); %on fait en sorte que la somme des coefs wrs =1
            vals(len-tlen+1:len)=-gvals(1:tlen); % on stock valeurs pixels patch dans vals
        end
        
        
        len=len+1;
        row_inds(len)= consts_len;
        col_inds(len)=indsM(i,j);
        vals(len)=1; %wrs du pixel trait� vaut 1
        
    end
end

%resize tableau
vals=vals(1:len);
col_inds=col_inds(1:len);
row_inds=row_inds(1:len);

A=sparse(row_inds,col_inds,vals,consts_len,imgSize);%cr�er matrice creuse avec les 3 vecteurs
b=zeros(size(A,1),1); %vecteur de la taille nombre de pixels (imgSize)


for t=2:3 % pour u et v
    curIm=ntscIm(:,:,t); %curIm matrice semblable � ntscIm mais en avec une seule composante U ou V
    b(lblInds)=curIm(lblInds); %les valeurs de b aux indices 1b1Inds deviennent les valeurs de curIm aux indices 1b1Inds
    new_vals=A\b; %solveur mathlab pour resoudre Ax = b
    nI(:,:,t)=reshape(new_vals,n,m,1); %rechape, voir explications plus haut
end



snI=nI; %r�sultat dans espace YIQ
nI=ntsc2rgb(nI); % resultat RGB

