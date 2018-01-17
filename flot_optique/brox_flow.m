function [ flow ] = brox_flow( lt , ls )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
addpath('/home/fpierre/Travail/codes/video_colorization/optical_flow/brox/Flow/brox_zip')

 [F1, F2] = optic_flow_brox(uint8(repmat(lt, 1,1,3)), uint8(repmat(ls, 1,1,3)));

 flow = cat(3, F1, F2);

end

