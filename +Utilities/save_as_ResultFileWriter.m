function save_as_ResultFileWriter(globalStudyInfo)

    vfVideoStructure = globalStudyInfo.vfVideoStructure;
    studyCoordinates = globalStudyInfo.studyCoordinates;
    numFrames = vfVideoStructure.numFrames;
    videoFileName = vfVideoStructure.fileName;
    frameRate = vfVideoStructure.frameRate;
    
    
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
    %fullResultFileName = fullfile(pathString, strcat(name, '.txt'));
    
    [FileName,PathName] = uiputfile({'*.*','All Files' },'Save Text Files',...
          pathString);
    fullResultFileName = fullfile(PathName,[FileName,'.txt']);
    Utilities.CustomPrinters.printInfo(sprintf('Writing annotation results to %s', fullResultFileName));
    
    %add kinematics frame numbers
%     tableColumnLabels2 = {'hold_position' 'ramus_mandible' 'hyoid_burst' 'ues_closure' 'at_rest'}
%     t3 = array2table(kinematicsFrameNumberArray, 'VariableNames', tableColumnLabels2);
%     fullResultFileName = fullfile(pathString, strcat(name, '2.txt'));
%     writetable(t3, fullResultFileName, 'Delimiter', '\t');

    % kinematics frame number array for timing calculations
    [m, n] = size(t2);
    
    cell1 = table2cell(t2);
    
    %Num Columns for Frame Number Information
    phaseFramesNumColumns = 25;
    
    cell2 = cell(1,n);
    cell2(1, 1:phaseFramesNumColumns) = {'start_frame' 'hold_position' ...
                                        'ramus_mandible' 'hyoid_burst' ...
                                        'ues_closure' 'at_rest' ...
                                        'end_frame' 'si_point1_x' ...
                                        'si_point1_y' 'si_point2_x' ...
                                        'si_point2_y' 'pixelspercm' ...
                                        'frameRate' 'lvc_onset'...
                                        'lvc_offset' 'laryngeal_jump' ... 
                                        'ues_opening' 'uesd_dist' ...
                                        'nrrs_valres_area' 'nrrs_totalval_area'...
                                        'nrrs_pirires_area' 'nrrs_totalpiri_area' ...
                                        'pcr_min_area' 'pcr_max_area' 'pas';
};
    
    cell3 = cell(1,n);
    
    %if calibration points were not annotated in VFTracker, then
    %globalStudyInfo.si_point1 and globalStudyInfo.si_point1 are blank, and in
    %the next line, an error is given when MATLAB tries to index these
    %blank vectors. This if-statement will turn globalStudyInfo.si_point1/2
    %into a cell matrix to avoid this problem.
    if isempty(globalStudyInfo.si_point1) || isempty(globalStudyInfo.si_point2)
        globalStudyInfo.si_point1 = {[],[]};
        globalStudyInfo.si_point2 = {[],[]};
    else
        globalStudyInfo.si_point1 = {globalStudyInfo.si_point1(1),globalStudyInfo.si_point1(2)};
        globalStudyInfo.si_point2 = {globalStudyInfo.si_point2(1),globalStudyInfo.si_point2(2)};
    end
    cell3(1, 1:phaseFramesNumColumns) =   {globalStudyInfo.start_frame,   ...
                        globalStudyInfo.hold_position, ...
                        globalStudyInfo.ramus_mandible,...
                        globalStudyInfo.hyoid_burst,   ...
                        globalStudyInfo.ues_closure,   ...
                        globalStudyInfo.at_rest,       ...
                        globalStudyInfo.end_frame,     ...
                        globalStudyInfo.si_point1{1},     ...
                        globalStudyInfo.si_point1{2},     ...
                        globalStudyInfo.si_point2{1},     ...
                        globalStudyInfo.si_point2{2},     ...
                        globalStudyInfo.pixelspercm,   ...
                        frameRate, ...
                        globalStudyInfo.lvc_onset,       ...
                        globalStudyInfo.lvc_offset, ...
                        globalStudyInfo.laryngeal_jump, ...
                        globalStudyInfo.ues_opening, ...
                        globalStudyInfo.uesd_dist, ...     
                        globalStudyInfo.nrrs_valres_area, ...
                        globalStudyInfo.nrrs_totalval_area, ...
                        globalStudyInfo.nrrs_pirires_area , ...
                        globalStudyInfo.nrrs_totalpiri_area, ...
                        globalStudyInfo.pcr_min_area    , ...
                        globalStudyInfo.pcr_max_area, ...
                        globalStudyInfo.pas};
    
    kinematics_cell = [cell2; cell3];
    totalKinematicsTable = cell2table(kinematics_cell);

%     totalCell = [cell2; cell3; tableColumnLabels; cell1];
%     totalTable = cell2table(totalCell);
    
    totalCell = [cell2; cell3; tableColumnLabels; cell1];
    totalTable = cell2table(totalCell);
    
    %writing third file instead of concatenating kinematics frame numbers
%     kinematicsFileName = fullfile(pathString, strcat(name, '_kinematics_.txt'));
%     writetable(totalKinematicsTable, kinematicsFileName, 'Delimiter', '\t', 'WriteVariableNames', false);
%     Utilities.CustomPrinters.printInfo(sprintf('Done writing Kinematics results'));

    
    %adding coordinate
    %uncomment to get concatenated file
    %writetable(totalTable, fullResultFileName, 'Delimiter', '\t', 'WriteVariableNames', false);

    %comment
    writetable(t1, fullResultFileName, 'Delimiter', '\t');
    Utilities.CustomPrinters.printInfo(sprintf('Done writing results'));
    
    morphoJFileName = fullfile(PathName,[FileName,'_morphoj_.txt']);%fullfile(pathString, strcat(name, '_morphoj_.txt'));
    Utilities.CustomPrinters.printInfo(sprintf('Writing MorphoJ annotation results to %s', morphoJFileName));
    writetable(totalTable, morphoJFileName, 'Delimiter', '\t', 'WriteVariableNames', false);
    %writetable(t2, morphoJFileName, 'Delimiter', '\t');
    
    
    %Now write the tracking status in a separate MATLAB file
    trackingResultFullFileName = fullfile(PathName,[FileName,'_tracking_status.mat']);%fullfile(pathString, strcat(name, '_tracking_status.mat'));
    savedTrackedStatus = globalStudyInfo.studyCoordinates.trackedStatus;
    save(trackingResultFullFileName, 'savedTrackedStatus');
    
    Utilities.CustomPrinters.printInfo(sprintf('Done writing results'));
end