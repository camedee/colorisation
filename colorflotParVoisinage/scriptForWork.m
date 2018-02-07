im = frameLoader2('DCsmoothM.avi',3);
res = voisinstemporels(im);

%creation d'une struct contenant toutes les images en nuances de gris
imgray = struct('image', zeros(size(im(1).cdata,1),size(im(1).cdata,2),'uint8'));
for i=1:length(im)
    imgray(i).image = rgb2gray(im(i).cdata);
end

x=120
y=120
imgray(2).image(x,y,1)
imgray(3).image(res(2).poste(x,y,1),res(2).poste(x,y,2),1)
imgray(1).image(res(2).ante(x,y,1),res(2).ante(x,y,2),1)