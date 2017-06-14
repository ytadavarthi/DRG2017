function Compiler
    %[fileNameMinusExt pathName] = uigetfile({'.txt'},'MultiSelect','on');
    
    %[pathName fileName ext] = fileparts([pathName fileNameMinusExt{1}]);
    

    fileNames = {'Norm030_Tsp_Pud_morphoj_' 'Norm072_Tsp_Pud_morphoj_' 'Norm072_Tsp_Thn_morphoj_'};
    pathName = '/Users/yasasvi/Documents/DRG_2017_git/Compiler/';
%     pathName = 'C:\Users\pouri\OneDrive\Documents\MCG\research\MATLAB\Tracker\DRG2017\Compiler\';

    
    file = [pathName fileNames{1} '.txt'];
    cell = table2cell(readtable(file,'delimiter','\t','ReadVariableNames',false));
    
    %make compiled files for coordinates, classifiers, and kinematics
    for i = 1:length(fileNames)
        file = [pathName fileNames{i} '.txt'];
        cell = table2cell(readtable(file,'delimiter','\t','ReadVariableNames',false));
                      
        coordinateData{i} = cell(3:end,:);
                
        %remove all extraneous cells in classifierData
        keep = ~cellfun(@isempty,cell(1,:));
        classifierData{i} = cell([1,2],keep);
        
    end
    dataStruct = struct('coordinateData',coordinateData,'classifierData',classifierData);
    
    finalCell = compile_coordinateData(dataStruct,fileNames);
    disp('Done writing combined coordinates file');

    compile_classifierData(dataStruct,fileNames,finalCell);
    disp('Done writing combined classifier file');

    compile_kinematicsData(dataStruct, fileNames);
    disp('Done writing combined kinematics file');
end

function finalCell = compile_coordinateData(dataStruct,fileNames)
    %initialize finalCell
    finalCell = dataStruct(1).coordinateData(1,:);
    finalCell{1,1} = 'Swallow ID';
    
    %for the number of videos
    for i = 1:length(dataStruct)
        
        %extract data from structure
        classifierData = dataStruct(i).classifierData;
        coordinateData = dataStruct(i).coordinateData;
        
        %remove extraneous frames (rows) if first and last frame are indicated:
        if isempty(classifierData{2,1}) && isempty(classifierData{2,7})
            
        elseif isempty(classifierData{2,1}) && ~isempty(classifierData{2,7})
            firstFrame = 2;
            lastFrame = str2double(classifierData{2,7});
            relevantCoordinates = coordinateData(firstFrame+1:lastFrame+1,:); 
            columnLabels = coordinateData(1,:);
            coordinateData = vertcat(columnLabels,relevantCoordinates);
            
        elseif isempty(classifierData{2,7}) && ~isempty(classifierData{2,1})
            firstFrame = str2double(classifierData{2,1});
            relevantCoordinates = coordinateData(firstFrame+1:end,:); 
            columnLabels = coordinateData(1,:);
            coordinateData = vertcat(columnLabels,relevantCoordinates);
            
        else
            firstFrame = str2double(classifierData{2,1});
            lastFrame = str2double(classifierData{2,7});
            relevantCoordinates = coordinateData(firstFrame+1:lastFrame+1,:); 
            columnLabels = coordinateData(1,:);
            coordinateData = vertcat(columnLabels,relevantCoordinates);
        end
        
 
        [m n k] = size(coordinateData);
            
                    
        %Rename ID Column
        for j = 1:m-1
            coordinateData{j+1,1} = [fileNames{i} num2str(j)];
        end
        
        %Find all unAnnotated Columns
        unAnnotated = [false];
        for j = 2:n
            %unAnnotated = [unAnnotated all(diff(sort(str2double(coordinateData(2:end,j)))) == 0)];
            unAnnotated = [unAnnotated all(str2double(coordinateData(2:end,j)) == 0)];
            if any(j == 3:2:n) && unAnnotated(j-1) == true
                unAnnotated(j) = true;
            end
        end
        
        %remove unAnnotated Columns, including column headers
        coordinateData = coordinateData(2:end,~unAnnotated);
        if i == 1
            finalCell = finalCell(~unAnnotated);
        end
        
        %make sure same number of landmarks were annotated
        previousSize = size(finalCell);
        currentSize = size(coordinateData);
        if previousSize(2) ~= currentSize(2)
            error('Inconsistent number of landmarks were annotated!')
        end
        
        
        %create finalCell
        finalCell = [finalCell;coordinateData];
       
    end
    
    %remove extra columns
    
    
    finalTable = cell2table(finalCell);
    formatOut = 'dd-mm-yy HH-MM AM';
    date = datestr(now,formatOut);
    writetable(finalTable,['coordinates_' date '.txt'], 'Delimiter', '\t', 'WriteVariableNames', false);
end

function compile_classifierData(dataStruct, fileNames, finalCell)
    
    %Create GUI for use-input independent variables
    [~, outputData] = GUI(fileNames);

    %create first column from compile_coordinateData function
    firstColumn = finalCell(:,1);
%     
    %[m n] = size(finalCell);
    secondColumn = {};
    classifierColumns = {};
    for i = 1:length(dataStruct)
        %extract data from structure
        classifierData = dataStruct(i).classifierData;
        coordinateData = dataStruct(i).coordinateData;
        
        [m n] = size(coordinateData);
       
        
        %create struct s that includes each classifier. i.e. s.start_frame
        %outputs start frame value.
        for j = 1:length(dataStruct(i).classifierData(1,:))
            s.(classifierData{1,j}) = str2double(classifierData{2,j});
            if isnan(s.(classifierData{1,j}))
                s.(classifierData{1,j}) = [];
            end
        end
        
        %if no start frame, pick first frame as start frame. if no end
        %frame, pick last frame as end frame
        if isempty(s.start_frame)
            s.start_frame = 1;
        end
        if isempty(s.end_frame)
            s.end_frame = m-1;
        end
        
        %calculate which frames are in each phase.
        Frames_preO  = s.start_frame:(s.hold_position-1);
        Frames_O     = s.hold_position:(s.hyoid_burst-1);
        Frames_P     = s.hyoid_burst:(s.ues_closure-1);
        Frames_E     = s.ues_closure:s.at_rest;
        Frames_postE = (s.at_rest+1):s.end_frame;
        
        if isempty(s.at_rest) || s.at_rest > s.end_frame
            Frames_E = s.ues_closure:s.end_frame;
        end
        
        swallowPhaseData = cell(m-1,1);
        swallowPhaseData(Frames_preO)  = {'Pre-Oral Transport'};
        swallowPhaseData(Frames_O)     = {'Oral Transport'};
        swallowPhaseData(Frames_P)     = {'Pharyngeal Stage'};
        swallowPhaseData(Frames_E)     = {'Esophageal Stage'};
        swallowPhaseData(Frames_postE) = {'Post-Esophageal Stage'};
        
        %select only frames within start-end frame
        swallowPhaseData_no_blanks = swallowPhaseData(s.start_frame:s.end_frame);
        
        %create second column
        secondColumn = [secondColumn;swallowPhaseData_no_blanks];
        
        %finds the independent variables inputted by user into uitable and
        %repeats them for every frame, creating extra long column.
        ind_vars = outputData(1+i,2:end);
        %[m n] = size(coordinateData);
        long_col_of_ind_vars = repmat(ind_vars,[length(swallowPhaseData_no_blanks),1]);
        classifierColumns = [classifierColumns;long_col_of_ind_vars];
    end
  
    %add 'Swallow Phase' to top of second column
    secondColumn = [{'Swallow Stage'}; secondColumn];
    
    %add classifier titles to classifierColumns
    for i = 2:length(outputData(1,:))
        title = outputData{1,i};
        if strcmp(title(1:9), '<html><b>')
            outputData{1,i} = title(length('<html><b>')+1:end-length('</b><html>'));
        end
    end
    classifierColumns = [outputData(1,2:end);classifierColumns];
    
    finalTable = cell2table([firstColumn secondColumn classifierColumns]);
    
    %write table with correct filename
    formatOut = 'dd-mm-yy HH-MM AM';
    date = datestr(now,formatOut);
    writetable(finalTable,['classifiers_' date '.txt'], 'Delimiter', '\t', 'WriteVariableNames', false);
        
end

%Gets all kinematic values for all files and stores in a cell for output
function compile_kinematicsData(dataStruct, fileNames)
    lengthDataStruct = length(dataStruct);
    numKinematicsFunctions = 17;
    
    kinematicsArray = cell(lengthDataStruct+1, numKinematicsFunctions+1);
    kinematicsArray(1, 1:numKinematicsFunctions+1) = ...
        {'FileName',    ...
        'ahm- AnteriorHyoidMovement',    ...
        'shm- SuperiorHyoidMovement',    ...
        'hyExMand- hyoidExcursionToMandible',   ...
        'hyExC4- hyoidExcursionToC4',   ...
        'hyExVert- hyoidExcursionToVertebrae',   ...
        'alm- AnteriorLaryngealMovement',       ...
        'slm- SuperiorLaryngealMovement',     ...
        'hla- HyolaryngealAppx',     ...
        'le- LaryngealElevation',     ...
        'ps- PharyngealShortening',     ...
        'botrr- BaseofTongueRetractionRatio',     ...
        'hybotex- HyoidBaseofTongueExcursion',    ...
        'ott- OralTransitTime',    ...
        'std- StageTransitionDuration',    ...
        'ptt- PharyngealTransitTime',    ...
        'optt- OropharyngealTransitTime',    ...
        'pdt- PharyngealDelayTime'};
    
    for i = 1:lengthDataStruct
    
        doubleCell = points2doubleSansLabels(dataStruct, i);
        phasesCell = frames2doubleSansLabels(dataStruct, i);

        ahm = anteriorHyoidMovement(doubleCell);
        shm = superiorHyoidMovement(doubleCell);
        hyExMand = hyoidExcursionToMandible(doubleCell);
        hyExC4 = hyoidExcursionToC4(doubleCell);
        hyExVert = hyoidExcursionToVertebrae(doubleCell);
        alm = antLargyngealMovement(doubleCell);
        slm = supLargyngealMovement(doubleCell);
        hla = hyolaryngealApproximation(doubleCell);
        le = laryngealElevation(doubleCell);
        ps = pharyngealShortening(doubleCell);
        botrr = baseOfTongueRetractionRatio(doubleCell);
        hybotex = hyoidbotexcursionratio(doubleCell);
        
        %transit times
        ott = oralTransitTime(phasesCell);
        std = stageTransitionDuration(phasesCell);
        ptt = pharyngealTransitTime(phasesCell);
        optt = oropharyngealTransitTime(phasesCell);
        %????? 1st jump larynx - if hyoid then it would be the same as stageTransitionDuration????%
        pdt = pharyngealDelayTime(phasesCell);
        
        kinematicsArray(i+1, 1:numKinematicsFunctions+1) = {strcat(fileNames(i), '.txt'),...
                                                ahm,    ...
                                                shm,    ...
                                                hyExMand,   ...
                                                hyExC4,   ...
                                                hyExVert,   ...
                                                alm,       ...
                                                slm,     ...
                                                hla,     ...
                                                le,     ...
                                                ps,     ...
                                                botrr,     ...
                                                hybotex,    ...
                                                ott,    ...
                                                std,    ...
                                                ptt,    ...
                                                optt,    ...
                                                pdt};
        
    end
    
    %write to a file
    total_kinematics_table = cell2table(kinematicsArray);
    formatOut = 'dd-mm-yy HH-MM AM';
    date = datestr(now,formatOut);
    writetable(total_kinematics_table,['kinematics_' date '.txt'], 'Delimiter', '\t', 'WriteVariableNames', false);
end

%Gets Coordinates from DataStruct and converts into cell without labels
function doubleCell = points2doubleSansLabels(dataStruct, videoIndex)
    doubleCell = cellfun(@str2double,dataStruct(videoIndex).coordinateData(2:end,2:end));
end

%Gets Frames from DataStruct and converts into cell without labels
function phaseFramesCell = frames2doubleSansLabels(dataStruct, videoIndex)
    phaseFramesCell = cellfun(@str2double,dataStruct(videoIndex).classifierData(2:end,1:end));
end

%Anterior Hyoid Movement; Needs C1, C4, Hyoid
function ahm = anteriorHyoidMovement(doubleCell)
    
    doubleCellSize = size(doubleCell);
    allMovements = [];
    
    allFarresMovements = [];
    allAngles = [];
    
    allc1hylengths = [];

    for i = 1:doubleCellSize(1)
        c1x = doubleCell(i,5);
        c1y = doubleCell(i,6);
        c4x = doubleCell(i,9);
        c4y = doubleCell(i,10);
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);

        c1c4_points = [c1x, c1y; c4x, c4y];
        c1hy_points = [c1x, c1y; hyx, hyy];
        c4hy_points = [c4x, c4y; hyx, hyy];

        c1c4_dist = pdist(c1c4_points,'euclidean');
        c1hy_dist = pdist(c1hy_points,'euclidean');
        c4hy_dist = pdist(c4hy_points,'euclidean');

        %push to all c1,hy lengths
        allc1hylengths = [allc1hylengths, c1hy_dist];
        
        %semiperimeter
        s = (c1c4_dist + c1hy_dist + c4hy_dist) / 2.0;

        %orthogonal distance from hyoid and the vector between c1 and c4 - uses
        %Heron's formula 
        hyoid_orthogonal_dist = 2 * (( s * (s - c1c4_dist) * (s - c1hy_dist) * (s - c4hy_dist))^(0.5)) / c1c4_dist;
        
        %Using Farres' method of Law of Cosines
        
        hyc1c4angle = acos(( c1hy_dist ^ 2 + c1c4_dist ^ 2 - c4hy_dist ^ 2) / (2 * c1hy_dist * c1c4_dist));
        current_orthogonal_dist = sin(hyc1c4angle) * c1hy_dist;
        allFarresMovements = [allFarresMovements,current_orthogonal_dist];
        allAngles = [allAngles, hyc1c4angle];
        
        allMovements = [allMovements, hyoid_orthogonal_dist];
    end
    
    minHyoidExcursion = min(allMovements);
    maxHyoidExcursion = max(allMovements);
    
    minAngle = min(allAngles);
    maxAngle = max(allAngles);
    
    anteriorHyoidMovement = maxHyoidExcursion - minHyoidExcursion;
    
    %ahm = sin(maxAngle) * max(allc1hylengths) - sin(minAngle) * min(allc1hylengths);
    ahm = max(allFarresMovements) - min(allFarresMovements(allFarresMovements>0));
    
end

%Superior Hyoid Movement; Needs C1, C4, Hyoid
function shm = superiorHyoidMovement(doubleCell)
    
      doubleCellSize = size(doubleCell);
    
      allMovements = zeros(1,doubleCellSize(1));


    for i = 1:doubleCellSize(1)
        c1x = doubleCell(i,5);
        c1y = doubleCell(i,6);
        c4x = doubleCell(i,9);
        c4y = doubleCell(i,10);
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);

        c1c4_points = [c1x, c1y; c4x, c4y];
        c1hy_points = [c1x, c1y; hyx, hyy];
        c4hy_points = [c4x, c4y; hyx, hyy];

        c1c4_dist = pdist(c1c4_points,'euclidean');
        c1hy_dist = pdist(c1hy_points,'euclidean');
        c4hy_dist = pdist(c4hy_points,'euclidean');

        %Using Law of Cosines
        
        hyc1c4angle = acos(( c1hy_dist ^ 2 + c1c4_dist ^ 2 - c4hy_dist ^ 2) / (2 * c1hy_dist * c1c4_dist));
        current_orthogonal_dist = cos(hyc1c4angle) * c1hy_dist;
        allMovements(i) = current_orthogonal_dist;
        
    end
    
    shm = max(allMovements) - min(allMovements(allMovements>0));
end

%Hyoid Excursion to Mandible; Needs Mandible, C1, Hyoid
function hyExMand = hyoidExcursionToMandible(doubleCell)
    
    doubleCellSize = size(doubleCell);
    allMovements = zeros(1, doubleCellSize(1));
    
    for i = 1:doubleCellSize(1)
        %get relevant points and put into vectors
        mandx = doubleCell(i,1);
        mandy = doubleCell(i,2);
        c1x = doubleCell(i,5);
        c1y = doubleCell(i,6);
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);

        c1mand_points = [c1x, c1y; mandx, mandy];
        c1hy_points = [c1x, c1y; hyx, hyy];
        mandhy_points = [mandx, mandy; hyx, hyy];

        %get lengths of each set of points to form edges of triangle
        c1mand_dist = pdist(c1mand_points,'euclidean');
        c1hy_dist = pdist(c1hy_points,'euclidean');
        mandhy_dist = pdist(mandhy_points,'euclidean');
     
        %Using Law of Cosines to find angle at mandible
        mhlinemandhyangle = acos(( mandhy_dist ^ 2 + c1mand_dist ^ 2 - c1hy_dist ^ 2) / (2 * mandhy_dist * c1mand_dist));
        
        %distance between hyoid and vector between mandible and c1
        current_orthogonal_dist = sin(mhlinemandhyangle) * mandhy_dist; 
        
        allMovements(i) = current_orthogonal_dist;
    end
    
    %using difference between max and min of all frames to calc hyoid excursion
    
    minHyoidExcursion = min(allMovements(allMovements>0));
    maxHyoidExcursion = max(allMovements);
    hyExMand = maxHyoidExcursion - minHyoidExcursion;
    
end

%Hyoid Excursion to C4; Needs C4, Hyoid
function hyExC4 = hyoidExcursionToC4(doubleCell)
    doubleCellSize = size(doubleCell);    
    allMovements = zeros(1,doubleCellSize(1));

    for i = 1:doubleCellSize(1)
        c4x = doubleCell(i,9);
        c4y = doubleCell(i,10);
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);

        c4hy_points = [c4x, c4y; hyx, hyy];

        %get lengths of each set of points to form edge and add to array
        c4hy_dist = pdist(c4hy_points,'euclidean');
        allMovements(i) = c4hy_dist;

    end
    
    maxhyExC4 = max(allMovements);
    minhyExC4 = min(allMovements(allMovements>0));
    hyExC4 = maxhyExC4 - minhyExC4;
end

%Hyoid Excursion to Vertebrae; Needs Anterior and Superior Hyoid Movements
function hyExVert = hyoidExcursionToVertebrae(doubleCell)
    ahm = anteriorHyoidMovement(doubleCell);
    shm = superiorHyoidMovement(doubleCell);
    
    if (ahm==0 || shm==0) 
        hyExVert = 0;
    else
        hyExVert = sqrt(ahm^2 + shm^2);
    end
   
end

%Anterior Laryngeal Movements; Needs C1, C4, Hyoid, Ant.Cricoid
function alm = antLargyngealMovement(doubleCell)
  
      doubleCellSize = size(doubleCell);    
      allMovements = zeros(1,doubleCellSize(1));

    for i = 1:doubleCellSize(1)
        c1x = doubleCell(i,5);
        c1y = doubleCell(i,6);
        c4x = doubleCell(i,9);
        c4y = doubleCell(i,10);
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);
        antCricX = doubleCell(i,15);
        antCricY = doubleCell(i,16);


        c1c4_points = [c1x, c1y; c4x, c4y];
        c1hy_points = [c1x, c1y; hyx, hyy];
        c4hy_points = [c4x, c4y; hyx, hyy];
        c1antCric_points = [c1x, c1y; antCricX, antCricY];

        %get lengths of each set of points to form edges of triangle

        c1c4_dist = pdist(c1c4_points,'euclidean');
        c1hy_dist = pdist(c1hy_points,'euclidean');
        c4hy_dist = pdist(c4hy_points,'euclidean');
        c1antCric_dist = pdist(c1antCric_points,'euclidean');

   
        %Using Law of Cosines to find angle at mandible
        hyc1c4angle = acos(( c1hy_dist ^ 2 + c1c4_dist ^ 2 - c4hy_dist ^ 2) / (2 * c1hy_dist * c1c4_dist));
        
        current_orthogonal_dist = sin(hyc1c4angle) * c1antCric_dist;
        allMovements(i) = current_orthogonal_dist;

    end
    
    alm = max(allMovements) - min(allMovements(allMovements>0));
end

%Superior Laryngeal Movements; Needs C1, C4, Hyoid, Ant.Cricoid
function slm = supLargyngealMovement(doubleCell)
  
      doubleCellSize = size(doubleCell);    
      allMovements = zeros(1,doubleCellSize(1));

    for i = 1:doubleCellSize(1)
        c1x = doubleCell(i,5);
        c1y = doubleCell(i,6);
        c4x = doubleCell(i,9);
        c4y = doubleCell(i,10);
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);
        antCricX = doubleCell(i,15);
        antCricY = doubleCell(i,16);


        c1c4_points = [c1x, c1y; c4x, c4y];
        c1hy_points = [c1x, c1y; hyx, hyy];
        c4hy_points = [c4x, c4y; hyx, hyy];
        c1antCric_points = [c1x, c1y; antCricX, antCricY];

        %get lengths of each set of points to form edges of triangle

        c1c4_dist = pdist(c1c4_points,'euclidean');
        c1hy_dist = pdist(c1hy_points,'euclidean');
        c4hy_dist = pdist(c4hy_points,'euclidean');
        c1antCric_dist = pdist(c1antCric_points,'euclidean');

   
        %Using Law of Cosines to find angle at mandible
        hyc1c4angle = acos(( c1hy_dist ^ 2 + c1c4_dist ^ 2 - c4hy_dist ^ 2) / (2 * c1hy_dist * c1c4_dist));
        
        %approximating vertical movement of larynx
        current_orthogonal_dist = cos(hyc1c4angle) * c1antCric_dist;
        allMovements(i) = current_orthogonal_dist;

    end
    
    %superior largyngeal movement is difference between max and min
    %movements for all frames
    maxslm = max(allMovements);
    
    %finding nonzero min
    minslm = min(allMovements(allMovements>0));
    
    slm = maxslm - minslm;
end

%Hyolaryngeal Approximation; Needs Hyoid, Ant. Cricoid
function hla = hyolaryngealApproximation(doubleCell)
  
      doubleCellSize = size(doubleCell);    
      allMovements = zeros(1,doubleCellSize(1));

    for i = 1:doubleCellSize(1)
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);
        antCricX = doubleCell(i,15);
        antCricY = doubleCell(i,16);

        hyAntCric_points = [hyx, hyy; antCricX, antCricY];

        %get lengths of each set of points to form edge and add to array
        hyAntCric_dist = pdist(hyAntCric_points,'euclidean');
        allMovements(i) = hyAntCric_dist;

    end
    
    %hyolaryngeal appx is difference between max and min
    %movements for all frames
    maxhla = max(allMovements);
    
    %finding nonzero min
    minhla = min(allMovements(allMovements>0));
    hla = maxhla - minhla;
end

%Laryngeal Elevation; Needs C1, Post. Cricoid
function le = laryngealElevation(doubleCell)
  
      doubleCellSize = size(doubleCell);    
      allMovements = zeros(1,doubleCellSize(1));

    for i = 1:doubleCellSize(1)
        c1x = doubleCell(i,5);
        c1y = doubleCell(i,6);
        postCricX = doubleCell(i,13);
        postCricY = doubleCell(i,14);

        c1PostCric_points = [c1x, c1y; postCricX, postCricY];

        %get lengths of each set of points to form edge and add to array
        c1PostCric_dist = pdist(c1PostCric_points,'euclidean');
        allMovements(i) = c1PostCric_dist;

    end
    
    %laryngeal elevation is difference between max and min dist 
    maxle = max(allMovements);
    %finding nonzero min
    minle = min(allMovements(allMovements>0));

    le = maxle - minle;
end

%Pharyngeal Shortening; Needs Hard Palate, UES
function ps = pharyngealShortening(doubleCell)
  
      doubleCellSize = size(doubleCell);    
      allMovements = zeros(1,doubleCellSize(1));

    for i = 1:doubleCellSize(1)
        hpx = doubleCell(i,3);
        hpy = doubleCell(i,4);
        uesX = doubleCell(i,11);
        uesY = doubleCell(i,12);

        hpUES_points = [hpx, hpy; uesX, uesY];

        %get lengths of each set of points to form edge and add to array
        hpUES_dist = pdist(hpUES_points,'euclidean');
        allMovements(i) = hpUES_dist;

    end
    
    %pharyngeal shortening is difference between max and min dist 
    maxps = max(allMovements);
    %finding nonzero min
    minps = min(allMovements(allMovements>0));

    ps = maxps - minps;
end

%Base of Tongue Retraction Ratio; Needs Val, C1, C4
function botrr = baseOfTongueRetractionRatio(doubleCell)

    doubleCellSize = size(doubleCell);    
    allMovements = zeros(1,doubleCellSize(1));

    for i = 1:doubleCellSize(1)
        c1x = doubleCell(i,5);
        c1y = doubleCell(i,6);
        c4x = doubleCell(i,9);
        c4y = doubleCell(i,10);
        valx = doubleCell(i,19);
        valy = doubleCell(i,20);

        c1c4_points = [c1x, c1y; c4x, c4y];
        c1val_points = [c1x, c1y; valx, valy];
        c4val_points = [c4x, c4y; valx, valy];

        %get lengths of each set of points to form edges of triangle

        c1c4_dist = pdist(c1c4_points,'euclidean');
        c1val_dist = pdist(c1val_points,'euclidean');
        c4val_dist = pdist(c4val_points,'euclidean');
   
        %Using Law of Cosines to find angle at c1
        valc1c4angle = acos(( c1val_dist ^ 2 + c1c4_dist ^ 2 - c4val_dist ^ 2) / (2 * c1val_dist * c1c4_dist));
        
        current_orthogonal_dist = sin(valc1c4angle) * c1val_dist;
        allMovements(i) = current_orthogonal_dist;

    end
    
    botrr = max(allMovements) - min(allMovements(allMovements>0));
end

%Hyoid to Base of Tongue Excursion Ratio; Needs Hyoid, Val
function hybotex = hyoidbotexcursionratio(doubleCell)
    doubleCellSize = size(doubleCell);    
    allMovements = zeros(1,doubleCellSize(1));

    for i = 1:doubleCellSize(1)
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);
        valX = doubleCell(i,19);
        valY = doubleCell(i,20);

        hyval_points = [hyx, hyy; valX, valY];

        %get lengths of each set of points to form edge and add to array
        hyval_dist = pdist(hyval_points,'euclidean');
        allMovements(i) = hyval_dist;

    end
    
    %hyoid to base of tongue excursion ratio is difference between max and min dist 
    maxhybotex = max(allMovements);
    %finding nonzero min
    minhybotex = min(allMovements(allMovements>0));

    hybotex = maxhybotex - minhybotex;
end

%Oral Transit Time; Needs T1 (Leaves Hold), T2 (Ramus Mand.)
function ott = oralTransitTime (phasesCell)
    ott = (phasesCell(3) - phasesCell(2)) / 30;
end

%Stage Transition Duration; Needs T2 (Ramus Mand.), T3 (1st Jump Hyoid)
function std = stageTransitionDuration (phasesCell)
    std = (phasesCell(4) - phasesCell(3)) / 30;
end

%Pharyngeal Transit Time; Needs T2 (Ramus Mand.), T5 (UES Closes)
function ptt = pharyngealTransitTime (phasesCell)
    ptt = (phasesCell(5) - phasesCell(3)) / 30;
end

%Oropharyngeal Transit Time; Needs T1 (Leaves Hold), T5 (UES Closes)
function optt = oropharyngealTransitTime (phasesCell)
    optt = (phasesCell(5) - phasesCell(2)) / 30;
end

%Pharyngeal Delay Time; Needs T2 (Ramus Mand.), T4 (1st Jump Larynx)
function pdt = pharyngealDelayTime (phasesCell)
    pdt = (phasesCell(4) - phasesCell(3)) / 30;
end