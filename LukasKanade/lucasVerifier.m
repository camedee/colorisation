bruteFrames = frameLoader('viptraffic.avi');
vidHeight = size(bruteFrames(1).cdata,1);
vidWidth = size(bruteFrames(1).cdata,2);
greyFrames = struct('data',zeros(vidHeight,vidWidth,'single'));
 for k=9:11
        frameRGB = bruteFrames(k).cdata;
        greyFrames(k).data = rgb2gray(frameRGB);
 end
lucas = lucasKanaderationMatlabToolbox('viptraffic.avi', 9, 11);
%%
current = double(greyFrames(10).data);
next = double(greyFrames(11).data);
[X, Y] = meshgrid(1:vidWidth, 1:vidHeight);
Vx = double(lucas(11).Vx);
Vy = double(lucas(11).Vy);
supposedcurrent = interp2(X,Y, next, X-Vx, Y-Vy);
%%

Result =current - supposedcurrent
figure, imagesc(current), colormap gray
figure, imagesc(supposedcurrent), colormap gray
figure, imagesc(next), colormap gray

