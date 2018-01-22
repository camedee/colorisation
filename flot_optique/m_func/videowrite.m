function  videowrite(G, nom)
% enregistre une video au format uncompressed avi

writerObj = VideoWriter(nom,'Uncompressed AVI');
open(writerObj);

for i=1:size(G,4)
    writeVideo(writerObj,uint8(G(:,:,:,i)));
end

close(writerObj);

end

