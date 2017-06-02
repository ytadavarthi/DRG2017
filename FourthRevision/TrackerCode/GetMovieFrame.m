%Grabs a frame from a video you specify and writes it as an uncompressed
%image.
%Comes in handy when you are working with video data and need to grab a
%frame to insert as a figure in a publication
function GetMovieFrame(inputFileName, frameNumber, outputFileName)
    switch nargin
        case 1
            askInputFileName = false;
            askFrameNumber = true;
            askOutputFileName = true;
        case 2
            askInputFileName = false;
            askFrameNumber = false;
            askOutputFileName = true;
        case 3
            askInputFileName = false;
            askFrameNumber = false;
            askOutputFileName = false;
    end

    v = VideoReader(inputFileName);
    frames = read(v);
    img = frames(:, :, :, frameNumber);
    imwrite(img, outputFileName);
    
    
    
end