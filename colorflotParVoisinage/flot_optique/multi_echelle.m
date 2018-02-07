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
