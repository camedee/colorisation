
g_name='example.bmp';
i_name='example_marked.bmp';
out_name='test_res.bmp';


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