video = frameLoader('viptraffic.avi')

opticFlow = opticalFlowLK('NoiseThreshold',0.009);

for k=1:length(video)/6
    frameRGB = video(k).cdata
    frameGray = rgb2gray(frameRGB);
    flow = estimateFlow(opticFlow, frameGray);
    
    imshow(frameRGB) 
    hold on
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',10)
    hold off 
    figure;
end