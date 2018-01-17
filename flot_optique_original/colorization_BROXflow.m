function R = colorization_BROXflow(Img, RGB_init)


addpath('fonctions_m/')
addpath('../../flot_optique/')

%RGB_video = videoread('./data/pompon.avi');

%RGB_video = double(RGB_video(:,:,:,[2:20, 20:-1:2, 2:20, 20:-1:2]));

%[Img, U, V] = rgb2yuv_simple(RGB_video);
Img= squeeze(Img);
[l,k]= size(Img);
Img = reshape(Img, [size(Img,1), size(Img,2), 1, size(Img,3)]);
[~, ImU, ImV] = IMAGErgb2yuv_simple(RGB_init);

U=zeros(size(Img));
V=zeros(size(Img));
U(:,:,1,1) = ImU;
V(:,:,1,1) = ImV;

h = waitbar(0,'regularization en cours');

step_time=1;

UnusedF1= zeros(size(Img,1), size(Img,2));
UnusedF2= zeros(size(Img,1), size(Img,2));

for t=2:size(Img,4)
    waitbar(t/size(Img,4),h);


        flow= brox_flow(Img(:,:,t), Img(:,:,t-1));
        U(:,:,1,t) = registre( U(:,:,1,t-1), -flow, 'linear' );
        V(:,:,1,t) = registre( V(:,:,1,t-1), -flow, 'linear' );
        
end
close(h);

R= yuv2rgb_simple(squeeze(Img), U, V);

end


