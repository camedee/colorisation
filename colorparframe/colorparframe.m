h=waitbar(0);
[s,vnb]=frameLoader('DCsmooth.avi');
[s,vma]=frameLoader('DCsmoothM.avi');

v = VideoWriter('DCtry.avi','Uncompressed AVI');
open(v);

limite=13;
i=0;
vintco=vma;
vintco(:,:,:,25)=colorvid(vnb(:,:,:,25),vma(:,:,:,25));

while i<limite
    n=24+2*i;
    vintco(:,:,:,n:n+2)=colorvid(vnb(:,:,:,n:n+2),vintco(:,:,:,n:n+2));
    i=i+1;
    writeVideo(v,vintco(:,:,:,n+1:n+2));
    waitbar(i/13,h);
end

close(v);
close(h);