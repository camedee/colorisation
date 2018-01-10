close all; clear all; clc
addpath datas m_func/

mex c_func/gradient.cpp -output gradient_mex_single
mex c_func/divergence.cpp -output divergence_mex_single

ISource = single(rgb2gray(imread('car0.png')));
ITarget = single(rgb2gray(imread('car1.png')));

flow1 = TVL1( ITarget, ISource );

flow2 = TVL1( ISource, ITarget );


Iout = registre(registre( ISource, flow2, 'linear' ), flow1, 'linear');

figure, imagesc(Iout), colormap gray
figure, imagesc(ITarget), colormap gray
figure, imagesc(ISource), colormap gray

figure, imagesc(abs(Iout - ISource)), colormap gray



Iout = registre(registre( ITarget, flow2, 'linear' ), flow1, 'linear');
figure, imagesc(abs(Iout - ITarget)), colormap gray


