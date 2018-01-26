function [colvid]=colorvid(nbvid,marvid)
%% 
%nbvid :  une matrice contenant toutes frames en noir et blanc 
%         4D (hauteur, largeur, couleur (rgb), profondeur
%marvid : idem avec certains pixels marqu�s
nbvid=double(nbvid)./255;
marvid=double(marvid)./255;
%colvid : retour idem avec video coloris�e
largeur=size(nbvid,2); %largeur d'une frame
hauteur=size(nbvid,1); %hauteur
profondeur=size(nbvid,4);%nombre de frames
%%
%frame par frame on transforme en ntsc
for i=1:profondeur
    nbvid(:,:,:,i)=rgb2ntsc(nbvid(:,:,:,i));
    marvid(:,:,:,i)=rgb2ntsc(marvid(:,:,:,i));
end
%%
%On veut poser l'�quation AX=B avec A matrice des poids des voisins.
%Matrice carr� de c�t� largeur*hauteur*profondeur. Elle d�finit tous
%les couples possibles de pixels. Attention sur ligne du pixel marqu� toutes valeurs sont � 0 sauf diagonale.
%X vectuer couleurs de tous pixels de tous
%les frames qu'on cherche � optimiser. B vecteur r�sultat qu'on cherche �
%obtenir. toutes ses valeurs sont � 0 sauf celles des pixels marqu�s.
%allocation memoire matrice:
lignes=ones(largeur*hauteur*profondeur*27,1);%on stock ligne ou on va mettre val
colonnes=lignes; % on stock colonne on on met val
valeurs=lignes; % on stock val
%allocation memoire vecteur B:
ligneb=ones(largeur*hauteur*profondeur,1); % idem avec une seule colonne
valb=ones(largeur*hauteur*profondeur,2); %idem attentione vecteur b a 2 colonnes car il  a U et V qu'on va utiliser s�par�ment
%initialisation compteur valeurs
lenvaleurs=0;
lenb=0;
%allocation m�moire ( pixel + voisins, + voisins frame precedentes +
%voisins frames suivante)
voisins=zeros(27,0);%espace pour stocker pour chaque ligne (pixel) intensit�s de tous ces voisins (Y dans la formule)
for im=1:profondeur
    for lig=1:hauteur
        for col=1:largeur
            lenvois=0; %initialiser compteur de voisins � 0
            if sum(marvid(lig,col,:,im)~=nbvid(lig,col,:,im))>0 %sum(comparaison yuv du pixel de frame marque avec yuv du pixel noir et blanc) = sum permet d'additioner valeurs du resultat (vecteur de 0 et 1), si au moins un 1 donc >0 alors utilisateur a marque pixel
                %%si pixel marque:
                lenb=lenb+1; % on va rajouter une valeur donc on incremente
                ligneb(lenb)=largeur*hauteur*(im-1)+largeur*(lig-1)+col; %correspond au pixel (im, lig, col)
                valb(lenb,:)=marvid(lig,col,2:3,im); %on met valeur marque dans vecteur B
                lenvaleurs=lenvaleurs+1; % on incremente car on va rajouter une val dans matrice A. incremente seulement de 1 car on est sur ligne du pixel marqu�
                lignes(lenvaleurs)=largeur*hauteur*(im-1)+largeur*(lig-1)+col; %cf formule pour trouver a quel pixel correspond ligne du b ou X
                colonnes(lenvaleurs)=largeur*hauteur*(im-1)+largeur*(lig-1)+col;
                % pas eu besoin de modifier valeur, car de par construction
                % elle est deja a 1 et qu'on va plus modifier
            else
                %%b on s'occupe plus car a 0 si pas marque par contre A...
                for vlig=max(1,lig-1):min(hauteur,lig+1) %pour ligne avec prise enc ompte bord
                    for vcol=max(1,col-1):min(largeur,col+1)%pour colonne avec prise en compte bord
                        %%on �tudie le pixel (im lig col) et chacun
                        %%de ses voisins (vim vlig vcol)
                        if vim~=im || vlig~=lig || vcol~=col % verifier qu'on est pas sur pixel lui meme et bien sur ses voisins
                           lenvois=lenvois+1;
                           lenvaleurs=lenvaleurs+1;
                           lignes(lenvaleurs)=largeur*hauteur*(im-1)+largeur*(lig-1)+col; %ligne de la valeur c'est coordoonn�es du pixel etudie
                           colonnes(lenvaleurs)=largeur*hauteur*(vim-1)+largeur*(vlig-1)+vcol; %colonne de la valeur c'est coodoonn�es voisin �tudi�
                           voisins(lenvois)=nbvid(vlig,vcol,1,vim); %dans vecteur voisin on met intensit� du voisin
                        end
                    end 
                end
                %rajouter voisin d'apr�s et voisin d'avant
                lenvois=lenvois+1;
                lenvaleurs = lenvaleurs+1;
                lignes(lenvaleurs)=largeur*hauteur*(im-1)+largeur*(lig-1)+col;
                
                colonnes(lenvaleurs)=largeur*hauteur*(frameduvoisin-1)+largeur*(ligneduvoisin-1)+colonneduvoisin;
                voisins(lenvois)=nbvid(ligneduvoisin,colonneduvoisin,1,frameduvoisin)
                
                %% il nous reste a considerer pixel lui meme
                lenvaleurs=lenvaleurs + 1;
                lignes(lenvaleurs)=largeur*hauteur*(im-1)+largeur*(lig-1)+col; %ligne correspond a notre pixel
                colonnes(lenvaleurs)=largeur*hauteur*(im-1)+largeur*(lig-1)+col; %colonne correspond a notre pixel
                voisins(lenvois+1)=nbvid(lig,col,1,im);% on rentre valeur du pixel dans � la fin de voisins
                %%%formule wrs
                moy=mean(voisins(1:lenvois+1)); %n�cessaire pour calculer sigma
                sig=max(max(mean((voisins(1:lenvois+1)-moy).^2)*0.6,-min((voisins(1:lenvois)-voisins(lenvois+1)).^2)/log(0.01)),0.000002);
                voisins(1:lenvois)=exp(-(voisins(1:lenvois)-voisins(lenvois+1)).^2/sig);%on remplace voisins par wrs (grace a calcul matriciel matlab pas besoin boucle)
                voisins(1:lenvois)=voisins(1:lenvois)./sum(voisins(1:lenvois)); %on s'arrange pour que somme vaille 1
                valeurs(lenvaleurs-lenvois:lenvaleurs-1)=-voisins(1:lenvois); %on met dans vecteur valeur valeurs 
            end
        end
    end
end
%%on tronque car on avait alou� plus de mem que n�cessaire
lignes=lignes(1:lenvaleurs);
colonnes=colonnes(1:lenvaleurs);
valeurs=valeurs(1:lenvaleurs);
ligneb=ligneb(1:lenb);
valb=valb(1:lenb,:);
%%cr�ation matrice sparse
A=sparse(lignes,colonnes,valeurs,largeur*hauteur*profondeur,largeur*hauteur*profondeur);
%%
for t=1:2    %on se fait d'abord un sparse sur le U et ensuite sur le V
   b=sparse(ligneb, ones(lenb, 1), valb(:,t), largeur*hauteur*profondeur,1);
   X=A\b;
   x=full(X); %pour que le X resultant ne soit pas sparse
   %%On a valeurs de notre frame en vecteur, on remet dans une matrice 4D
   for im=1:profondeur
       for lig=1:hauteur
           for col=1:largeur
               nbvid(lig,col,t+1,im)=x(largeur*hauteur*(im-1)+largeur*(lig-1)+col);
           end
       end
   end
end
for im=1:profondeur
    nbvid(:,:,:,im)=ntsc2rgb(nbvid(:,:,:,im));
end
colvid=uint8(nbvid.*255);
