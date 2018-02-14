% [s,vnb]=frameLoader('DCsmooth.avi');
% [s,vma]=frameLoader('DCsmoothM.avi');
% 
% vnb=vnb(:,:,:,22:25);
% vma=vma(:,:,:,22:25);

vnb=imread('paysagenb.bmp');
vma=imread('paysagema.bmp');

rapport=0.5;
iterations=3;

vco=vma;
vintnb=vnb;
vintma=vma;
vintco=vco;

taille=[int32(rapport^iterations*size(vnb,1));int32(rapport^iterations*size(vnb,2))];
vintnb=miseechelle(vnb,taille);
vintma=miseechelle(vma,taille);
vintco=colorvid(vintnb,vintma);

imwrite(vintco,'paysageres5.0.jpg');

for i=iterations-1:-1:0
    r=rapport^i;
   
    taille=[int32(r*size(vnb,1));int32(r*size(vnb,2))];
    vintnb=miseechelle(vnb,taille);
    vintma=miseechelle(vma,taille);
    vintco=miseechelle(vintco,taille);
    
    
    vintco=coldesgrad(vintnb,vintma,vintco);
    
    imwrite(vintco,char(string('paysageres5.')+string(iterations-i)+string('.jpg')));
end


% ecrireVideo('DCco.avi',vintco);
% figure();subplot(2,2,1);imshow(vintco(:,:,:,1));subplot(2,2,2);imshow(vintco(:,:,:,2));
% subplot(2,2,3);imshow(vintco(:,:,:,3));subplot(2,2,4);imshow(vintco(:,:,:,4));