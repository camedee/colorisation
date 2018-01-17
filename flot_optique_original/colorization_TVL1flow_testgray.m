function R = colorization_TVL1flow_testgray(Img, RGB_init)


addpath('fonctions_m/')
addpath('../../flot_optique/')

%RGB_video = videoread('./data/pompon.avi');

%RGB_video = double(RGB_video(:,:,:,[2:20, 20:-1:2, 2:20, 20:-1:2]));

%[Img, U, V] = rgb2yuv_simple(RGB_video);
Img= squeeze(Img);
[l,k,c]= size(Img);
Img = reshape(Img, [l, k, 1, c]);
ImgF = Img;
[~, ImU, ImV] = IMAGErgb2yuv_simple(RGB_init);

U=zeros(size(Img));
V=zeros(size(Img));
U(:,:,1,1) = 0*ImU;
V(:,:,1,1) = 0*ImV;

h = waitbar(0,'regularization en cours');

step_time=1;

UnusedF1= zeros(size(Img,1), size(Img,2));
UnusedF2= zeros(size(Img,1), size(Img,2));
F=[];

for t=2:size(Img,4)
    waitbar(t/size(Img,4),h);

    flow= TVL1(Img(:,:,t), Img(:,:,t-1));
    F= cat(4,F,flow);
    ImgF(:,:,1,t) = registre( ImgF(:,:,1,t-1), flow, 'linear' );
    
        
end
close(h);

R= yuv2rgb_simple(squeeze(ImgF), 0*U, 0*V);

save('TVL1_flow.mat', 'F')

end


