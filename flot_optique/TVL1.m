function carte = TVL1( ITarget, ISource )

% Entrées.
ISource = single(ISource);
ITarget = single(ITarget);

% Données sur lesquelles on va travailler.
datas = struct('IS', ISource, 'IT', ITarget,...
    'beta', single(0.056), 'lambda', single(0.05));

% Définit comment Obtenir la dimension des données.
get_dim = @(struct) size(struct.IT);
% Définit comment Remonter d'un niveau grossier à fin pour le résultat
% qui va initialiser le niveau le plus fin.
interpol = @(m, taille) 2*cat(3, imresize(m(:,:,1), taille),...
    imresize(m(:,:,2), taille));
% Définit comment Passer les données d'une échelle grande à petite.
decim = @(struct, facteur) sresize(struct, facteur );

% Lance le code multi-échelle sur la fonction précisée.
flow = multi_echelle(datas, get_dim,...
    @OF_TVL1, decim, interpol, 2, 0, 7);

% extraction carte
carte = flow;%flow2carte(flow); 

end

function resultat = multi_echelle(datas_in, get_dim,...
    fonction_de_traitement, fonction_de_decimation,...
    fonction_d_interpolation, facteur_de_decimation,...
    niveau_courant, niveau_maximal)
% datas_in : donnees du probleme
% dim : accesseur extraction de la dimension du probleme
% proc : procedure de traitement (datas, init opt)retourne datas
% dec : procedure de decimation (datas, facteur)
% proc : procedure de traitement (datas, init opt de type resultat)
% intepol : procedure d interpolation (datas)
% nc niveau courant
% nm niveau maximal.

if niveau_courant < niveau_maximal
    % Retenir la dimension de départ.
    dimension_initiale= get_dim(datas_in);
    % Décimer les données pour une échelle plus grossière.
    datas_decimee= fonction_de_decimation(datas_in, facteur_de_decimation);
    % Par récurence, lancer sur l'échelle grossière. 
    res_grossier = multi_echelle(datas_decimee,...
                       get_dim, fonction_de_traitement,...
                       fonction_de_decimation,...
                       fonction_d_interpolation, facteur_de_decimation,...
                       niveau_courant+1, niveau_maximal);
    % Interpoler le résultat à partir de l'échelle grossière vers l'échelle
    % plus fine en utilisant la dimension précédemment retenue.
    interpolee= fonction_d_interpolation(res_grossier, dimension_initiale);
    % Traiter l'échelle fine en initialisant avec l'interpolée du résultat
    % grossier. 
    resultat = fonction_de_traitement(datas_in, 'init', interpolee);
else
    % Echelle la plus grossière : traitement direct. 
    resultat = fonction_de_traitement(datas_in);
end

end

function data_out = sresize( data_in,  fact)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

data_out.IS = imresize(data_in.IS, 1/fact);
data_out.IT = imresize(data_in.IT, 1/fact);
data_out.lambda = data_in.lambda;
data_out.beta = data_in.beta;

end


function output = OF_TVL1(ddp, varargin )
% datas doit contenir ISOurce, ITarget, lambda et beta.

p = inputParser;
addRequired(p,'ddp');
parse(p,ddp);
addOptional(p,'init',zeros(size(ddp.IS, 1), size(ddp.IS, 2), 2));
parse(p,ddp,varargin{:});
init = p.Results.init;
v0=single(init);

% input
ISource = ddp.IS;
ITarget = ddp.IT;
lambda = ddp.lambda;%single(0.05);
beta = ddp.beta;%single(0.0001);

% Initialisation. 
U = cat(3, zeros(size(ITarget), 'single'), v0);

% Recalage de ISource pour considérer que le déplacement est petit. 
Itarget_recaled = registre(ISource, v0, 'linear');

% Gradient temporel.
It = Itarget_recaled - ITarget ;

% Gradient spatial. 
GI = gradient_diff_centree(Itarget_recaled);

% Précalcul des valeurs utiles. 
A= cat(3, beta*ones(size(ITarget)), GI);
NA = sum(A.^2, 3);

% ****************a régler****************

sigma= single(0.1);
tau= single(0.5 / (24 * sigma));

ITT = 2000;
% run

Z= single(gradient_mex_single(single(U)));

U_bar = U;


residu0 = length(U(:)) ;
residu = residu0; 
c=0;

Precalcul_rho = -sum(GI.*v0, 3) + It;

while residu / residu0 > 1e-6 && c < ITT
    
    tilde_Z = Z + sigma *  gradient_mex_single(U_bar);
    Z(:,:,1:2) = PB_matlab(tilde_Z(:,:,1:2));
    Z(:,:,3:6) = PB_matlab(tilde_Z(:,:,3:6));
        
    U_ans=U;
    
    tilde_U = U + tau * divergence_mex_single(Z) ;
    rho = Precalcul_rho + sum(GI.*tilde_U(:,:,2:3), 3) ...
                        + beta * tilde_U(:,:,1) ;
    Rrho = repmat(rho, 1,1,3);
    U = tilde_U +...
        ( tau*lambda*A).*repmat((rho < -tau*lambda*NA), 1, 1, 3) + ...
        (-tau*lambda*A).*repmat((rho >  tau*lambda*NA), 1, 1, 3) + ...
        (-Rrho.* A ./repmat(NA,1,1,3)).*repmat((abs(rho) <= tau*lambda*NA), 1, 1, 3);
    
    theta = 1 / sqrt(1+2*tau*(lambda/2));
    tau = theta*tau; sigma = sigma / theta;
    
    U_bar = U + theta * (U - U_ans);
    
    residu = sum((U(:)-U_ans(:)).^2) ;
    c=c+1;
    
end

output =  U(:,:,2:3); 

end

function [Zl] = PB_matlab( Z )
% Projection sur l'ensemble B.
% Justifie par la theorie.

R= sqrt(sum(Z.^2, 3));

R= repmat(R, [1,1,size(Z,3)]);
Zl= Z ./ max(1, R);
Zl(isnan(Zl))=0;

end

function G = gradient_diff_centree( U )

G = zeros(size(U,1), size(U,2), 2, 'like', U);
G(2:end-1,:,1) = (U(3:end, :) - U(1:end-2, :))/2;
G(:,2:end-1,2) = (U(:, 3:end) - U(:, 1:end-2))/2;

end

function Iout = registre( Imagetorec, flow, method )
% Recalle l'image Imagetorec avec le flot flow
% La méthode d'interpolation est définie en method.

% Taille initiale.
[x_max, y_max]= size(Imagetorec);

% Mouvement absolu. 
[X,Y]= meshgrid(1:y_max, 1:x_max);

% Mouvement absolu à partir du relatif (flow). 
F1 = max(min(flow(:,:,2)+X,y_max),1);
F2 = max(min(flow(:,:,1)+Y,x_max),1);

% Interpolation. 
Iout = interp2(X,Y,Imagetorec, F1, F2, method);

end

function carte = flow2carte( flow )

[x_max, y_max,~]= size(flow);

[X,Y]= meshgrid(1:y_max, 1:x_max);

F1 = max( min( flow(:,:,1) + Y, x_max), 1);
F2 = max( min( flow(:,:,2) + X, y_max), 1);

carte = sub2ind([x_max, y_max], floor(F1), floor(F2) );

end


