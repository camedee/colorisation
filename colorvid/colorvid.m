function [colvid]=colorvid(nbvid,marvid)
largeur=size(nbvid,2);
hauteur=size(nbvid,1);
profondeur=size(nbvid,4);%nombre de frames
for i=1:profondeur
    nbvid(:,:,:,i)=rgb2ntsc(nbvid(:,:,:,i));
    marvid(:,:,:,i)=rgb2ntsc(marvid(:,:,:,i));
end

lignes=ones(largeur*hauteur*profondeur*27,1);
colonnes=lignes;
valeurs=lignes;
ligneb=ones(largeur*hauteur*profondeur,1);
valb=ones(largeur*hauteur*profondeur,2);

lenvaleurs=0;
lenb=0;
voisins=zeros(27,1);

for im=1:profondeur
    for lig=1:hauteur
        for col=1:largeur
            lenvois=0;
            if sum(marvid(lig,col,:,im)~=nbvid(lig,col,:,im))>0
                lenb=lenb+1;
                ligneb(lenb)=largeur*hauteur*(im-1)+largeur*(lig-1)+col;
                valb(lenb,:)=marvid(lig,col,2:3,im);
                lenvaleurs=lenvaleurs+1;
                lignes(lenvaleurs)=largeur*hauteur*(im-1)+largeur*(lig-1)+col;
                colonnes(lenvaleurs)=largeur*hauteur*(im-1)+largeur*(lig-1)+col;
            else
                for vim=max(1,im-1):min(profondeur,im+1)
                    for vlig=max(1,lig-1):min(hauteur,lig+1)
                        for vcol=max(1,col-1):min(largeur,col+1)
                            if vim~=im || vlig~=lig || vcol~=col
                               lenvois=lenvois+1;
                               lenvaleurs=lenvaleurs+1;
                               lignes(lenvaleurs)=largeur*hauteur*(im-1)+largeur*(lig-1)+col;
                               colonnes(lenvaleurs)=largeur*hauteur*(vim-1)+largeur*(vlig-1)+vcol;
                               voisins(lenvois)=nbvid(vlig,vcol,1,vim);
                            end
                        end
                    end
                end
                lenvaleurs=lenvaleurs+1;
                voisins(lenvois+1)=nbvid(lig,col,1,im);
                moy=mean(voisins(1:lenvois+1));
                sig=max(mean((voisins(1:lenvois+1)-moy).^2)*0.6,0.00002);
                voisins(1:lenvois)=exp(-(voisins(1:lenvois)-voisins(lenvois+1)).^2/sig);
                voisins(1:lenvois)=voisins(1:lenvois)./sum(voisins(1:lenvois));
                valeurs(lenvaleurs-lenvois:lenvaleurs-1)=-voisins(1:lenvois);
                lignes(lenvaleurs)=largeur*hauteur*(im-1)+largeur*(lig-1)+col;
                colonnes(lenvaleurs)=largeur*hauteur*(im-1)+largeur*(lig-1)+col;
            end
        end
    end
end
lignes=lignes(1:lenvaleurs);
colonnes=colonnes(1:lenvaleurs);
valeurs=valeurs(1:lenvaleurs);
ligneb=ligneb(1:lenb);
valb=valb(1:lenb,:);
A=sparse(lignes,colonnes,valeurs,largeur*hauteur*profondeur,largeur*hauteur*profondeur);
for t=1:2
   b=sparse(ligneb, ones(lenb, 1), valb(:,t), largeur*hauteur*profondeur,1);
   X=A\b;
   x=full(X);
   for im=1:profondeur
       for lig=1:hauteur
           for col=1:largeur
               nbvid(lig,col,t+1,im)=x(largeur*hauteur*(im-1)+largeur*(lig-1)+col);
           end
       end
   end
end
colvid=nbvid;
