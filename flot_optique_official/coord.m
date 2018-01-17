function [F1,F2]= coord( Imagetorec, flow)
% Recalle l'image Imagetorec avec le flot flow
% La méthode d'interpolation est définie en method.

% Taille initiale.
[x_max, y_max]= size(Imagetorec);

% Mouvement absolu. 
[X,Y]= meshgrid(1:y_max, 1:x_max);

% Mouvement absolu à partir du relatif (flow). 
F1 = nearest(max(min(flow(:,:,2)+X,y_max),1));
F2 = nearest(max(min(flow(:,:,1)+Y,x_max),1));

end

