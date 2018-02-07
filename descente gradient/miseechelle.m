function [U]=miseechelle(U0,taille)
hauteur0=int32(size(U0,1));
largeur0=int32(size(U0,2));
profondeur0=int32(size(U0,4));
hauteur1=taille(1);
largeur1=taille(2);
profondeur1=profondeur0;
U1=uint8(zeros(hauteur1,largeur1,3,profondeur1));
coeff=[double(hauteur0)/double(hauteur1);double(largeur0)/double(largeur1)];
for im=1:profondeur1
    for lig=1:hauteur1
        lig0=min(max(1,int32(lig*coeff(1))),hauteur0);
        for col=1:largeur1
            col0=min(max(1,int32(col*coeff(2))),largeur0);
            U1(lig,col,:,im)=U0(lig0,col0,:,im);
        end
    end
end
U=U1;