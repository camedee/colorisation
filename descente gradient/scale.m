function [U]=scale(U0,coeff)
hauteur0=size(U0,1);
largeur0=size(U0,2);
profondeur0=size(U0,4);
hauteur1=round(hauteur0*coeff-0.1);
largeur1=round(largeur0*coeff-0.1);
profondeur1=profondeur0;
U1=zeros(hauteur1,largeur1,3,profondeur1);
lig0=1;
for im=1:profondeur1
    for lig=1:hauteur1
        lig0=round(lig/coeff-0.1);
        for col=1:largeur1
            U1(lig,col,:,im)=U0(lig0,round(col/coeff-0.1),:,im);
        end
    end
end
U=U1;