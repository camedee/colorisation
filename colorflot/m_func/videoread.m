function Video = videoread( name )
% lit un fichier video
% Video : hauteur x largeur x canal x frames


xyloObj = VideoReader(name);

nFrames = xyloObj.NumberOfFrames;

Video=read(xyloObj,1);

for k = 2 : nFrames
    Video=cat(4, Video, read(xyloObj,k));
end

end

