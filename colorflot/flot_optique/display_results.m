% display

clear all, close all, clc

addpath('m_func/')
addpath('../../flot_optique/')
addpath('/home/fpierre/Travail/codes/video_colorization/optical_flow/brox/Flow/brox_zip')
load TVL1_flow

RGB_video = videoread('./datas/pompon.avi');


RGB_video = double(RGB_video);

[Img, U, V] = rgb2yuv_simple(RGB_video);

size(F)
size(Img)

i=1;

u=F(:,:,1,i);
v=F(:,:,2,i);

figure, imagesc(u) ;
figure, imagesc(v) ;
figure, imagesc(sqrt(u.^2 + v.^2)) ;

afficher_carte(Img(:,:,:,i), Img(:,:,:,i+1), flow2carte(squeeze(F(:,:,:,i))))
