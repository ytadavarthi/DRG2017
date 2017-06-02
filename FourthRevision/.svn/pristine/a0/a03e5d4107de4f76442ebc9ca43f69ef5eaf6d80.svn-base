function VideoTrimmer(fullInputVideoFileName, startFrame, endFrame, result_suffix)
    [pathStr, name, ext] = fileparts(fullInputVideoFileName);
    resultFileName = fullfile(pathStr, strcat(name, '_', result_suffix, '.avi'));
    
    v = vision.VideoFileReader(fullInputVideoFileName);
    w = vision.VideoFileWriter(resultFileName);
    
    frameCounter = 0;
    while (~isDone(v))
        frameCounter = frameCounter + 1;
        img = step(v);
        if (frameCounter >= startFrame && frameCounter <= endFrame)
           step(w, img); 
        end
    end
end