function [opticalFlowStruct] = lucasKanaderationMatlabToolbox(videoname)
%Cette fonction utilise le toolbox de mathlab pour calculer le flow optique
%entre les images d'une vidéo et les stocker dans ne struct contenant ainsi
%les flow optique entre chaque image

    video = frameLoader(videoname);

    vidHeight = size(video(1).cdata,1);
    vidWidth = size(video(1).cdata,2);
    s = struct('Vx',zeros(vidHeight,vidWidth,'single'), 'Vy',zeros(vidHeight,vidWidth,'single'));

    opticFlow = opticalFlowLK('NoiseThreshold',0.009);

    for k=1:length(video)
        frameRGB = video(k).cdata;
        frameGray = rgb2gray(frameRGB);
        frameGray = videoCompressionCorrection(frameGray)
        flow = estimateFlow(opticFlow, frameGray);
        
        s(k).Vx = round(flow.Vx);
        s(k).Vy = round(flow.Vy);
        

        imshow(frameRGB) 
        hold on
        plot(flow,'DecimationFactor',[1 1],'ScaleFactor',1); %decimation factor 5 5  and scale 10 by default
        hold off 
        figure;
    end
    
    opticalFlowStruct = s;
    
end

