clear all, close all, clc

addpath('./fonctions_m/')
RGB_video = videoread('./data/pompon.avi');

RGB_video = double(RGB_video);

[Img, U, V] = rgb2yuv_simple(RGB_video);

%R = colorization_lucas_kanade(Img, RGB_video(:,:,:,1));
tic
R = colorization_TVL1flow_testgray(Img, RGB_video(:,:,:,1));
toc
%R = colorization_BROXflow(Img, RGB_video(:,:,:,1));

videodisplay(R);

videowrite(R, 'testgray_TVL1.avi')

videoframes(R)
% %%
% clear all, close all, clc
% A= videoread('colorization_TVL1flow.avi');
% videoframes(A);
% %%
% t=-1:0.00001:1;
% plot(t, t.^(1.5))
