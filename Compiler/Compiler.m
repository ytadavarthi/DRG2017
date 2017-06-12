function Compiler
    %[fileNameMinusExt pathName] = uigetfile({'.txt'},'MultiSelect','on');
    
    %[pathName fileName ext] = fileparts([pathName fileNameMinusExt{1}]);
    
    fileNames = { 'Norm072_Tsp_Pud_morphoj_' 'Norm072_Tsp_Thn_morphoj_'};
    % pathName = '/Users/yasasvi/Documents/DRG_2017_git/Compiler/';
    pathName = 'C:\Users\pouri\OneDrive\Documents\MCG\research\MATLAB\Tracker\DRG2017\Compiler\';
    
    file = [pathName fileNames{1} '.txt'];
    cell = table2cell(readtable(file,'delimiter','\t','ReadVariableNames',false));
    
    %make coordinate compiled file and classifier compiled file
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
    compile_classifierData(dataStruct,fileNames,finalCell);
    

    %%%%start of kinematics functions%%%
    doubleCell = cell2doubleSansLabels(dataStruct, 1);

    ahm = anteriorHyoidMovement(doubleCell);
    shm = superiorHyoidMovement(doubleCell);
    hyExMand = hyoidExcursionToMandible(doubleCell);
    hyExVert = hyoidExcursionToVertebrae(doubleCell);
    alm = antLargyngealMovement(doubleCell);
    slm = supLargyngealMovement(doubleCell);
    hla = hyolaryngealApproximation(doubleCell);
    %??????does laryngeal elevation use c1 or c2??????
    le = laryngealElevation(doubleCell);
    ps = pharyngealShortening(doubleCell);

%     disp(ahm);
%     disp(shm);
%     disp(hyExMand);
%     disp(hyExVert);
%     disp(alm);
%     disp(slm);
%     disp(hla);
%     disp(le);
%     disp(ps);

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
    formatOut = 'dd-mm-yy HH-MM';
    date = datestr(now,formatOut);
    writetable(finalTable,['coordinates ' date '.txt'], 'Delimiter', '\t', 'WriteVariableNames', false);
end

function compile_classifierData(dataStruct, fileNames, finalCell)
    
    %Create GUI for use-input independent variables
    [~, outputData] = GUI(fileNames);

    %create first column from compile_coordinateData function
    firstColumn = finalCell(:,1);
%     
%     [m n] = size(finalCell);
    secondColumn = {};
    classifierColumns = {};
    for i = 1:length(dataStruct)
        %extract data from structure
        classifierData = dataStruct(i).classifierData;
        coordinateData = dataStruct(i).coordinateData;
        
        %create struct s that includes each classifier. i.e. s.start_frame
        %outputs start frame value.
        for j = 1:length(dataStruct(i).classifierData(1,:))
            s.(dataStruct(i).classifierData{1,j}) = str2double(dataStruct(i).classifierData{2,j});  
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
        
        %swallowPhaseData(:,i) = cell(m-1,1);
        swallowPhaseData(Frames_preO,i)  = {'Pre-Oral Transport'};
        swallowPhaseData(Frames_O,i)     = {'Oral Transport'};
        swallowPhaseData(Frames_P,i)     = {'Pharyngeal Stage'};
        swallowPhaseData(Frames_E,i)     = {'Esophageal Stage'};
        swallowPhaseData(Frames_postE,i) = {'Post-Esophageal Stage'};
        
        %get rid of blank cells created when start frame > 1 or when one
        %video's frames # is larger than others
        keep = ~cellfun(@isempty,swallowPhaseData(:,i));
        swallowPhaseData_no_blanks = swallowPhaseData(keep,i);
        
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
    classifierColumns = [outputData(1,2:end);classifierColumns];
    
    finalTable = cell2table([firstColumn secondColumn classifierColumns]);
    
    %write table with correct filename
    formatOut = 'dd-mm-yy HH-MM';
    date = datestr(now,formatOut);
    writetable(finalTable,['Classifiers ' date '.txt'], 'Delimiter', '\t', 'WriteVariableNames', false);
        
end

function doubleCell = cell2doubleSansLabels(dataStruct, videoIndex)
    doubleCell = cellfun(@str2double,dataStruct(videoIndex).coordinateData(2:end,2:end));
end

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

function shm = superiorHyoidMovement(doubleCell)
    
      doubleCellSize = size(doubleCell);
%     allMovements = [];
    
      allFarresMovements = zeros(1,doubleCellSize(1));
%     allAngles = [];
    
%     allc1hylengths = [];

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
%         allc1hylengths = [allc1hylengths, c1hy_dist];
        
        %semiperimeter
%         s = (c1c4_dist + c1hy_dist + c4hy_dist) / 2.0;

        %orthogonal distance from hyoid and the vector between c1 and c4 - uses
        %Heron's formula 
%         hyoid_orthogonal_dist = 2 * (( s * (s - c1c4_dist) * (s - c1hy_dist) * (s - c4hy_dist))^(0.5)) / c1c4_dist;
        
        %Using Farres' method of Law of Cosines
        
        hyc1c4angle = acos(( c1hy_dist ^ 2 + c1c4_dist ^ 2 - c4hy_dist ^ 2) / (2 * c1hy_dist * c1c4_dist));
        current_orthogonal_dist = cos(hyc1c4angle) * c1hy_dist;
        allFarresMovements(i) = current_orthogonal_dist;
%         allAngles = [allAngles, hyc1c4angle];
        
%         allMovements = [allMovements, hyoid_orthogonal_dist];
    end
    
%     minHyoidExcursion = min(allMovements);
%     maxHyoidExcursion = max(allMovements);
    
%     minAngle = min(allAngles);
%     maxAngle = max(allAngles);
%     
%     superiorHyoidMovement = maxHyoidExcursion - minHyoidExcursion;
    
    %ahm = sin(maxAngle) * max(allc1hylengths) - sin(minAngle) * min(allc1hylengths);
    shm = max(allFarresMovements) - min(allFarresMovements(allFarresMovements>0));
end

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

function hyExVert = hyoidExcursionToVertebrae(doubleCell)
    ahm = anteriorHyoidMovement(doubleCell);
    shm = superiorHyoidMovement(doubleCell);
    
    if (ahm==0 || shm==0) 
        hyExVert = 0;
    else
        hyExVert = sqrt(ahm^2 + shm^2);
    end
   
end

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
    
    %superior largyngeal movement is difference between max and min
    %movements for all frames
    maxhla = max(allMovements);
    
    %finding nonzero min
    minhla = min(allMovements(allMovements>0));
    hla = maxhla - minhla;
end

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
    
    %superior largyngeal movement is difference between max and min dist 
    maxle = max(allMovements);
    %finding nonzero min
    minle = min(allMovements(allMovements>0));

    le = maxle - minle;
end

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
    
    %superior largyngeal movement is difference between max and min dist 
    maxps = max(allMovements);
    %finding nonzero min
    minps = min(allMovements(allMovements>0));

    ps = maxps - minps;
end








