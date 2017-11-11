function [s] = frameLoader(video)
%frameLoader reads a video and returns a matlab struct containing its
%frames.
    %Construct a VideoReader object
    vidObj = VideoReader(video);
    %Determine the height and width of the frames.
    vidHeight = vidObj.Height;
    vidWidth = vidObj.Width;
    %Create a MATLAB movie structure array, s.
    s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
    %Read one frame at a time using readFrame until the end of the file is reached. Append data from each video frame to the structure array.
    k = 1;
    while hasFrame(vidObj)
        s(k).cdata = readFrame(vidObj);
        k = k+1;
    end
    
%Use image(ans(5).cdata) after use of this function to show 5th frame for
%example
    
end

