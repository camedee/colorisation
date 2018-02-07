function vt = voisinstemporels(loadedFrames)

%%these builds are for de MS flotoptiqueLK coord func function
mex  -largeArrayDims flot_optique/c_func/gradient.cpp -output gradient_mex_single
mex  -largeArrayDims flot_optique/c_func/divergence.cpp -output divergence_mex_single
mex  -largeArrayDims flot_optique/c_func/lk.cpp -output lk_mex

%%rend une struct comprennant tous les voisins temporels(frame d'avant et
%%frame d'après) de chaque pixel de tous les frames
    %%gradeurs et var globales
    vidHeight = size(loadedFrames(1).cdata,1);
    vidWidth = size(loadedFrames(1).cdata,2);
    
    %%creation d'une struct contenant toutes les images en nuances de gris
    grayloadedFrames = struct('image', zeros(vidHeight,vidWidth,'uint8'));
    for i=1:length(loadedFrames)
        grayloadedFrames(i).image = rgb2gray(loadedFrames(i).cdata);
    end
    
    %%creation de la struct des coord des voisins temporels
    vt = struct('ante',zeros(vidHeight,vidWidth,2,'uint8'),'poste',zeros(vidHeight,vidWidth,2,'uint8'));
    %traitement de la première et dernière frame (premier n'a pas ante et dernière n'a pas poste)
     [vt(1).poste(:,:,1), vt(1).poste(:,:,2)] = MS_flotoptiqueLK_coord_func(grayloadedFrames(1).image, grayloadedFrames(2).image);
     [vt(length(grayloadedFrames)).ante(:,:,1), vt(length(grayloadedFrames)).ante(:,:,2)] = MS_flotoptiqueLK_coord_func(grayloadedFrames(length(grayloadedFrames)).image, grayloadedFrames(length(grayloadedFrames)-1).image);
    %traitement des autres frames
    for k=2:length(grayloadedFrames)-1
        %remplissge des coordonnées du pixel actuel dans frame suivante
        [vt(k).poste(:,:,1), vt(k).poste(:,:,2)] = MS_flotoptiqueLK_coord_func(grayloadedFrames(k).image, grayloadedFrames(k+1).image); 
        %remplissge des coordonnées du pixel actuel dans frame précédente
        [vt(k).ante(:,:,1), vt(k).ante(:,:,2)] = MS_flotoptiqueLK_coord_func(grayloadedFrames(k).image, grayloadedFrames(k-1).image);
    end 
end