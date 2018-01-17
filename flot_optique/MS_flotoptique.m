close all; clear all; clc
addpath datas m_func/

mex c_func/gradient.cpp -output gradient_mex_single
mex c_func/divergence.cpp -output divergence_mex_single

errmin = Inf;
Tableau_err = [];

for beta = 0.056%logspace(-1, -6, 100)
    for lambda = 0.05%logspace(-1, -6, 100)
        
        % Entrées.
        ISource = single(rgb2gray(imread('car0.png')));
        ITarget = single(rgb2gray(imread('car1.png')));
        
        % Données sur lesquelles on va travailler.
        datas = struct('IS', ISource, 'IT', ITarget,...
            'beta', single(beta), 'lambda', single(lambda));
        
        % Définit comment Obtenir la dimension des données.
        get_dim = @(struct) size(struct.IT);
        % Définit comment Remonter d'un niveau grossier à fin pour le résultat
        % qui va initialiser le niveau le plus fin.
        interpol = @(m, taille) 2*cat(3, imresize(m(:,:,1), taille),...
            imresize(m(:,:,2), taille));
        % Définit comment Passer les données d'une échelle grande à petite.
        decim = @(struct, facteur) sresize(struct, facteur );
        
        
        % Lance le code multi-échelle sur la fonction précisée.
        tic
        flow = multi_echelle(datas, get_dim,...
            @OF_TVL1, decim, interpol, 2, 0, 7);
        toc
        
        % Recallage pour vérification.
        Iout = registre( ISource, flow, 'linear' );
        figure, imagesc(Iout), colormap gray
        figure, imagesc(ISource), colormap gray
        figure, imagesc(ITarget), colormap gray
        
        err = sum((Iout(:)-ITarget(:)).^2);
        if err < errmin
            errmin = err;
            lambdamin = lambda;
            betamin = beta;
        end
        
        Tableau_err = cat(1, Tableau_err, [lambda, beta, err]);
        
    end
end

save('err.mat', 'Tableau_err')
lambdamin
betamin

% figure, imagesc(uint8(Iout)), colormap gray
% figure, imagesc(uint8(ITarget)), colormap gray
% afficher_flow( ISource, ITarget, flow )

%figure, imagesc(reshape(Tableau_err(:,3), 100, 100)), colormap gray
% A= reshape(Tableau_err(:,3), 100, 100);
% figure, plot(A(7,:))
% A= reshape(Tableau_err(:,1), 100, 100);
%A(7,6)
% figure, plot(A(7,:))
% A= reshape(Tableau_err(:,2), 100, 100);
%A(7,6)
% figure, plot(A(7,:))


