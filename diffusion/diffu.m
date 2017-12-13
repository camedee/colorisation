
g_name='im1.bmp';
i_name='im2.bmp';
out_name='test_res.bmp';


gI=double(imread(g_name))/255; %double entre 0 et 1
cI=(imread(i_name)~=imread(g_name));

nI=col(gI,cI);

figure, imshow(nI)

imwrite(nI,out_name)