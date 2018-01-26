function [fx, fy] = MS_flotoptiqueLK_coord_func(source, target)
addpath flot_optique/datas flot_optique/m_func/

mex  -largeArrayDims flot_optique/c_func/gradient.cpp -output gradient_mex_single
mex  -largeArrayDims flot_optique/c_func/divergence.cpp -output divergence_mex_single
mex  -largeArrayDims flot_optique/c_func/lk.cpp -output lk_mex

% Entr�es.
ISource = single(source);
ITarget = single(target);

% Donn�es sur lesquelles on va travailler.
datas = struct('IS', ISource, 'IT', ITarget);

% D�finit comment Obtenir la dimension des données.
get_dim = @(struct) size(struct.IT);
% D�finit comment Remonter d'un niveau grossier à fin pour le résultat
% qui va initialiser le niveau le plus fin.
interpol = @(m, taille) 2*cat(3, imresize(m(:,:,1), taille),...
    imresize(m(:,:,2), taille));
% Définit comment Passer les données d'une échelle grande à petite.
decim = @(struct, facteur) sresize_lk(struct, facteur );


% Lance le code multi-échelle sur la fonction précisée.
tic
flow = multi_echelle(datas, get_dim,...
    @OF_LK, decim, interpol, 2, 0, 6);
toc

% Enregistrement des coord
[fx,fy] = coord(ISource, flow);

%Recallage pour v�rification.
Iout = registre( ISource, flow, 'linear' );
figure, imagesc(Iout), colormap gray
figure, imagesc(ITarget), colormap gray

end