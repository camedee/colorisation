[structnb1, nb1] = frameLoader('DCsmooth.avi');
[caca, nb2] = frameLoader('DCsmoothM.avi');
co=colorvid(nb1(:,:,:,25:27), nb2(:,:,:,25:27),structnb1(25:27));
figure();
for im=1:3
    subplot(3,1,im);
    imshow(co(:,:,:,im));
end