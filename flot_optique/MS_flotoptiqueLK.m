close all; clear all; clc
addpath flot_optique/datas flot_optique/m_func/

mex  -largeArrayDims flot_optique/c_func/gradient.cpp -output gradient_mex_single
mex  -largeArrayDims flot_optique/c_func/divergence.cpp -output divergence_mex_single
mex  -largeArrayDims flot_optique/c_func/lk.cpp -output lk_mex


% Entrées.
[structnb1, nb1] = frameLoader('DCsmooth.avi');
[caca, nb2] = frameLoader('DCsmoothM.avi');
ISource = single(rgb2gray(nb1(:,:,:,45)));
ITarget = single(rgb2gray(nb1(:,:,:,46)));

% Données sur lesquelles on va travailler.
datas = struct('IS', ISource, 'IT', ITarget);

% Définit comment Obtenir la dimension des données.
get_dim = @(struct) size(struct.IT);
% Définit comment Remonter d'un niveau grossier à fin pour le résultat
% qui va initialiser le niveau le plus fin.
interpol = @(m, taille) 2*cat(3, imresize(m(:,:,1), taille),...
    imresize(m(:,:,2), taille));
% Définit comment Passer les données d'une échelle grande à petite.
decim = @(struct, facteur) sresize_lk(struct, facteur );


% Lance le code multi-échelle sur la fonction précisée.
tic
flow = multi_echelle(datas, get_dim,...
    @OF_LK, decim, interpol, 2, 0, 7);
toc

% Recallage pour vérification.
Iout = registre( ISource, flow, 'linear' );
figure, imagesc(ISource), colormap gray
figure, imagesc(ITarget), colormap gray
figure, imagesc(Iout), colormap gray
imwrite(ISource,'mauvaisRecalageSource.jpg')
imwrite(ITarget,'mauvaisRecalageTarget.jpg')
imwrite(Iout,'mauvaisRecalageOut.jpg')
