%Does linear interpolation for now
function interpolator(handles, startFrame, endFrame)

    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    currentlyTrackedLandmark = globalStudyInfo.currentlyTrackedLandmark;
    
    frameDistance = endFrame - startFrame;
    numInterpolatedFrames = frameDistance - 1;
    
    %return if there is nothing to interpolate
    if (numInterpolatedFrames < 1)
        
        return;        
    end
    
    %Get the coordinates frm here
    startCoordinates = globalStudyInfo.studyCoordinates.getCoordinate(startFrame, currentlyTrackedLandmark);
    endCoordinates = globalStudyInfo.studyCoordinates.getCoordinate(endFrame, currentlyTrackedLandmark);
    
    
    
    %calculate the slope
    slope = (endCoordinates - startCoordinates) / frameDistance;
   
    %Calculate the coordinates for the intermediate frames
    for i = 1:numInterpolatedFrames
       newCoordinate = startCoordinates + slope * i;
       globalStudyInfo.studyCoordinates.setCoordinate(startFrame + i, currentlyTrackedLandmark, newCoordinate);       
    end

end