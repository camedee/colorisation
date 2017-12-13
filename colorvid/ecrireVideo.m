function [] = ecrireVideo( fileName, colvid )
v = VideoWriter(fileName,'Uncompressed AVI');
open(v);
for im=1:size(colvid,4)
    writeVideo(v,colvid(:,:,:,im));
end
close(v);
end

