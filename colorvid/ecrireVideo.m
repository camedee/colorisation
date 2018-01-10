function [] = ecrireVideo( fileName, colvid )
v = VideoWriter(fileName,'Uncompressed AVI');
open(v);
writeVideo(v,colvid);
close(v);
end

