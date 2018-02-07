[structnb1, nb1] = frameLoader('DCsmooth.avi');
[caca, nb2] = frameLoader('DCsmoothM.avi');
co=colorvid(nb1(:,:,:,24:26), nb2(:,:,:,24:26),structnb1(24:26));
figure();
for im=1:3
    subplot(3,1,im);
    imshow(co(:,:,:,im));
end