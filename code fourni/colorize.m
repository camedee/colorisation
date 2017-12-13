
g_name='example.bmp';
c_name='example_marked.bmp';
out_name='example_res.bmp';

%set solver=1 to use a multi-grid solver 
%and solver=2 to use an exact matlab "\" solver
solver=2; 

gI=double(imread(g_name))/255; %double entre 0 et 1
cI=double(imread(c_name))/255; %idem
colorIm=(sum(abs(gI-cI),3)>0.01); %matrice marquant les pixels sur les quels on a rajout de la couleur par 1 et tous les autres par 0
colorIm=double(colorIm);

sgI=rgb2ntsc(gI); %passage en espace YIQ (equivalant YUV de matlab)
scI=rgb2ntsc(cI); %idem
   
ntscIm=double(zeros(size(gI,1),size(gI,2),3)); %matrice de 3 dimensions de taille (hauteur image, largeur image, 3 car espace YIQ)
ntscIm(:,:,1)=sgI(:,:,1); %NtscIM prend luminosité de sgI pour chaque pixel
ntscIm(:,:,2)=scI(:,:,2); %...I
ntscIm(:,:,3)=scI(:,:,3); %...Q

% enlève certains pixels de l'image, innutile pour résolution mathlab, sera peutêtre nécessaire pour solveur C++ 
% max_d=floor(log(min(size(ntscIm,1),size(ntscIm,2)))/log(2)-2);
% iu=floor(size(ntscIm,1)/(2^(max_d-1)))*(2^(max_d-1));
% ju=floor(size(ntscIm,2)/(2^(max_d-1)))*(2^(max_d-1));
% id=1; jd=1;
% colorIm=colorIm(id:iu,jd:ju,:);
% ntscIm=ntscIm(id:iu,jd:ju,:);

if (solver==1)
  nI=getVolColor(colorIm,ntscIm,[],[],[],[],5,1);
  nI=ntsc2rgb(nI);
else
  nI=getColorExact(colorIm,ntscIm); % appeler fonction avec arguments : matrice indiquant points colorés; matrice en 3 dimensions ntscIm
end

figure, imshow(nI)

imwrite(nI,out_name)
   
  

%Reminder: mex cmd
%mex -O getVolColor.cpp fmg.cpp mg.cpp  tensor2d.cpp  tensor3d.cpp
