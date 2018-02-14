
g_name='paysagenb.bmp';
i_name='paysagema.bmp';
out_name='paysageres4.bmp';


gI=double(imread(g_name))/255;
cI=double(imread(i_name))/255;
coI=(sum(abs(gI-cI),3)>0.01);
coI=double(coI);

gI=rgb2ntsc(gI);
cI=rgb2ntsc(cI);
cI(:,:,1)=coI;

nI=col(gI,cI);

figure, imshow(nI)

imwrite(nI,out_name)