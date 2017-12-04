function [greyOutput] = videoCompressionCorrection(greyInput)
%fonctino pour corriger problemes de compression des videos
greyOutput = (greyInput > 100).*255;
end

