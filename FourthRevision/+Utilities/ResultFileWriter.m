function ResultFileWriter(globalStudyInfo)

    vfVideoStructure = globalStudyInfo.vfVideoStructure;
    studyCoordinates = globalStudyInfo.studyCoordinates;
    numFrames = vfVideoStructure.numFrames;
    videoFileName = vfVideoStructure.fileName;
    
    
    [a, b] = enumeration('Data.JoveLandmarks');
    numLandmarks = numel(b);
    %disp(numLandmarks)
    %disp(b)
    tableColumnLabels = {};
    tableColumnLabels{end+1} = 'FrameNumber';
    for i = 1:numLandmarks
       tableColumnLabels{end+1} = strcat(b{i}, '_x');
       tableColumnLabels{end+1} = strcat(b{i}, '_y');
    end
    
%      for i = 1:numel(tableColumnLabels)
%          disp(tableColumnLabels{i})
%         disp(class(tableColumnLabels{i})) 
%      end
     
    
    imageHeight = vfVideoStructure.resolution(1); %Height of image i.e. rows in image matrix
    
    coordinatesArray = zeros(numFrames, numLandmarks*2, 'double');
    morphoJCoordinatesArray = zeros(numFrames, numLandmarks*2, 'double');
    
    for frameNumberIterator = 1:numFrames
       for landmarkNumberIterator = 1:numLandmarks
           currentCoordinate = studyCoordinates.getCoordinate(frameNumberIterator, landmarkNumberIterator);
           if (isempty(currentCoordinate))
               currentCoordinate = [ 0 0 ];
           end
           coordinatesArray(frameNumberIterator, landmarkNumberIterator*2-1) = currentCoordinate(1);
           coordinatesArray(frameNumberIterator, landmarkNumberIterator*2) = currentCoordinate(2);
           
           morphoJCoordinatesArray(frameNumberIterator, landmarkNumberIterator*2-1) = currentCoordinate(1);
           morphoJCoordinatesArray(frameNumberIterator, landmarkNumberIterator*2) = imageHeight - currentCoordinate(2) + 1;
       end        
    end
    
    coordinatesArray = horzcat((1:1:numFrames)', coordinatesArray);
    morphoJCoordinatesArray= horzcat((1:1:numFrames)', morphoJCoordinatesArray);
    

   
    t1 = array2table(coordinatesArray, 'VariableNames', tableColumnLabels);
    t2 = array2table(morphoJCoordinatesArray, 'VariableNames', tableColumnLabels);
    
    fullVideoFileName = vfVideoStructure.fileName;
    [pathString, name, ~] = fileparts(fullVideoFileName);
    fullResultFileName = fullfile(pathString, strcat(name, '.txt'));
    Utilities.CustomPrinters.printInfo(sprintf('Writing annotation results to %s', fullResultFileName));
    writetable(t1, fullResultFileName, 'Delimiter', '\t');
    Utilities.CustomPrinters.printInfo(sprintf('Done writing results'));
    
    morphoJFileName = fullfile(pathString, strcat(name, '_morphoj_.txt'));
    Utilities.CustomPrinters.printInfo(sprintf('Writing MorphoJ annotation results to %s', morphoJFileName));
    writetable(t2, morphoJFileName, 'Delimiter', '\t');
    Utilities.CustomPrinters.printInfo(sprintf('Done writing results'));
    
    %Now write the tracking status in a separate MATLAB file
    trackingResultFullFileName = fullfile(pathString, strcat(name, '_tracking_status.mat'));
    savedTrackedStatus = globalStudyInfo.studyCoordinates.trackedStatus;
    save(trackingResultFullFileName, 'savedTrackedStatus');
    

end