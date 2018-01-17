function vt = voisinstemporels(loadedFrames)
%%rend une struct comprennant tous les voisins temporels(frame d'avant et
%%frame d'après) de chaque pixel de tous les frames
    vidHeight = size(loadedFrames(1).cdata,1);
    vidWidth = size(loadedFrames(1).cdata,2);
    
    vt = struct('antecedant',zeros(vidHeight,vidWidth,2,'uint8'),'posterieur',zeros(vidHeight,vidWidth,2,'uint8'));

    for k=1:length(loadedFrames)%attention opitmisation a fiare ici en evitant de retransformer deux frames en rgb a chaque itération
        grayFrame = rgb2gray(loadedFrames(k).cdata);
        M_SflotoptiqueLK_coord %%a transformer en fonction pour que ça marche
    end
    
            
    %frameRGB = bruteFrames(k).cdata;
    %greyFrames(k).data = rgb2gray(frameRGB);
   
end