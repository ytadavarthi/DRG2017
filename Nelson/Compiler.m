function varargout = Compiler(varargin)
    
    if isempty(varargin)
        choice = menu('Select an option','Compile selected files','Compile all _morphoj files in a selected folder');
        kinematicsButton = false;
        
        %if compile selected files is chosen
        if choice == 1
            [fileNames, folder_name] = uigetfile({'.txt'},'MultiSelect','on');
            if ~iscellstr(fileNames)
                fileNames = {fileNames};
            end
            pathName = {};
            pathName(1:length(fileNames)) = {folder_name};
            
        %if compile all morphoj files in selected folder is chosen
        elseif choice == 2
            folder_name = uigetdir();
            [P, F] = subdir(folder_name); %gathers all folder paths and file names in the chosen directory.
                   
            %un-nests the nested F cell matrix where each cell in the
            %matrix represents the name of each morphoJ file. Also creates 
            %pathName cell matrix where each cell in the matrix
            %represents the path for each morphoJ file, such that
            %[pathname(1) fileName 1] is the full path for each file.
            fileNames = {};
            pathName = {};
            for i = 1:length(F)
                for j = 1:length(F{i})
                    fileNames{end+1} = F{i}{j};
                    pathName{end+1} = P{i};
                end
            end
            fprintf('Found %d morphoj files. Hold on...\n', length(fileNames));

            
        % if neither is chosen or something weird happens.
        else
            error('Something went wrong, try again')
        end
        
    %if varargin = 1 that means that there was an input given to the
    %compiler, This only happens when the display kinematics button is
    %pressed in VFTracker3
    elseif length(varargin) == 1
        fullFileName = varargin{1};
        [~,fileNames,ext] = fileparts(fullFileName);
        pathName = {fullFileName(1:end-length([fileNames ext]))};
        fileNames = {[fileNames '_morphoj_']};
        
        kinematicsButton = true;
        
    % if for some reason more than 1 input is given.
    elseif length(varargin) > 1
        error('Too many inputs')
    end
       
    
    %make compiled structure for coordinates, classifiers, and kinematics
    for i = 1:length(fileNames)
        file = fullfile(pathName{i},fileNames{i});
        cell1 = table2cell(readtable(file,'delimiter','\t','ReadVariableNames',false));
            
        if ~strcmpi(cell1{1,1},'FrameNumber')
            %remove all extraneous cells in coordinateData
            keepCoordinates = ~cellfun(@isempty,cell1(3,:));
            coordinateData{i} = cell1(3:end,keepCoordinates);

            %remove all extraneous cells in classifierData
            keep = ~cellfun(@isempty,cell1(1,:));
            classifierData{i} = cell1([1,2],keep);
        else
            coordinateData{i} = cell1;
            [m, n] = size(cell1);
            classifierData{i} = cell(2,n);
            
        end
        
    end
    dataStruct = struct('coordinateData',coordinateData,'classifierData',classifierData);
    
    %if kinematicsbutton is true, meaning that the compiler is only being
    %used for the display kinematics button in VFTracker3, then we only
    %need to run the compile_kinematicsButton function
    if kinematicsButton
        output = compile_kinematicsButton(dataStruct, fileNames);
        %disp('Done writing combined kinematics file');
        varargout{1} = output;
        
        
    %if kinematicsButton is not true, then we need to run the full compiler
    %functions
    else
        %Making makeshift progress bar
        fprintf('Compiling Coordinate Data..');
        
        finalCell = compile_coordinateData(dataStruct,fileNames,folder_name);
        disp('Done writing combined coordinates file');
        
        %if morphoJ file is old and doesn't include the frame number
        %information, the classifier data text file will not be written.
        %Making makeshift progress bar
        fprintf('Compiling Classifier Data..');
         %if ~strcmpi(cell1{1,1},'FrameNumber')
        compile_classifierData(dataStruct,fileNames,finalCell,folder_name);
        disp('\nDone writing combined classifier file');
         %else
          %   fprintf('\nWARNING: Classifier data not found in _morphoj_ file\nClassifier data not written');
         %end
        
        fprintf('Compiling Kinematics Data..');
        compile_kinematicsData(dataStruct, fileNames,folder_name);
        fprintf('\nDone writing combined kinematics file\n');
    end
end

function finalCell = compile_coordinateData(dataStruct,fileNames,pathName)
    
    %initialize finalCell
    finalCell = dataStruct(1).coordinateData(1,:);
    finalCell{1,1} = 'Swallow ID';
    
    %for the number of videos
    for i = 1:length(dataStruct)
        %adding to the loading bar
        fprintf('..');
        
        if(i == length(dataStruct))
            fprintf('\n');
        end
        
        %extract data from structure
        classifierData = dataStruct(i).classifierData;
        coordinateData = dataStruct(i).coordinateData;
        
        %find the start & end frames, these values will be used to remove
        %extraneous frames (rows) in the next section of code
        start_frame = [];
        end_frame = [];
        for j = 1:length(classifierData(1,:))
           if strcmp(classifierData{1,j},'start_frame')
               start_frame = str2double(classifierData{2,j});
           elseif strcmp(classifierData{1,j},'end_frame')
               end_frame = str2double(classifierData{2,j});
           end
        end
        
        %remove extraneous frames (rows) if first and last frame are indicated:
        if isempty(start_frame) && isempty(end_frame)
            
        elseif isempty(start_frame) && ~isempty(end_frame)
            start_frame = 1;
            %+1 is added to first frame and last frame because the first
            %row of the coordinateData matrix is the title row
            relevantCoordinates = coordinateData(start_frame+1:end_frame+1,:); 
            columnLabels = coordinateData(1,:);
            coordinateData = vertcat(columnLabels,relevantCoordinates);
            
        elseif isempty(end_frame) && ~isempty(start_frame)
            
            relevantCoordinates = coordinateData(start_frame+1:end,:); 
            columnLabels = coordinateData(1,:);
            coordinateData = vertcat(columnLabels,relevantCoordinates);
            
        else
            relevantCoordinates = coordinateData(start_frame+1:end_frame+1,:); 
            columnLabels = coordinateData(1,:);
            coordinateData = vertcat(columnLabels,relevantCoordinates);
        end
        
 
        [m n k] = size(coordinateData);
            
                    
        %Rename ID Column
        for j = 1:m-1
            coordinateData{j+1,1} = [fileNames{i}(1:end-4) num2str(j)];
        end
        
        %create listbox asking user to select landmarks to be compiled
        if i == 1
            [listbox_selection,~] = listdlg('ListString',finalCell(1,2:2:end),'InitialValue',[],'PromptString','Use CTRL and/or SHIFT to select multiple landmarks');
        end
        
        %listbox indeces go like this: mandible, hard palate, hyoid, etc
        %columns go like this: frame_number,mand_x,mand_y,hard_x,hard_y, hyoid_x,hyoid_y etc
        %in this case, say mandible and hyoid are selected, have to make
        %index go from [1,3] to [1,2,3,6,7]
        % 1 is always included because thats the column with the frame id
        %After that, each number is transformed as follows:
        %1 -> [2,3]
        %2 -> [4,5]
        %3 -> [6,7]
        %i -> [i*2,i*2+1]
        %etc
        selectedColumns = [1];
        for j = 1:length(listbox_selection)
            selectedColumns = [selectedColumns,listbox_selection(j)*2,listbox_selection(j)*2+1];
        end
        
        %remove unAnnotated Columns, including column headers
        coordinateData = coordinateData(2:end,selectedColumns);
        if i == 1
            finalCell = finalCell(selectedColumns);
        end
        
        
        %create finalCell
        finalCell = [finalCell;coordinateData];
       
    end
    
    %remove extra columns
    space_and_comma_less_frame_ID = regexprep(finalCell(:,1),'[, ]','_');
    finalCell = [space_and_comma_less_frame_ID, finalCell(:,2:end)];
    
    finalTable = cell2table(finalCell);
    formatOut = 'dd-mm-yy HH-MM AM';
    date = datestr(now,formatOut);
    writetable(finalTable,fullfile(pathName, ['coordinates_' date '.txt']), 'Delimiter', '\t', 'WriteVariableNames', false);
end

function compile_classifierData(dataStruct, fileNames, finalCell, pathName)
    %change directory
    cd Compiler
    
    %Create GUI for use-input independent variables
    [~, outputData] = GUI(fileNames);

    
    %return directory
    cd ../

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
        
        if ~all(all(cellfun(@isempty,classifierData)))
            
            %makeshift progress bar
            fprintf('..');
            if (i == length(dataStruct))
                fprintf('\n');
            end
        
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
            Frames_O     = s.hold_position:(s.hyoid_burst-2);
            Frames_P     = (s.hyoid_burst-1):s.ues_closure;
            Frames_E     = (s.ues_closure+1):s.at_rest;
            Frames_postE = (s.at_rest+1):s.end_frame;

            if isempty(s.at_rest) || s.at_rest > s.end_frame
                Frames_E = (s.ues_closure+1):s.end_frame;
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
        else
            fprintf('\nWARNING: Classifier data not found in %s file',fileNames{i});
            %finds the independent variables inputted by user into uitable and
            %repeats them for every frame, creating extra long column.
            ind_vars = outputData(1+i,2:end);
            %[m n] = size(coordinateData);
            long_col_of_ind_vars = repmat(ind_vars,[m-1,1]);
            classifierColumns = [classifierColumns;long_col_of_ind_vars];
        end
        

    end
  
    %add 'Swallow Phase' to top of second column
    secondColumn = [{'Swallow Stage'}; secondColumn];
    
    %add classifier titles to classifierColumns
    for i = 2:length(outputData(1,:))
        title = outputData{1,i};
        if length(title) > 8 && strcmp(title(1:9), '<html><b>')
            outputData{1,i} = title(length('<html><b>')+1:end-length('</b></html>'));
        end
    end
    classifierColumns = [outputData(1,2:end);classifierColumns];
    
    if all(all(cellfun(@isempty,classifierData)))
        finalTable = cell2table([firstColumn classifierColumns]);
    else
        finalTable = cell2table([firstColumn secondColumn classifierColumns]);
    end
    %write table with correct filename
    formatOut = 'dd-mm-yy HH-MM AM';
    date = datestr(now,formatOut);
    writetable(finalTable,fullfile(pathName, ['classifiers_' date '.txt']), 'Delimiter', '\t', 'WriteVariableNames', false);
        
end

%Gets all kinematic values for all files and stores in variable for GUI display
function output = compile_kinematicsButton(dataStruct, fileNames)
    lengthDataStruct = length(dataStruct);
    numKinematicsFunctions = 11;
    % numKinematicsFunctions*2 + 9 for the timing variables + 4 for nrrs + 3 for pcr + 2 for ues_dist +  1 for filename
    numColumns = numKinematicsFunctions*2 + 9 + 4 + 3 + 2 + 1;
    kinematicsArray = cell(lengthDataStruct+1, numColumns);    
    
    kinematicsArray(1, 1:numColumns) = ...
        {'FileName',    ...
        'ahm_vert', 'ahm_si',   ...
        'shm_vert', 'shm_si',   ...
        'hyExMand_vert', 'hyExMand_si',  ...
        'hyExC4_vert', 'hyExC4_si',  ...
        'hyExVert_vert', 'hyExVert_si',  ...
        'alm_vert',  'alm_si',     ...
        'slm_vert', 'slm_si',    ...
        'hla_vert', 'hla_si',    ...
        'le_vert',  'le_si',   ...
        'ps_vert', 'ps_si',    ...
        'botrr_vert', 'botrr_si',    ...
        'ott',    ...
        'std',    ...
        'ptt',    ...
        'optt',   ...
        'pdt',    ...
        'lvc',    ...
        'uesod',   ...
        'hmd',    ...
        'lvcrt',    ... 
        'nrrs_val_vert', 'nrrs_val_si' ...
        'nrrs_piri_vert', 'nrrs_piri_si'...
        'pcr' 'ePCR' 'pas' 'ues_dist_vert' 'ues_dist_si' };
    
    for i = 1:lengthDataStruct
    
        doubleCell = points2doubleSansLabels(dataStruct, i);
        phaseFramesCell = frames2doubleSansLabels(dataStruct, i);
        siScalar = getSIscalar(phaseFramesCell);
        vertScalar = getVertScalar(doubleCell, phaseFramesCell(1), phaseFramesCell(7));
        
        %checks for SI calibration
        if(~siScalar)
            fprintf('\nWARNING: %s - SI normalization not calculated. You will not have kinematics values in cm\n', fileNames{i});
        end
        
        %checking for frame rate
        if (length(phaseFramesCell)<13 || (isnan(phaseFramesCell(13))))
           fprintf('\nWARNING: %s - No Frame Rate Found. Using 30 fps as default.', fileNames{i})
        end
        
        %for kinematics functions
        startFrame = phaseFramesCell(1);
        endFrame = phaseFramesCell(7);
        
        ahm = anteriorHyoidMovement(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        shm = superiorHyoidMovement(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        hyExMand = hyoidExcursionToMandible(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        hyExC4 = hyoidExcursionToC4(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        hyExVert = hyoidExcursionToVertebrae(doubleCell, vertScalar,  siScalar, startFrame, endFrame);
        alm = antLargyngealMovement(doubleCell, vertScalar,  siScalar, startFrame, endFrame);
        slm = supLargyngealMovement(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        hla = hyolaryngealApproximation(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        le = laryngealElevation(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        ps = pharyngealShortening(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        botrr = baseOfTongueRetractionRatio(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        
        %transit times
        ott = oralTransitTime(phaseFramesCell);
        std = stageTransitionDuration(phaseFramesCell);
        ptt = pharyngealTransitTime(phaseFramesCell);
        optt = oropharyngealTransitTime(phaseFramesCell);
        lvc = laryngealVestibuleClosure (phaseFramesCell);
        %1st jump larynx
        pdt = pharyngealDelayTime(phaseFramesCell);
        uesod = uesOpeningDuration(phaseFramesCell);
        hmd = hyoidMovementDuration(phaseFramesCell);
        lvcrt = lvClosureReactionTime(phaseFramesCell);

        %pharyngeal constriction ratio to determine pharynx strength
        ePCR = experimentalPharyngealConstrictionRatio(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        pcr = pharyngealConstrictionRatio(phaseFramesCell);
        nrrs_val = nrrsValleculae(phaseFramesCell, vertScalar, siScalar);
        nrrs_piri = nrrsPiriform(phaseFramesCell, vertScalar, siScalar);
        pas = getPAS(phaseFramesCell);
        
        ues_dist = uesDistension(phaseFramesCell, vertScalar, siScalar);
        
        kinematicsArray(i+1, 1:numColumns) = {{fileNames{i}(1:end-4)},...
                                                ahm{1},  ahm{2},  ...
                                                shm{1}, shm{2},   ...
                                                hyExMand{1}, hyExMand{2},  ...
                                                hyExC4{1}, hyExC4{2},  ...
                                                hyExVert{1}, hyExVert{2},  ...
                                                alm{1}, alm{2},      ...
                                                slm{1}, slm{2},    ...
                                                hla{1}, hla{2},    ...
                                                le{1}, le{2},    ...
                                                ps{1}, ps{2},    ...
                                                botrr{1},  botrr{2},    ...
                                                ott,    ...
                                                std,    ...
                                                ptt,    ...
                                                optt,   ...
                                                pdt,    ...
                                                lvc,    ... 
                                                uesod,   ...
                                                hmd,    ...
                                                lvcrt,    ... 
                                                nrrs_val{1}, nrrs_val{2}, ...
                                                nrrs_piri{1}, nrrs_piri{2}, ...
                                                pcr, ePCR, pas, ...
                                                ues_dist{1}, ues_dist{2};
};
        
    end
    
    output = [kinematicsArray(1,2:end)' kinematicsArray(2,2:end)'];
    
end

%Gets all kinematic values for all files and stores in a cell for output
function compile_kinematicsData(dataStruct, fileNames, pathName)
    lengthDataStruct = length(dataStruct);
    numKinematicsFunctions = 11;
    % numKinematicsFunctions*2 + 9 for the timing variables + 4 for nrrs + 3 for pcr/pas + 2 for ues + 1 for filename
    numColumns = numKinematicsFunctions*2 + 9 + 4 + 4 + 2 + 1;
    
    
    kinematicsArray = cell(lengthDataStruct+1, numColumns);
    kinematicsArray(1, 1:numColumns) = ...
        {'FileName',    ...
        'ahm_vert', 'ahm_si',   ...
        'shm_vert', 'shm_si',   ...
        'hyExMand_vert', 'hyExMand_si',  ...
        'hyExC4_vert', 'hyExC4_si',  ...
        'hyExVert_vert', 'hyExVert_si',  ...
        'alm_vert',  'alm_si',     ...
        'slm_vert', 'slm_si',    ...
        'hla_vert', 'hla_si',    ...
        'le_vert',  'le_si',   ...
        'ps_vert', 'ps_si',    ...
        'botrr_vert', 'botrr_si',    ...
        'ott',    ...
        'std',    ...
        'ptt',    ...
        'optt',   ...
        'pdt',    ...
        'lvc',    ...
        'uesod',   ...
        'hmd',    ...
        'lvcrt',    ... 
        'nrrs_val_vert', 'nrrs_val_si' ...
        'nrrs_piri_vert', 'nrrs_piri_si'...
        'pcr' 'ePCR' 'pas' 'pas_classifiers' 'ues_dist_vert' 'ues_dist_si'};
    
    for i = 1:lengthDataStruct
        
        %makeshift progress bar for compilation
        fprintf('..');
        
        doubleCell = points2doubleSansLabels(dataStruct, i);
        phaseFramesCell = frames2doubleSansLabels(dataStruct, i);
        siScalar = getSIscalar(phaseFramesCell);
        startFrame = 0;
        endFrame = 0;
        
        %checking for start and end frames to calculate kinematics functions
        if (isnan(phaseFramesCell(1)) || isnan(phaseFramesCell(7)))
            fprintf('\nWARNING: %s - Start and End Frames not found. All kinematic values will be 0.', fileNames{i});
            kinematicsArray(i+1, 1) = {fileNames{i}(1:end-4)};
            for j = 2:numColumns
                kinematicsArray(i+1, j) = {0};
            end
            continue;
        else
            %for kinematics functions
            startFrame = phaseFramesCell(1);
            endFrame = phaseFramesCell(7);
        end
        
        vertScalar = getVertScalar(doubleCell, startFrame, endFrame);
        
        if (vertScalar == 0)
            fprintf('\n%s - Recheck C2-C4 annotations',fileNames{i});
        end
        
        %checking for frame rate
        if length(phaseFramesCell)<13 || (isnan(phaseFramesCell(13)))
           Utilities.CustomPrinters.printWarning(sprintf('\nWARNING: %s - No Frame Rate Found. Using 30 fps as default.', fileNames{i}));
        end
        
        if(~siScalar)
            Utilities.CustomPrinters.printWarning(sprintf('%s - SI normalization not calculated. You will not have kinematics values in cm\n', fileNames{i}));
        end
        

        %all kinematics functions
        ahm = anteriorHyoidMovement(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        shm = superiorHyoidMovement(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        hyExMand = hyoidExcursionToMandible(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        hyExC4 = hyoidExcursionToC4(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        hyExVert = hyoidExcursionToVertebrae(doubleCell, vertScalar,  siScalar, startFrame, endFrame);
        alm = antLargyngealMovement(doubleCell, vertScalar,  siScalar, startFrame, endFrame);
        slm = supLargyngealMovement(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        hla = hyolaryngealApproximation(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        le = laryngealElevation(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        ps = pharyngealShortening(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        botrr = baseOfTongueRetractionRatio(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        
        %transit times
        ott = oralTransitTime(phaseFramesCell);
        std = stageTransitionDuration(phaseFramesCell);
        ptt = pharyngealTransitTime(phaseFramesCell);
        optt = oropharyngealTransitTime(phaseFramesCell);
        lvc = laryngealVestibuleClosure (phaseFramesCell);
        %1st jump larynx
        pdt = pharyngealDelayTime(phaseFramesCell);
        uesod = uesOpeningDuration(phaseFramesCell);
        hmd = hyoidMovementDuration(phaseFramesCell);
        lvcrt = lvClosureReactionTime(phaseFramesCell);

        %pharyngeal constriction ratio to determine pharynx strength
        ePCR = experimentalPharyngealConstrictionRatio(doubleCell, vertScalar, siScalar, startFrame, endFrame);
        pcr = pharyngealConstrictionRatio(phaseFramesCell);
        nrrs_val = nrrsValleculae(phaseFramesCell, vertScalar, siScalar);
        nrrs_piri = nrrsPiriform(phaseFramesCell, vertScalar, siScalar);
        pas = getPAS(phaseFramesCell);
        pas_classifiers = getPAS_Classifiers(phaseFramesCell);

        ues_dist = uesDistension(phaseFramesCell, vertScalar, siScalar);
        
        kinematicsArray(i+1, 1:numColumns) = {{fileNames{i}(1:end-4)},...
                                                ahm{1},  ahm{2},  ...
                                                shm{1}, shm{2},   ...
                                                hyExMand{1}, hyExMand{2},  ...
                                                hyExC4{1}, hyExC4{2},  ...
                                                hyExVert{1}, hyExVert{2},  ...
                                                alm{1}, alm{2},      ...
                                                slm{1}, slm{2},    ...
                                                hla{1}, hla{2},    ...
                                                le{1}, le{2},    ...
                                                ps{1}, ps{2},    ...
                                                botrr{1},  botrr{2},    ...
                                                ott,    ...
                                                std,    ...
                                                ptt,    ...
                                                optt,   ...
                                                pdt,    ...
                                                lvc,    ...
                                                uesod,   ...
                                                hmd,    ...
                                                lvcrt,    ... 
                                                nrrs_val{1}, nrrs_val{2}, ...
                                                nrrs_piri{1}, nrrs_piri{2}, ...
                                                pcr, ePCR, pas, ... 
                                                pas_classifiers, ues_dist{1}, ues_dist{2}};
        
    end
    
    %write to a file
    total_kinematics_table = cell2table(kinematicsArray);
    formatOut = 'dd-mm-yy HH-MM AM';
    date = datestr(now,formatOut);
    writetable(total_kinematics_table,fullfile(pathName, ['kinematics_' date '.txt']), 'Delimiter', '\t', 'WriteVariableNames', false);
end

%Helper Function to calculate distance in pixels between two points
function dist = coordinates_dist(points)
    dist = sqrt((points(1,1) - points(2,1))^2 + (points(1,2) - points(2,2))^2);
end

%Gets Coordinates from DataStruct and converts into cell without labels
function doubleCell = points2doubleSansLabels(dataStruct, videoIndex)
    doubleCell = cellfun(@str2double,dataStruct(videoIndex).coordinateData(2:end,2:end));
end

%Gets Frames from DataStruct and converts into cell without labels
function phaseFramesCell = frames2doubleSansLabels(dataStruct, videoIndex)
    phaseFramesCell = cellfun(@str2double,dataStruct(videoIndex).classifierData(2:end,1:end));
end

%Gets Average C2-C4 Lengths to normalize the distances across patients
function vertScalar = getVertScalar(doubleCell, startFrame, endFrame)
    doubleCellSize = size(doubleCell);
    
    allVertLengths = 0;
    totalTrackedPoints = 0;
    
    for i= startFrame:endFrame
        c2x = doubleCell(i,7);
        c2y = doubleCell(i,8);
        c4x = doubleCell(i,9);
        c4y = doubleCell(i,10);
        
        %finished all of the points
        if(c2x == 0 && c2y > 100 && c4x == 0 && c4y > 100)
            fprintf('For %d frames, all C2-C4 points have been tracked\n', i-1);
            break;
        end
        
        if(c2x == 0 || c2y == 0 || c4x == 0 || c4y == 0)
            fprintf('WARNING: C2-C4 points for Frame %d have NOT been tracked. Vertebrae Normalization may be inaccurate.\n', i);
            vertScalar = 0;
            return;
        else
            c2c4_points = [c2x, c2y; c4x, c4y];
            dist = coordinates_dist(c2c4_points);
            allVertLengths = allVertLengths + dist;
            totalTrackedPoints = totalTrackedPoints + 1;
        end     
    end
    vertScalar = allVertLengths / totalTrackedPoints;
end

%Finds pixels/cm based on the size of a reference object
function siScalar = getSIscalar(phaseFramesCell)
    %normalized to penny
    temp = phaseFramesCell(1,12);
    
    if(~isnan(temp))
        siScalar = temp;
    else
        siScalar = 0;
    end
end

%Anterior Hyoid Movement; Needs C1, C4, Hyoid
function ahm = anteriorHyoidMovement(doubleCell, vertScalar, siScalar, startFrame, endFrame)
    
    doubleCellSize = size(doubleCell);    
    
    allVertMovements = zeros(1, doubleCellSize(1));
    allSIMovements = zeros(1, doubleCellSize(1));
    
    for i = startFrame:endFrame
        c1x = doubleCell(i,5);
        c1y = doubleCell(i,6);
        c4x = doubleCell(i,9);
        c4y = doubleCell(i,10);
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);
        
        if(find([c1x c1y c4x c4y hyx hyy]==0))
            ahm = {0,0};
            return;
        end

        c1c4_points = [c1x, c1y; c4x, c4y];
        c1hy_points = [c1x, c1y; hyx, hyy];
        c4hy_points = [c4x, c4y; hyx, hyy];

        c1c4_dist = coordinates_dist(c1c4_points);
        c1hy_dist = coordinates_dist(c1hy_points);
        c4hy_dist = coordinates_dist(c4hy_points);
         
        %Using Farres' method of Law of Cosines
        
        hyc1c4angle = acos(( c1hy_dist ^ 2 + c1c4_dist ^ 2 - c4hy_dist ^ 2) / (2 * c1hy_dist * c1c4_dist));
        current_orthogonal_dist = sin(hyc1c4angle) * c1hy_dist;
        
        if(~isnan(vertScalar))        
            allVertMovements(i) = current_orthogonal_dist / vertScalar;
        end
        
        if(siScalar)
            allSIMovements(i) = current_orthogonal_dist / siScalar;
        end
    end
   
    vertAHM = max(allVertMovements) - min(allVertMovements(allVertMovements>0));
    siAHM = max(allSIMovements) - min(allSIMovements(allSIMovements>0));
    
    ahm = {vertAHM siAHM};
end

%Superior Hyoid Movement; Needs C1, C4, Hyoid
function shm = superiorHyoidMovement(doubleCell, vertScalar, siScalar, startFrame, endFrame)
    
    doubleCellSize = size(doubleCell);

    allVertMovements = zeros(1, doubleCellSize(1));
    allSIMovements = zeros(1, doubleCellSize(1));
    
    for i = startFrame:endFrame
        c1x = doubleCell(i,5);
        c1y = doubleCell(i,6);
        c4x = doubleCell(i,9);
        c4y = doubleCell(i,10);
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);
        
        if(find([c1x c1y c4x c4y hyx hyy]==0))
            shm = {0,0};
            return;
        end
        
        c1c4_points = [c1x, c1y; c4x, c4y];
        c1hy_points = [c1x, c1y; hyx, hyy];
        c4hy_points = [c4x, c4y; hyx, hyy];

        c1c4_dist = coordinates_dist(c1c4_points);
        c1hy_dist = coordinates_dist(c1hy_points);
        c4hy_dist = coordinates_dist(c4hy_points);
    
        %Using Law of Cosines
        
        hyc1c4angle = acos(( c1hy_dist ^ 2 + c1c4_dist ^ 2 - c4hy_dist ^ 2) / (2 * c1hy_dist * c1c4_dist));
        current_orthogonal_dist = cos(hyc1c4angle) * c1hy_dist;
        
        if(~isnan(vertScalar))        
            allVertMovements(i) = current_orthogonal_dist / vertScalar;
        end
        
        if(siScalar)
            allSIMovements(i) = current_orthogonal_dist / siScalar;
        end
    end
    
    vertSHM = max(allVertMovements) - min(allVertMovements(allVertMovements>0));
    siSHM = max(allSIMovements) - min(allSIMovements(allSIMovements>0));
    
    shm = {vertSHM siSHM};
end

%Hyoid Excursion to Mandible; Needs Mandible, C1, Hyoid
function hyExMand = hyoidExcursionToMandible(doubleCell, vertScalar, siScalar, startFrame, endFrame)
    
    doubleCellSize = size(doubleCell);
    allVertMovements = zeros(1, doubleCellSize(1));
    allSIMovements = zeros(1, doubleCellSize(1));
    
    for i = startFrame:endFrame
        %get relevant points and put into vectors
        mandx = doubleCell(i,1);
        mandy = doubleCell(i,2);
        c1x = doubleCell(i,5);
        c1y = doubleCell(i,6);
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);
        
        if(find([mandx mandy c1x c1y hyx hyy]==0))
            hyExMand = {0,0};
            return;
        end
        
        c1mand_points = [c1x, c1y; mandx, mandy];
        c1hy_points = [c1x, c1y; hyx, hyy];
        mandhy_points = [mandx, mandy; hyx, hyy];

        %get lengths of each set of points to form edges of triangle
        c1mand_dist = coordinates_dist(c1mand_points);
        c1hy_dist = coordinates_dist(c1hy_points);
        mandhy_dist = coordinates_dist(mandhy_points);
     
        %Using Law of Cosines to find angle at mandible
        mhlinemandhyangle = acos(( mandhy_dist ^ 2 + c1mand_dist ^ 2 - c1hy_dist ^ 2) / (2 * mandhy_dist * c1mand_dist));
        
        %distance between hyoid and vector between mandible and c1
        current_orthogonal_dist = sin(mhlinemandhyangle) * mandhy_dist; 
        
        if(~isnan(vertScalar))        
            allVertMovements(i) = current_orthogonal_dist / vertScalar;
        end
        
        if(siScalar)
            allSIMovements(i) = current_orthogonal_dist / siScalar;
        end
    end
    
    %using difference between max and min of all frames to calc hyoid excursion
    verthyExMand = max(allVertMovements) - min(allVertMovements(allVertMovements>0));
    sihyExMand = max(allSIMovements) - min(allSIMovements(allSIMovements>0));
    
    hyExMand = {verthyExMand sihyExMand};
end

%Hyoid Excursion to C4; Needs C4, Hyoid
function hyExC4 = hyoidExcursionToC4(doubleCell, vertScalar, siScalar, startFrame, endFrame)
    doubleCellSize = size(doubleCell);    
    allVertMovements = zeros(1,doubleCellSize(1));
    allSIMovements = zeros(1, doubleCellSize(1));

    for i = startFrame:endFrame
        c4x = doubleCell(i,9);
        c4y = doubleCell(i,10);
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);
        
        if(find([c4x c4y hyx hyy]==0))
            hyExC4 = {0,0};
            return;
        end
        
        c4hy_points = [c4x, c4y; hyx, hyy];
             
        %get lengths of each set of points to form edge and add to array
        c4hy_dist = coordinates_dist(c4hy_points);
        
        if(~isnan(vertScalar))        
            allVertMovements(i) = c4hy_dist / vertScalar;
        end
        if(siScalar)
            allSIMovements(i) = c4hy_dist / siScalar;
        end
    end
    
    %using difference between max and min of all frames to calc hyoid excursion
    verthyExC4 = max(allVertMovements) - min(allVertMovements(allVertMovements>0));
    sihyExC4 = max(allSIMovements) - min(allSIMovements(allSIMovements>0));
    
    hyExC4 = {verthyExC4 sihyExC4};
end

%Hyoid Excursion to Vertebrae; Needs Anterior and Superior Hyoid Movements
function hyExVert = hyoidExcursionToVertebrae(doubleCell, vertScalar, siScalar, startFrame, endFrame)
    ahm = anteriorHyoidMovement(doubleCell, vertScalar, siScalar, startFrame, endFrame);
    shm = superiorHyoidMovement(doubleCell, vertScalar, siScalar, startFrame, endFrame);
    hyExVert = {[],[]};
    
    if (~isempty(ahm{1}) && ~isempty(shm{1})) 
        hyExVert{1} = sqrt(ahm{1}^2 + shm{1}^2);
    end
    
    if (~isempty(ahm{2}) && ~isempty(shm{2})) 
        hyExVert{2} = sqrt(ahm{2}^2 + shm{2}^2);
    end
    
end

%Anterior Laryngeal Movements; Needs C1, C4, Hyoid, Ant.Cricoid
function alm = antLargyngealMovement(doubleCell, vertScalar, siScalar, startFrame, endFrame)
  
    doubleCellSize = size(doubleCell);    
    allVertMovements = zeros(1,doubleCellSize(1));
    allSIMovements = zeros(1, doubleCellSize(1));
    for i = startFrame:endFrame
        c1x = doubleCell(i,5);
        c1y = doubleCell(i,6);
        c4x = doubleCell(i,9);
        c4y = doubleCell(i,10);
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);
        antCricX = doubleCell(i,15);
        antCricY = doubleCell(i,16);
        
        if(find([c1x c1y c4x c4y hyx hyy antCricX antCricY]==0))
            alm = {0,0};
            return;
        end
        
        c1c4_points = [c1x, c1y; c4x, c4y];
        c1hy_points = [c1x, c1y; hyx, hyy];
        c4hy_points = [c4x, c4y; hyx, hyy];
        c1antCric_points = [c1x, c1y; antCricX, antCricY];

        %get lengths of each set of points to form edges of triangle

        c1c4_dist = coordinates_dist(c1c4_points);
        c1hy_dist = coordinates_dist(c1hy_points);
        c4hy_dist = coordinates_dist(c4hy_points);
        c1antCric_dist = coordinates_dist(c1antCric_points);
   
        %Using Law of Cosines to find angle at mandible
        hyc1c4angle = acos(( c1hy_dist ^ 2 + c1c4_dist ^ 2 - c4hy_dist ^ 2) / (2 * c1hy_dist * c1c4_dist));
        
        current_orthogonal_dist = sin(hyc1c4angle) * c1antCric_dist;
        
        if(~isnan(vertScalar))
            allVertMovements(i) = current_orthogonal_dist / vertScalar;
        end
        
        if(siScalar)
            allSIMovements(i) = current_orthogonal_dist / siScalar;
        end
    end
       
    vertalm = max(allVertMovements) - min(allVertMovements(allVertMovements>0));
    sialm = max(allSIMovements) - min(allSIMovements(allSIMovements>0));
    
    alm = {vertalm sialm};
end

%Superior Laryngeal Movements; Needs C1, C4, Hyoid, Ant.Cricoid
function slm = supLargyngealMovement(doubleCell,vertScalar, siScalar, startFrame, endFrame)
  
    doubleCellSize = size(doubleCell);    
    allVertMovements = zeros(1,doubleCellSize(1));
    allSIMovements = zeros(1,doubleCellSize(1));

    for i = startFrame:endFrame
        c1x = doubleCell(i,5);
        c1y = doubleCell(i,6);
        c4x = doubleCell(i,9);
        c4y = doubleCell(i,10);
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);
        antCricX = doubleCell(i,15);
        antCricY = doubleCell(i,16);

        if(find([c1x c1y c4x c4y hyx hyy antCricX antCricY]==0))
            slm = {0,0};
            return;
        end
        
        c1c4_points = [c1x, c1y; c4x, c4y];
        c1hy_points = [c1x, c1y; hyx, hyy];
        c4hy_points = [c4x, c4y; hyx, hyy];
        c1antCric_points = [c1x, c1y; antCricX, antCricY];

        %get lengths of each set of points to form edges of triangle

        c1c4_dist = coordinates_dist(c1c4_points);
        c1hy_dist = coordinates_dist(c1hy_points);
        c4hy_dist = coordinates_dist(c4hy_points);
        c1antCric_dist = coordinates_dist(c1antCric_points);
           
        %Using Law of Cosines to find angle at mandible
        hyc1c4angle = acos(( c1hy_dist ^ 2 + c1c4_dist ^ 2 - c4hy_dist ^ 2) / (2 * c1hy_dist * c1c4_dist));
        
        %approximating vertical movement of larynx
        current_orthogonal_dist = cos(hyc1c4angle) * c1antCric_dist;
        
        if(~isnan(vertScalar))
            allVertMovements(i) = current_orthogonal_dist / vertScalar;
        end 
        
        if(siScalar)
            allSIMovements(i) = current_orthogonal_dist / siScalar;
        end
    end
    
    %superior largyngeal movement is difference between max and min
    %movements for all frames
    vertslm = max(allVertMovements) - min(allVertMovements(allVertMovements>0));
    sislm = max(allSIMovements) - min(allSIMovements(allSIMovements>0));
    slm = {vertslm sislm};
end

%Hyolaryngeal Approximation; Needs Hyoid, Ant. Cricoid
function hla = hyolaryngealApproximation(doubleCell, vertScalar, siScalar, startFrame, endFrame)
  
    doubleCellSize = size(doubleCell);    
    allVertMovements = zeros(1,doubleCellSize(1));
    allSIMovements = zeros(1,doubleCellSize(1));
    
    for i = startFrame:endFrame
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);
        antCricX = doubleCell(i,15);
        antCricY = doubleCell(i,16);
        
        if(find([hyx hyy antCricX antCricY]==0))
            hla = {0,0};
            return;
        end
        
        hyAntCric_points = [hyx, hyy; antCricX, antCricY];
       

        %get lengths of each set of points to form edge and add to array
        hyAntCric_dist = coordinates_dist(hyAntCric_points);

        if(~isnan(vertScalar))
            allVertMovements(i) = hyAntCric_dist / vertScalar;
        end
        if(siScalar)
            allSIMovements(i) = hyAntCric_dist / siScalar;
        end
    end
    
    %hyolaryngeal appx is difference between max and min
    %movements for all frames
    verthla = max(allVertMovements) - min(allVertMovements(allVertMovements>0));
    sihla = max(allSIMovements) - min(allSIMovements(allSIMovements>0));

    hla = {verthla sihla};
end

%Laryngeal Elevation; Needs C1, Post. Cricoid
function le = laryngealElevation(doubleCell,vertScalar, siScalar, startFrame, endFrame)
  
    doubleCellSize = size(doubleCell);    
    allVertMovements = zeros(1,doubleCellSize(1));
    allSIMovements = zeros(1,doubleCellSize(1));

    for i = startFrame:endFrame
        c1x = doubleCell(i,5);
        c1y = doubleCell(i,6);
        postCricX = doubleCell(i,13);
        postCricY = doubleCell(i,14);
        
        if(find([c1x c1y postCricX postCricY]==0))
            le = {0,0};
            return;
        end
        
        c1PostCric_points = [c1x, c1y; postCricX, postCricY];

        %get lengths of each set of points to form edge and add to array
        c1PostCric_dist = coordinates_dist(c1PostCric_points);
        
        
        if(~isnan(vertScalar))
            allVertMovements(i) = c1PostCric_dist / vertScalar;
        end
        
        if(siScalar)
            allSIMovements(i) = c1PostCric_dist / siScalar;
        end

    end
    
    vertLe = max(allVertMovements) - min(allVertMovements(allVertMovements>0));
    siLe = max(allSIMovements) - min(allSIMovements(allSIMovements>0));

    le = {vertLe siLe};
end

%Pharyngeal Shortening; Needs Hard Palate, UES
function ps = pharyngealShortening(doubleCell, vertScalar, siScalar, startFrame, endFrame)
  
    doubleCellSize = size(doubleCell);    
    allVertMovements = zeros(1,doubleCellSize(1));
    allSIMovements = zeros(1,doubleCellSize(1));

    for i = startFrame:endFrame
        hpx = doubleCell(i,3);
        hpy = doubleCell(i,4);
        uesX = doubleCell(i,11);
        uesY = doubleCell(i,12);
        
        if(find([hpx hpy uesX uesY]==0))
            ps = {0,0};
            return;
        end
        
        hpUES_points = [hpx, hpy; uesX, uesY];

        %get lengths of each set of points to form edge and add to array
        hpUES_dist = coordinates_dist(hpUES_points);
       
        
        if(~isnan(vertScalar))
            allVertMovements(i) = hpUES_dist / vertScalar;
        end
        
        if(siScalar)
            allSIMovements(i) = hpUES_dist / siScalar;
        end

    end
    
    vertPs = max(allVertMovements) - min(allVertMovements(allVertMovements>0));
    siPs = max(allSIMovements) - min(allSIMovements(allSIMovements>0));

    ps = {vertPs siPs};
end

%Base of Tongue Retraction Ratio; Needs Val, C1, C4
function botrr = baseOfTongueRetractionRatio(doubleCell, vertScalar, siScalar, startFrame, endFrame)

    doubleCellSize = size(doubleCell);    
    allVertMovements = zeros(1,doubleCellSize(1));
    allSIMovements = zeros(1,doubleCellSize(1));

    for i = startFrame:endFrame
        c1x = doubleCell(i,5);
        c1y = doubleCell(i,6);
        c4x = doubleCell(i,9);
        c4y = doubleCell(i,10);
        valx = doubleCell(i,19);
        valy = doubleCell(i,20);
        
        if(find([c1x c1y c4x c4y valx valy]==0))
            botrr = {0,0};
            return;
        end
        
        c1c4_points = [c1x, c1y; c4x, c4y];
        c1val_points = [c1x, c1y; valx, valy];
        c4val_points = [c4x, c4y; valx, valy];

        %get lengths of each set of points to form edges of triangle

        c1c4_dist = coordinates_dist(c1c4_points);
        c1val_dist = coordinates_dist(c1val_points);
        c4val_dist = coordinates_dist(c4val_points);
   
        %Using Law of Cosines to find angle at c1
        valc1c4angle = acos(( c1val_dist ^ 2 + c1c4_dist ^ 2 - c4val_dist ^ 2) / (2 * c1val_dist * c1c4_dist));
        
        current_orthogonal_dist = sin(valc1c4angle) * c1val_dist;
        
        if(~isnan(vertScalar))
            allVertMovements(i) = current_orthogonal_dist / vertScalar;
        end
        
        if(siScalar)
            allSIMovements(i) = current_orthogonal_dist / siScalar;
        end

    end
    vertBotrr = max(allVertMovements) - min(allVertMovements(allVertMovements>0));
    siBotrr = max(allSIMovements) - min(allSIMovements(allSIMovements>0));

    botrr = {vertBotrr siBotrr};
end

%Oral Transit Time; Needs T1 (Leaves Hold), T2 (Ramus Mand.)
function ott = oralTransitTime (phasesCell)
    if (isnan(phasesCell(3)) || isnan(phasesCell(2)))
        ott = 0;
    elseif length(phasesCell)<13 ||(isnan(phasesCell(13)))
        ott = (phasesCell(3) - phasesCell(2)) / 30;
    else
        ott = (phasesCell(3) - phasesCell(2)) / phasesCell(13);
    end
end

%Stage Transition Duration; Needs T2 (Ramus Mand.), T3 (1st Jump Hyoid)
function std = stageTransitionDuration (phasesCell)
    if (isnan(phasesCell(4)) || isnan(phasesCell(3)))
        std = 0;
    elseif length(phasesCell)<13 ||(isnan(phasesCell(13)))
        std = (phasesCell(4) - phasesCell(3)) / 30;
    else
        std = (phasesCell(4) - phasesCell(3)) / phasesCell(13);
    end
end

%Pharyngeal Transit Time; Needs T2 (Ramus Mandible), T5 (UES Closes)
function ptt = pharyngealTransitTime (phasesCell)
    if (isnan(phasesCell(5)) || isnan(phasesCell(3)))
        ptt = 0;
    elseif length(phasesCell)<13 ||(isnan(phasesCell(13)))
        ptt = (phasesCell(5) - phasesCell(3)) / 30;
    else    
        ptt = (phasesCell(5) - phasesCell(3)) / phasesCell(13);
    end
end

%Oropharyngeal Transit Time; Needs T1 (Leaves Hold), T5 (UES Closes)
function optt = oropharyngealTransitTime (phasesCell)
    if (isnan(phasesCell(5)) || isnan(phasesCell(2)))
        optt = 0;
    elseif length(phasesCell)<13 ||(isnan(phasesCell(13)))
        optt = (phasesCell(5) - phasesCell(2)) / 30;
    else
        optt = (phasesCell(5) - phasesCell(2)) / phasesCell(13);
    end
end

%Pharyngeal Delay Time; Needs T2 (Ramus Mand.), T4 (1st Jump Larynx)
function pdt = pharyngealDelayTime (phasesCell)
    if (length(phasesCell)<25 || isnan(phasesCell(16)) || isnan(phasesCell(3)))
        pdt = 0;
    elseif length(phasesCell)<13 ||(isnan(phasesCell(13)))
        pdt = (phasesCell(16) - phasesCell(3)) / 30;
    else
        pdt = (phasesCell(16) - phasesCell(3)) / phasesCell(13);
    end
end

%Laryngeal Vestibule Closure Duration; Needs LVC Onset and LVC Offset
function lvc = laryngealVestibuleClosure (phasesCell)
    if (length(phasesCell)<25 || isnan(phasesCell(15)) || isnan(phasesCell(14)))
        lvc = 0;
    elseif length(phasesCell)<13 || isnan(phasesCell(13))
        lvc = (phasesCell(15) - phasesCell(14)) / 30;
    else
        lvc = (phasesCell(15) - phasesCell(14)) / phasesCell(13);
    end
end

%UES Opening Duration; Needs UES Close and UES Open
function uesod = uesOpeningDuration (phasesCell)
    if (length(phasesCell)<25 || isnan(phasesCell(17)) || isnan(phasesCell(5)))
        uesod = 0;
    elseif length(phasesCell)<13 || isnan(phasesCell(13))
        uesod = (phasesCell(17) - phasesCell(5)) / 30;
    else
        uesod = (phasesCell(17) - phasesCell(5)) / phasesCell(13);
    end
end

%Hyoid Movement Duration; Needs Hyoid Burst and At Rest
function hmd = hyoidMovementDuration (phasesCell)
    if (length(phasesCell)<25 || isnan(phasesCell(6)) || isnan(phasesCell(4)))
        hmd = 0;
    elseif length(phasesCell)<13 || isnan(phasesCell(13))
        hmd = (phasesCell(6) - phasesCell(4)) / 30;
    else
        hmd = (phasesCell(6) - phasesCell(4)) / phasesCell(13);
    end
end

%Laryngeal Vestibule Closure Reaction Time; Needs LVC Onset and Hyoid Burst
function lvcrt = lvClosureReactionTime (phasesCell)
    if (length(phasesCell)<25 || isnan(phasesCell(14)) || isnan(phasesCell(4)))
        lvcrt = 0;
    elseif length(phasesCell)<13 || isnan(phasesCell(13))
        lvcrt = (phasesCell(14) - phasesCell(4)) / 30;
    else
        lvcrt = (phasesCell(14) - phasesCell(4)) / phasesCell(13);
    end
end

%NRRS - Normalized Residue Ratio Scale for Valleculae 
%Needs Residue Area in Valleculae, Total Area of Valleculae
function nrrs_val = nrrsValleculae (phasesCell, vertScalar, siScalar)
    nrrs_val = {0,0};

    if length(phasesCell)<25
        return;
    else
        nrrs_valres_area = phasesCell(19);
        nrrs_totalval_area = phasesCell(20);
        if ~(isnan(nrrs_valres_area) || isnan(nrrs_totalval_area))
            if(~isnan(vertScalar))
                nrrs_val{1} = (nrrs_valres_area / nrrs_totalval_area) * ( 10* nrrs_valres_area / vertScalar^2);
            end

            if(siScalar)
                nrrs_val{2} = (nrrs_valres_area / nrrs_totalval_area) * ( 10* nrrs_valres_area / siScalar^2);
            end
        end
    end
end

%NRRS - Normalized Residue Ratio Scale for Piriform
%Needs Residue Area in Valleculae, Total Area of Piriform
function nrrs_piri = nrrsPiriform (phasesCell, vertScalar, siScalar)
    nrrs_piri = {0,0};

    if length(phasesCell)<25
        return;
    else
        nrrs_pirires_area = phasesCell(21);
        nrrs_totalpiri_area = phasesCell(22);
        
        if ~(isnan(nrrs_pirires_area) || isnan(nrrs_totalpiri_area))
            if(~isnan(vertScalar))
                nrrs_piri{1} =  (nrrs_pirires_area / nrrs_totalpiri_area) * ( 10* nrrs_pirires_area / vertScalar^2); 
            end

            if(siScalar)
                nrrs_piri{2} =  (nrrs_pirires_area / nrrs_totalpiri_area) * ( 10* nrrs_pirires_area / siScalar^2);
            end
        end
    end
end

function ues_dist = uesDistension (phasesCell, vertScalar, siScalar)
    
    ues_dist = {0,0};

    if length(phasesCell)<25
        return;
    else
        ues_dist_px = phasesCell(18);
        if ~isnan(ues_dist_px)
            if(~isnan(vertScalar))
                ues_dist{1} =  ues_dist_px / vertScalar; 
            end

            if(siScalar)
                ues_dist{2} =  ues_dist_px / siScalar;
            end
        end
    end
end

%PCR - Pharyngeal Constriction Ratio
%Needs pcr_max_area - Area of Pharynx at Maximum Constriction
%Needs pcr_min_area - Area of Pharynx at Minimum Constriction
function pcr = pharyngealConstrictionRatio (phasesCell)
    pcr = 0;
    if length(phasesCell)<25 
        return;
    else
        pcr_min_area = phasesCell(23);
        pcr_max_area = phasesCell(24);
        
        if ~(isnan(pcr_min_area) || isnan(pcr_max_area))
            pcr = pcr_min_area / pcr_max_area;
        end
    end
end

%Pharyngeal Constriction Ratio; Needs UES, Val, SPC, MPC
function ePCR = experimentalPharyngealConstrictionRatio(doubleCell, vertScalar, siScalar, startFrame, endFrame)
    
    doubleCellSize = size(doubleCell);

    allVertAreas = zeros(1, doubleCellSize(1));
    allSIAreas = zeros(1, doubleCellSize(1));
    allAreas = zeros(1, doubleCellSize(1));
    
    for i = startFrame:endFrame
        uesX = doubleCell(i,11);
        uesY = doubleCell(i,12);
        valX = doubleCell(i,19);
        valY = doubleCell(i,20);
        spcX = doubleCell(i,21);
        spcY = doubleCell(i,22);
        mpcX = doubleCell(i,23);
        mpcY = doubleCell(i,24);
        
        if(find([uesX uesY valX valY spcX spcY mpcX mpcY]==0))
            ePCR = 0;
            return;
        end
        
        %finding area of polygon using points
        current_area = abs(((uesX*valY - uesY*valX) + (valX*spcY - valY*spcX) + ...
            (spcX*mpcY - spcY*mpcX) + (mpcX*uesY - mpcY*uesX))/2);
        
        allAreas(i) = current_area;
        
        if(~isnan(vertScalar))        
            allVertAreas(i) = current_area / (vertScalar^2);
        end
        
        if(siScalar)
            allSIAreas(i) = current_area / (siScalar^2);
        end
    end
    
%     vertPCR = min(allVertAreas(allVertAreas>0)) / max(allVertAreas(allVertAreas>0));
%     siPCR = min(allSIAreas(allSIAreas>0)) / max(allSIAreas(allSIAreas>0));
    
    ePCR = min(allAreas(allAreas>0)) / max(allAreas(allAreas>0));
end

%Retrieving PAS
function pas = getPAS(phasesCell)
    pas = 0;
    if (length(phasesCell)<25 || isnan(phasesCell(25)))
        return;
    else
        pas = phasesCell(25);     
    end
end

%Retrieving PAS
function pasc = getPAS_Classifiers(phasesCell)
    pasc = 0;
    if (length(phasesCell)<26 || isnan(phasesCell(26)))
        return;
    else
        pasc = phasesCell(26);     
    end
end

%OLD Anterior Hyoid Movement; Needs C1, C4, Hyoid
function oldahm = oldanteriorHyoidMovement(doubleCell, phaseFramesCell)
    
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

        c1c4_dist = coordinates_dist(c1c4_points);
        c1hy_dist = coordinates_dist(c1hy_points);
        c4hy_dist = coordinates_dist(c4hy_points);
        

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
        
%         current_orthogonal_dist = current_orthogonal_dist/scalar;
        
        allFarresMovements = [allFarresMovements,current_orthogonal_dist];
%         allAngles = [allAngles, hyc1c4angle];
        
        allMovements = [allMovements, hyoid_orthogonal_dist];
    end
    
%     minHyoidExcursion = min(allMovements);
%     maxHyoidExcursion = max(allMovements);
%     
%     minAngle = min(allAngles);
%     maxAngle = max(allAngles);
    
%     anteriorHyoidMovement = maxHyoidExcursion - minHyoidExcursion;
    
%     ahm = sin(maxAngle) * max(allc1hylengths) - sin(minAngle) * min(allc1hylengths);
    ahm = max(allFarresMovements) - min(allFarresMovements(allFarresMovements>0));
    
end

%OLD Hyoid to Base of Tongue Excursion Ratio; Needs Hyoid, Val
function hybotex = hyoidbotexcursionratio(doubleCell, siScalar)
    doubleCellSize = size(doubleCell);    
    allVertMovements = zeros(1,doubleCellSize(1));
    allSIMovements = zeros(1,doubleCellSize(1));

    for i = 1:doubleCellSize(1)
        hyx = doubleCell(i,17);
        hyy = doubleCell(i,18);
        valX = doubleCell(i,19);
        valY = doubleCell(i,20);

        hyval_points = [hyx, hyy; valX, valY];
       
        %get lengths of each set of points to form edge and add to array
        hyval_dist = coordinates_dist(hyval_points);
        
        if(~isnan(vertScalar))
            allVertMovements(i) = hyval_dist / vertScalar;
        end
        
        if(siScalar)
            allSIMovements(i) = hyval_dist / siScalar;
        end


    end
    vertHybotex = max(allVertMovements) - min(allVertMovements(allVertMovements>0));
    siHybotex = max(allSIMovements) - min(allSIMovements(allSIMovements>0));

    hybotex = {vertHybotex siHybotex};
end

function [sub,fls] = subdir(CurrPath)
%   SUBDIR  lists (recursive) all subfolders and files under given folder
%    
%   SUBDIR
%        returns all subfolder under current path.
%
%   P = SUBDIR('directory_name') 
%       stores all subfolders under given directory into a variable 'P'
%
%   [P F] = SUBDIR('directory_name')
%       stores all subfolders under given directory into a
%       variable 'P' and all filenames into a variable 'F'.
%       use sort([F{:}]) to get sorted list of all filenames.
%
%   See also DIR, CD

%   author:  Elmar Tarajan [Elmar.Tarajan@Mathworks.de]
%   version: 2.0 
%   date:    07-Dez-2004
%
    if nargin == 0
       CurrPath = cd;
    end% if
    if nargout == 1
       sub = subfolder(CurrPath,'');
    else
       [sub, fls] = subfolder(CurrPath,'','');
       tmp = dir(CurrPath);
       tmp = tmp(~ismember({tmp.name},{'.' '..'}));
       names = {tmp(~[tmp.isdir]).name};
       
       %originally the following commented line was used, but it seems like
       %the forcecelloutput is only in newer versions of matlab, so the
       %following if statement incorporates that feature.
       %hasMorphoj = strfind(names,'_morphoj_','ForceCellOutput',true);
       hasMorphoj = strfind(names,'_morphoj_');
       if ~iscell(hasMorphoj)
           hasMorphoj = {hasMorphoj};
       end
       
       keep = ~cellfun(@isempty,hasMorphoj);
       names = names(keep);
       
       for i = 1:length(names)
            sub{end+1} = CurrPath;
      
            fls{end+1} = names(i);  
       end
       
    end% if
      %
end

function [sub,fls] = subfolder(CurrPath,sub,fls)
    %------------------------------------------------
    tmp = dir(CurrPath);
    tmp = tmp(~ismember({tmp.name},{'.' '..'}));
    for i = {tmp([tmp.isdir]).name}
       sub{end+1} = fullfile(CurrPath,i{:});
       if nargin==2
          sub = subfolder(sub{end},sub);
       else
          tmp = dir(sub{end});
          names = {tmp(~[tmp.isdir]).name};
          hasMorphoj = strfind(names,'_morphoj_');
          if ~iscell(hasMorphoj)
           hasMorphoj = {hasMorphoj};
          end
       
          keep = ~cellfun(@isempty,hasMorphoj);
          fls{end+1} = names(keep);
          [sub fls] = subfolder(sub{end},sub,fls);
       end% if
    end% if
end