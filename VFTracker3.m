function varargout = VFTracker3(varargin)
% VFTRACKER3 MATLAB code for VFTracker3.fig
% C:/Users/pouri/OneDrive/Documents/MCG/research/MATLAB/Tracker/DRG2017

%      VFTRACKER3, by itself, creates a new VFTRACKER3 or raises the existing
%      singleton*.
%
%      H = VFTRACKER3 returns the handle to a new VFTRACKER3 or the handle to
%      the existing singleton*.
%
%      VFTRACKER3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VFTRACKER3.M with the given input arguments.
%
%      VFTRACKER3('Property','Value',...) creates a new VFTRACKER3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VFTracker3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VFTracker3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VFTracker3

% Last Modified by GUIDE v2.5 06-Jun-2017 13:29:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VFTracker3_OpeningFcn, ...
                   'gui_OutputFcn',  @VFTracker3_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before VFTracker3 is made visible.
function VFTracker3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VFTracker3 (see VARARGIN)

% Choose default command line output for VFTracker3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VFTracker3 wait for user response (see UIRESUME)
% uiwait(handles.appFigure);

%Call the initialization function
Initialize(handles);







% --- Outputs from this function are returned to the command line.
function varargout = VFTracker3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function frameScrubber_Callback(hObject, eventdata, handles)
% hObject    handle to frameScrubber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function frameScrubber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameScrubber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%Called once at the start of the app
function Initialize(handles)

%     clc;



pointerHotSpot = [8 8];
pointerShape = [ ...
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
              1   1   1   1   1   1   2 NaN   2   1   1   1   1   1   1   1
              2   2   2   2   2   2   2 NaN   2   2   2   2   2   2   2   2
            NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
              2   2   2   2   2   2   2 NaN   2   2   2   2   2   2   2   2
              1   1   1   1   1   1   2 NaN   2   1   1   1   1   1   1   1
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN   1   2 NaN   2   1 NaN NaN NaN NaN NaN NaN
            NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN];


        set(handles.appFigure, 'PointerShapeCData', pointerShape);
        set(handles.appFigure, 'PointerShapeHotSpot', pointerHotSpot);

    [fileName, pathName] = uigetfile({'*'});
    fullFileName = strcat(pathName, fileName);
    
    %display file name
    handles.text11.String = fileName;
    
    %%% Uncomment to load a file direclty without the file chooser:
    %fullFileName = 'C:\Users\johndoe\Desktop\ThirdRevision\testvideo.avi';
    %fileName = 'testvideo.avi';
    %pathName = 'C:\Users\johndoe\Desktop\ThirdRevision\';
    
    
    clear('globalStudyInfo');
    globalStudyInfo = Data.GlobalStudyInfo;
    
    %globalStudyInfo.fullFileName = fullFileName;
    
    vfVideoStructure = Data.VFVideoStructure(fullFileName);
    

    studyCoordinates = Data.StudyCoordinates(vfVideoStructure);
    globalStudyInfo.studyCoordinates = studyCoordinates;

    
        globalStudyInfo.vfVideoStructure = vfVideoStructure;
    
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    
    %Add a listener to listen to the value property of the frameScrubber to
    %update the frameNumberIndicator
    addlistener(handles.frameScrubber,'Value','PostSet',@(hFigure, eventdata) frameNumberListener(handles.appFigure, eventdata));

    %Add the handler for the frame scrubber
    addlistener(handles.frameScrubber,'ContinuousValueChange', ...
                                      @(hFigure,eventdata) slider1ContValCallback(...
                                        handles.appFigure,eventdata));
        
    

    
    
    %Initialize the frame scrubvber control
    set(handles.frameScrubber, 'Min', 1);
    set(handles.frameScrubber, 'Max', vfVideoStructure.numFrames);
    set(handles.frameScrubber, 'SliderStep', [inv(vfVideoStructure.numFrames - 1)  inv(vfVideoStructure.numFrames - 1)]);
    set(handles.frameScrubber, 'Value', 1);
    
    
                                

    
    %Set up the frame viewer control
    image(zeros(vfVideoStructure.resolution, 'double'), 'Parent', handles.frameViewer, 'HitTest', 'off');
    set(handles.frameViewer, 'XLim', [0 vfVideoStructure.resolution(2)]);
    set(handles.frameViewer, 'YLim', [0 vfVideoStructure.resolution(1)]);
    
    %Correct aspect ratio
    set(handles.frameViewer, 'DataAspectRatio', [1 1 1]);
    set(handles.frameViewer, 'PlotBoxAspectRatio', [2 2 2]);


    %Set up the handles.landmarksListBox
    [m, s] = enumeration('Data.JoveLandmarks');
    set(handles.landmarksListBox, 'String', s);
    
    %Initialize the noiseFilterLevelIndicator
    updateNoiseFilterLevelIndicator(handles);
    
    %Initialize the gammaAdjustLevelIndicator
    updateGammaAdjustLevelIndicator(handles);
    
    
    
    
    %Checking if a results file exists
    [pathStr, name, ext] = fileparts(strcat(pathName, fileName));
    expectedFullExcelFileName = fullfile(pathStr, strcat(name, '.txt'))

    if (exist(expectedFullExcelFileName, 'file'))
        Utilities.CustomPrinters.printInfo('Previously saved annotation results exist. Loading...');
        %Read the table
        inputTable = readtable(expectedFullExcelFileName, 'Delimiter', '\t');
        inputDataArray = table2array(inputTable(:, 2:end));
        
        %loading frame information for push buttons.
        morphoJTable = readtable('+testvideo2_morphoj_.txt','Delimiter','\t', 'ReadVariableNames',false);
        morphoJTable = table2cell(morphoJTable);
        
        %set frame information to each textbox corresponding to push
        %buttons
        set(handles.text12, 'String', num2str(morphoJTable{2,2}));
        set(handles.text13, 'String', num2str(morphoJTable{2,3}));
        set(handles.text14, 'String', num2str(morphoJTable{2,4}));
        set(handles.text15, 'String', num2str(morphoJTable{2,5}));
        set(handles.text16, 'String', num2str(morphoJTable{2,6}));
        set(handles.text17, 'String', num2str(morphoJTable{2,1}));
        set(handles.text18, 'String', num2str(morphoJTable{2,7}));
        
        
        [a, b] = enumeration('Data.JoveLandmarks');
        numLandmarks = numel(b);
        numFrames = size(inputDataArray, 1);
        for landmarkIndex = 0:numLandmarks-1
            for frameIndex = 1:numFrames
                currentCoordinate = [inputDataArray(frameIndex, 2*landmarkIndex + 1) inputDataArray(frameIndex, 2*landmarkIndex + 2) ] ;
                globalStudyInfo.studyCoordinates.setCoordinate(frameIndex, Data.JoveLandmarks(landmarkIndex+1), currentCoordinate);
            end
        end
        Utilities.CustomPrinters.printInfo('Done loading saved annotations');
    else
        Utilities.CustomPrinters.printInfo('No previously saved annotations exist');
    end
    
    
    %Check if a file with the tracking status of each coordinate for each
    %frame exists. if it does, load it and fill the
    %globalStudyInfo.studyCoordinates.trackingStatus cell array.
    expectedFullTrackingStatusFileName = fullfile(pathStr, strcat(name, '_tracking_status.mat'));
    if (exist (expectedFullTrackingStatusFileName, 'file'))
       Utilities.CustomPrinters.printInfo('Tracking information exists for previous session. Loading...');
       loadedMatFile = load(expectedFullTrackingStatusFileName);
       globalStudyInfo.studyCoordinates.trackedStatus = loadedMatFile.('savedTrackedStatus');
       Utilities.CustomPrinters.printInfo('Done loading previous session''s tracking information');
    else
        Utilities.CustomPrinters.printInfo('No previous session''s tracking information exists');
    end
    
    
    
    
    %Update the GUI elements that display the parameters for the Harris
    %corner detector and the KLT tracker
    set(handles.harrisCornerDetectorMinQualityEditBox, 'String', num2str(globalStudyInfo.harrisFeatureDetectorParameters.minQuality));
    set(handles.harrisCornerDetectorFilterSize, 'String', num2str(globalStudyInfo.harrisFeatureDetectorParameters.filterSize));
    set(handles.harrisCornerDetectorSearchRadiusEditBox, 'String', num2str(globalStudyInfo.harrisFeatureDetectorParameters.searchRadius));
    set(handles.numPyramidLevelsEditBox, 'String', num2str(globalStudyInfo.kltTrackerParameters.numPyramidLevels));
    set(handles.blockSizeEditBox, 'String', num2str(globalStudyInfo.kltTrackerParameters.blockSize));
    
    
        
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    
    %Render the first frame
    Render(handles);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%The render function    
function Render(handles, varargin)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    
    currentlyTrackedLandmark = globalStudyInfo.currentlyTrackedLandmark;
    
    %get the current value of the frameScrubber control
    currentFrameIndex = floor(get(handles.frameScrubber, 'Value'));
    
    %Get the handle to the image object under the Axes object that will be
    %used to dispalay the frame
    imageViewerHandle = get(handles.frameViewer, 'Children');
    
    
    %Get the frame data from the vfvideostructure
    currentFrame = globalStudyInfo.vfVideoStructure.videoFrames{currentFrameIndex};
    
    %Apply preprocessing on the frame
    currentFrame = preprocessImage(handles, currentFrame);
    
    %Draw the landmark annotations
    numLandmarks = Data.JoveLandmarks.numLandmarks;
    [m, s] = enumeration('Data.JoveLandmarks');
    
    for i = 1:numLandmarks
        currentCoordinate = globalStudyInfo.studyCoordinates.getCoordinate(currentFrameIndex, i);
        if (~isempty(currentCoordinate))
            if (uint8(currentlyTrackedLandmark) == i)
                markerColour = 'green';
            else
                markerColour = 'red';
            end
            currentFrame = insertMarker(currentFrame, currentCoordinate, 'color', markerColour);
        end
    end
    
    
    %DIsplay the frame
    set(imageViewerHandle, 'CData', currentFrame);
    
    
    


    
 %This function implements the callback that is called everytime the frame
 %scrubber slider is moved. This is undocumented MATLAB stuff. It does not
 %work when the gui that is using this is packaged as a stand-alone using
 %MATLAB Compiler
 %There seems to be no way around this problem, so packaged apps will lose
 %the frame scrubber likeness.
 function slider1ContValCallback(hFigure,eventdata)
    % test it out - get the handles object and display the current value
    handles = guidata(hFigure);
    
        
    %Render(handles)
    frameNumberListener(handles.appFigure)
    
    


% --- Executes on selection change in landmarksListBox.
function landmarksListBox_Callback(hObject, eventdata, handles)
% hObject    handle to landmarksListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns landmarksListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from landmarksListBox
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    listBoxSelection = get(handles.landmarksListBox, 'Value');
    listBoxSelection = listBoxSelection(1);
    globalStudyInfo.currentlyTrackedLandmark = Data.JoveLandmarks(listBoxSelection);
    Utilities.CustomPrinters.printInfo(sprintf('Current landmark is %s', char(globalStudyInfo.currentlyTrackedLandmark)));
    figure(gcf);%This is supposed to bring the focus back to the app figure's gray area but it does not work as expected.
    uicontrol(handles.text9);
    Render(handles);


% --- Executes during object creation, after setting all properties.
function landmarksListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to landmarksListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




%The function to do preprocessing of the image before it is rendered or
%passed onto the point tracker
function result = preprocessImage(handles, img)
    %Convert to grayscale if it is RGB and keep track of whether it was
    %RGB or grayscale so it can be reconverted at the end
    if (size(img, 3) == 3)
        wasRGB = true;
        img = rgb2gray(img);
    else
        wasRGB = false;
    end
    
    
    %Get the current filter window size
    filterWindowSize = floor(get(handles.noiseFilterLevelSlider, 'Value'));
    if (filterWindowSize == 0)
        %Do no filteirng
    else
       %Do some filtering
       filterWindowWidth = 3 + 2 * filterWindowSize;
       img = wiener2(img, [filterWindowWidth filterWindowWidth]); 
    end
    
    
    %Do some gamma adjjustment
    gammaAdjustLevel = get(handles.gammaAdjustSlider, 'Value');
    img = imadjust(img, [], [], gammaAdjustLevel);
    
    
    
    %if the original image was RGB convert it back to RGB
    if (wasRGB == true)
        result = repmat(img, [1 1 3]);
    else
        result = img;
    end
    
    
    
    
    
    


% --------------------------------------------------------------------
function uitoggletool2_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handle(handles.frameScrubber);


% --- Executes on slider movement.
function noiseFilterLevelSlider_Callback(hObject, eventdata, handles)
% hObject    handle to noiseFilterLevelSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
updateNoiseFilterLevelIndicator(handles);
Render(handles);


% --- Executes during object creation, after setting all properties.
function noiseFilterLevelSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noiseFilterLevelSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function gammaAdjustSlider_Callback(hObject, eventdata, handles)
% hObject    handle to gammaAdjustSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    updateGammaAdjustLevelIndicator(handles);
    Render(handles);
    
    
    
    
% --- Executes during object creation, after setting all properties.
function gammaAdjustSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammaAdjustSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function updateNoiseFilterLevelIndicator(handles)
    set(handles.noiseFilterLevelIndicator, 'String', sprintf('Noise filter Strength: %d', floor(get(handles.noiseFilterLevelSlider, 'Value'))));
        
function updateGammaAdjustLevelIndicator(handles)
    set(handles.gammaAdjustLevelIndicator, 'String', sprintf('Gamma: %.2f', get(handles.gammaAdjustSlider, 'Value')));
        


% --- Executes during object creation, after setting all properties.
function noiseFilterLevelIndicator_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noiseFilterLevelIndicator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes on key press with focus on appFigure and none of its controls.
%This is not being used.
function appFigure_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to appFigure (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% 
% globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
% 
% switch(lower(eventdata.Character))
%     case 's'
%         performTracking(handles);
%     case 'q'
%         close(handles.appFigure);
%     case 'm'
%         %disp('called')
%         %performManualAnnotation(handles);
%         x = [];
%         y = [];
%         done = false;
%         currentFrameIndex = floor(get(handles.frameScrubber, 'Value'));
%         
%         numFrames = globalStudyInfo.vfVideoStructure.numFrames;
%         
%         while(currentFrameIndex <= numFrames && done == false)
%             [x, y] = mygetpts();
%             done = isempty([x y]);
%             if (~done)
%                currentlyTrackedLandmark = globalStudyInfo.currentlyTrackedLandmark;
%                globalStudyInfo.studyCoordinates.setCoordinate(currentFrameIndex, currentlyTrackedLandmark, [x y]);
%             end
%             
%             if (currentFrameIndex < numFrames)
%                 currentFrameIndex = currentFrameIndex + 1;
%             end
%             
%             
%             set(handles.frameScrubber, 'Value', currentFrameIndex);
%         end        
%         
%     %'i' for interpolation
%     case 'i'
%         userQuery = inputdlg('Enter start and end frame numbers');
%         userQuery = userQuery{1};
%         userQuery = str2num(userQuery);
%         startFrame = userQuery(1);
%         endFrame = userQuery(2);
%         Interpolater(handles, startFrame, endFrame);
%         
% 
% end



%the function that does the tracking
function performTracking(handles)
    
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    
    numFrames = globalStudyInfo.vfVideoStructure.numFrames;
    currentlyTrackedLandmark = globalStudyInfo.currentlyTrackedLandmark;
%    disp(currentlyTrackedLandmark)
    
    currentFrameIndex = floor(get(handles.frameScrubber, 'Value'));
    currentFrame = globalStudyInfo.vfVideoStructure.videoFrames{currentFrameIndex};
        
    %Do image preprocessing on the current frame
    currentFrame = preprocessImage(handles, currentFrame);
    currentFrame = rgb2gray(currentFrame);     
    
    
    
    cornersFound = false;
    while(cornersFound == false)
        
        [x, y] = getpts(handles.frameViewer);
    
        chosenPointX = floor(x(1));
        chosenPointY = floor(y(1));

    
       
        
        cornerSearchRadius = globalStudyInfo.harrisFeatureDetectorParameters.searchRadius;
        harrisFeatureDetectorMinQuality = globalStudyInfo.harrisFeatureDetectorParameters.minQuality;
        harrisFeatureDetectorFilterSize = globalStudyInfo.harrisFeatureDetectorParameters.filterSize;
        %Utilities.CustomPrinters.printInfo(sprintf('About to call Harris Feature Detector with search radius = [%s], Min Quality = %s, Filter Size = %s', num2str(cornerSearchRadius ), num2str(harrisFeatureDetectorMinQuality), num2str(harrisFeatureDetectorFilterSize)));
        
        cornersDetected = detectHarrisFeatures(currentFrame, 'MinQuality', harrisFeatureDetectorMinQuality, 'ROI', [(chosenPointX - cornerSearchRadius) (chosenPointY - cornerSearchRadius) (2 * cornerSearchRadius + 1) (2 * cornerSearchRadius + 1)], 'FilterSize', harrisFeatureDetectorFilterSize);
        if (size(cornersDetected.Location, 1) == 0)
            cornersFound = false;
            Utilities.CustomPrinters.printWarning('No Harris corners detected. Increase search window or try a different spot');
%            disp('no corners detected');
            set(handles.feedbackLabel, 'String', 'No corners detected');
        else
%            disp('corners detected');
            Utilities.CustomPrinters.printInfo('Harris corner detected');
            cornersFound = true;
            set(handles.feedbackLabel, 'String', '');
        end
    end
    
    
    set(handles.feedbackLabel, 'String', 'Tracking...');
    
    %By how much does the corner that is about to be tracked exceed the
    %point chosen by the user?
    cornerMinusChosenPointX = cornersDetected.Location(1, 1) - chosenPointX;
    cornerMinusChosenPointY = cornersDetected.Location(1, 2) - chosenPointY;
    
    
    
    %Store the detected corner into the coordinate structure
    globalStudyInfo.studyCoordinates.setCoordinate(currentFrameIndex, currentlyTrackedLandmark, [(cornersDetected.Location(1, 1) - cornerMinusChosenPointX) (cornersDetected.Location(1, 2) - cornerMinusChosenPointY)]);
    globalStudyInfo.studyCoordinates.setTrackedStatus(currentFrameIndex, currentlyTrackedLandmark, Data.TrackingType.Automatic);
    
    
    
    %Utilities.CustomPrinters.printInfo(sprintf('About to initiate KLT tracker with Block size = [%s], Number Pyramid Levels = %s, Max Iterations = %s', num2str(globalStudyInfo.kltTrackerParameters.blockSize), num2str(globalStudyInfo.kltTrackerParameters.numPyramidLevels), num2str(globalStudyInfo.kltTrackerParameters.maxIterations)));    
    v = vision.PointTracker('NumPyramidLevels', globalStudyInfo.kltTrackerParameters.numPyramidLevels, 'BlockSize', globalStudyInfo.kltTrackerParameters.blockSize, 'MaxIterations', globalStudyInfo.kltTrackerParameters.maxIterations);
    initialize(v, cornersDetected.Location(1, :), currentFrame);
     
     Utilities.CustomPrinters.printInfo('Hold on while tracking is being done....');
     while(currentFrameIndex < numFrames)
         nextFrame = globalStudyInfo.vfVideoStructure.videoFrames{currentFrameIndex + 1};
         nextFrame = preprocessImage(handles, nextFrame);
         nextFrame = rgb2gray(nextFrame);
         [trackedPoints, trackedPointsValidity] = step(v, nextFrame);
         if (trackedPointsValidity(1) == false)
            release(v);
            return;
         else
            currentFrameIndex = currentFrameIndex + 1;
            globalStudyInfo.studyCoordinates.setCoordinate(currentFrameIndex, currentlyTrackedLandmark, [(trackedPoints(1, 1) - cornerMinusChosenPointX) (trackedPoints(1, 2) - cornerMinusChosenPointY)]);
            globalStudyInfo.studyCoordinates.setTrackedStatus(currentFrameIndex, currentlyTrackedLandmark, Data.TrackingType.Automatic);
         end
     end
     Utilities.CustomPrinters.printInfo('Tracking is done');
     set(handles.feedbackLabel, 'String', '');
     Render(handles);
    

     
%this is the function to do manual annotation     
function performManualAnnotation(handles)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    
    currentFrameIndex = floor(get(handles.frameScrubber, 'Value'));
    
    numFrames = globalStudyInfo.vfVideoStructure.numFrames;
    
    
    currentlyTrackedLandmark = globalStudyInfo.currentlyTrackedLandmark;
    
    [x, y] = getpts(handles.frameViewer);
    
    %Record the location of the point into the recording structure
    globalStudyInfo.studyCoordinates.setCoordinate(currentFrameIndex, currentlyTrackedLandmark, [x(1) y(1)]);
    
    
    %Skip to the next frame
    if ~(currentFrameIndex == numFrames)
       set(handles.frameScrubber, 'Value', currentFrameIndex + 1); 
       slider1ContValCallback(handles.appFigure, [] );
    end
    
    
    

% --------------------------------------------------------------------
function trimVideoMenuButton_Callback(hObject, eventdata, handles)
% hObject    handle to trimVideoMenuButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%Used to update the frame number
function frameNumberListener(hFigure, eventdata)
     handles = guidata(hFigure);
     globalStudyInfo = getappdata(hFigure, 'globalStudyInfo');
     currentFrameNumber = floor(get(handles.frameScrubber, 'Value'));
     totalFrames = globalStudyInfo.vfVideoStructure.numFrames;
     displayString = sprintf('%d / %d', currentFrameNumber, totalFrames);
     set(handles.frameNumberIndicator, 'String', displayString);
     Render(handles)


% --- Executes on mouse press over figure background.
function appFigure_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to appFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
frameViewer_ButtonDownFcn(hObject, eventdata, handles)


% --- Executes on mouse press over axes background.
function frameViewer_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to frameViewer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function imageButtownDownFcn()
%    disp('called image button down callback')


% --------------------------------------------------------------------
function writeResultsButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to writeResultsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
Utilities.ResultFileWriter(globalStudyInfo);


% --------------------------------------------------------------------
function reinitializeTool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to reinitializeTool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Initialize(handles)


% --- Executes on key press with focus on appFigure or any of its controls.
function appFigure_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to appFigure (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');

    
switch(lower(eventdata.Character))
    case 's'
        performTracking(handles);
    case 'q'
        close(handles.appFigure);
    case 'm'
        %disp('called')
        %performManualAnnotation(handles);
        x = [];
        y = [];
        done = false;
        currentFrameIndex = floor(get(handles.frameScrubber, 'Value'));
        
        numFrames = globalStudyInfo.vfVideoStructure.numFrames;
        
        while(currentFrameIndex <= numFrames && done == false)
            [x, y] = mygetpts();
            done = isempty([x y]);
            if (~done)
               currentlyTrackedLandmark = globalStudyInfo.currentlyTrackedLandmark;
               globalStudyInfo.studyCoordinates.setCoordinate(currentFrameIndex, currentlyTrackedLandmark, [x y]);
               globalStudyInfo.studyCoordinates.setTrackedStatus(currentFrameIndex, currentlyTrackedLandmark, Data.TrackingType.Manual);
            end
            
            if (currentFrameIndex < numFrames && ~done)
                currentFrameIndex = currentFrameIndex + 1;
            end
            
            
            set(handles.frameScrubber, 'Value', currentFrameIndex);
        end    
        
            
        
%     %'i' for interpolation
%     case 'i'
%         userQuery = inputdlg('Enter start and end frame numbers');
%         userQuery = userQuery{1};
%         userQuery = str2num(userQuery);
%         startFrame = userQuery(1);
%         endFrame = userQuery(2);
%         Interpolater(handles, startFrame, endFrame);
        

end


% --------------------------------------------------------------------
function saveButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
oldFeedbackLabelMessage = get(handles.feedbackLabel, 'String');
set(handles.feedbackLabel, 'String', 'Saving...');
Utilities.ResultFileWriter(globalStudyInfo);
set(handles.feedbackLabel, 'String', '');


% --------------------------------------------------------------------
function WriteHighResVideo_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to WriteHighResVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
VideoWriterCallback(handles, 'high');   
    


    
    
% --------------------------------------------------------------------
function CreateSlitImageMenuButton_Callback(hObject, eventdata, handles)
% hObject    handle to CreateSlitImageMenuButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    imageViewerHandle = get(handles.frameViewer, 'Children');
    currentLandmark = globalStudyInfo.currentlyTrackedLandmark;
    fprintf('\nThe current landmark is %s\n', char(currentLandmark));
    %Get the number of frames
    numberOfFrames = globalStudyInfo.vfVideoStructure.numFrames;
    fprintf('\nThe total number of frames in this VF is %d\n', numberOfFrames);
    
    %some constants, just constants for now. They will be variables later
    SLIT_HEIGHT_HW = 30;
    SLIT_WIDTH_HW = 30;
    SEPERATOR_WIDTH = 1;
    SEPERATOR_COLOUR = 'green';
    ABSENT_COLOUR = 'black';
    
    
    %Set up the matrix that will hold the frames
    slit_image = zeros(2 * SLIT_HEIGHT_HW + 1, 0, 3);
    
    %Go through the VF frames and start appending the slit images
    for i = 1:numberOfFrames
       currentLandmarkCoordinate = floor(globalStudyInfo.studyCoordinates.getCoordinate(i, currentLandmark));
    
        %Get the current frame data that was rendered
        currentFrame = get(imageViewerHandle, 'CData');
        xCoord = currentLandmarkCoordinate(2);
        yCoord = currentLandmarkCoordinate(1);
        
        fprintf('\nFrame: %d, x-coord: %d, y-coord: %d, x-dim: %d, y-dim: %d, z-dim: %d', i, currentLandmarkCoordinate(1), currentLandmarkCoordinate(2), size(currentFrame, 1), size(currentFrame, 2), size(currentFrame, 3))
        slitFrame = currentFrame(xCoord - SLIT_HEIGHT_HW : xCoord + SLIT_HEIGHT_HW, yCoord - SLIT_WIDTH_HW : yCoord + SLIT_WIDTH_HW, :);
        
        slit_image = horzcat(slit_image, slitFrame);
    end
    
    figure, imshow(slit_image)
    
    
    
    
    
    


% --------------------------------------------------------------------
function WriteLowResVideo_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to WriteLowResVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
VideoWriterCallback(handles, 'low');
% disp('debug pitstop called');
% globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
% fullFileName = globalStudyInfo.vfVideoStructure.fileName;
% [pathstr, name, ext] = fileparts(fullFileName);
% trackingResultFullFileName = fullfile(pathstr, strcat(name, '_tracking_status.mat'));
% savedTrackedStatus = globalStudyInfo.studyCoordinates.trackedStatus;
% save(trackingResultFullFileName, 'savedTrackedStatus');



function numPyramidLevelsEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to numPyramidLevelsEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numPyramidLevelsEditBox as text
%        str2double(get(hObject,'String')) returns contents of numPyramidLevelsEditBox as a double
%disp('Num Pyramid levels text bos callback');

globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');

try
    value = uint8(floor(str2double(get(hObject, 'String'))));
    if (value < 1)
        throw(MException());
    end
catch
    Utilities.CustomPrinters.printError('Number of pyramid levels must be positive integer > 1. Setting to 3 (default)');
    value = 3;
end
set(hObject, 'String', value);

globalStudyInfo.kltTrackerParameters.numPyramidLevels = value;
setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);


% --- Executes during object creation, after setting all properties.
function numPyramidLevelsEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numPyramidLevelsEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function blockSizeEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to blockSizeEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blockSizeEditBox as text
%        str2double(get(hObject,'String')) returns contents of blockSizeEditBox as a double
%disp('block size edit box callback called');
globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');

value = get(hObject, 'String');   
try
    value = uint8(str2num(value));
    if ~(value >= 3 && mod(value, 2) == [1 1])
        disp('ERORR');
    end
catch
    
end

globalStudyInfo.kltTrackerParameters.blockSize = value;

setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);



% --- Executes during object creation, after setting all properties.
function blockSizeEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blockSizeEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on scroll wheel click while the figure is in focus.
function appFigure_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to appFigure (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
scrollDelta = eventdata.VerticalScrollCount;
globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
totalFrames = globalStudyInfo.vfVideoStructure.numFrames;
%frameScrubber
currentFrame = get(handles.frameScrubber, 'Value');
if (scrollDelta > 0 && currentFrame ~= totalFrames)
    currentFrame = currentFrame + 1;
elseif (scrollDelta < 0 && currentFrame ~= 1)
    currentFrame = currentFrame - 1;
end

set(handles.frameScrubber, 'Value', currentFrame);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function appFigure_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to appFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%disp('figure button up')
uicontrol(handles.frameScrubber);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over landmarksListBox.
function landmarksListBox_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to landmarksListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(gca)
axes(handles.frameViewer);
uicontrol(handles.frameScrubber);   



function harrisCornerDetectorMinQualityEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to harrisCornerDetectorMinQualityEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of harrisCornerDetectorMinQualityEditBox as text
%        str2double(get(hObject,'String')) returns contents of harrisCornerDetectorMinQualityEditBox as a double
globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
value = str2double(get(hObject, 'String'));
globalStudyInfo.harrisFeatureDetectorParameters.minQuality = value;
setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);

% --- Executes during object creation, after setting all properties.
function harrisCornerDetectorMinQualityEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to harrisCornerDetectorMinQualityEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function harrisCornerDetectorFilterSize_Callback(hObject, eventdata, handles)
% hObject    handle to harrisCornerDetectorFilterSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of harrisCornerDetectorFilterSize as text
%        str2double(get(hObject,'String')) returns contents of harrisCornerDetectorFilterSize as a double
globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
value = str2double(get(hObject, 'String'));
globalStudyInfo.harrisFeatureDetectorParameters.filterSize = value;
setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);


% --- Executes during object creation, after setting all properties.
function harrisCornerDetectorFilterSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to harrisCornerDetectorFilterSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function harrisCornerDetectorSearchRadiusEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to harrisCornerDetectorSearchRadiusEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of harrisCornerDetectorSearchRadiusEditBox as text
%        str2double(get(hObject,'String')) returns contents of harrisCornerDetectorSearchRadiusEditBox as a double
globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
value = str2double(get(hObject, 'String'));
globalStudyInfo.harrisFeatureDetectorParameters.searchRadius = value;
setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);

% --- Executes during object creation, after setting all properties.
function harrisCornerDetectorSearchRadiusEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to harrisCornerDetectorSearchRadiusEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function VideoWriterCallback(handles, resolution)
globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
numFrames = globalStudyInfo.vfVideoStructure.numFrames;

[pathstr, name, ext] = fileparts(globalStudyInfo.vfVideoStructure.fileName);

videoFileWriter = vision.VideoFileWriter();

if (strcmp(resolution, 'low'))
    videoFileName = fullfile(pathstr, strcat(name, '_video.mp4'));
    videoFileWriter.FileFormat = 'MPEG4';
else
    videoFileName = fullfile(pathstr, strcat(name, '_video.avi'));
end
videoFileWriter.Filename = videoFileName;
Utilities.CustomPrinters.printInfo(sprintf('Writing video as %s. Hold on...', videoFileName));

%Draw the landmark annotations
numLandmarks = Data.JoveLandmarks.numLandmarks;
[m, s] = enumeration('Data.JoveLandmarks');

for i = 1:numFrames
    %This works by running the framescrubber through all the notches,
    %reading the cdata, and writing it to the videofile writer

    %Get the frame data from the vfvideostructure
    currentFrame = globalStudyInfo.vfVideoStructure.videoFrames{i};

   for j = 1:numLandmarks
     currentCoordinate = globalStudyInfo.studyCoordinates.getCoordinate(i, j);
     if (~isempty(currentCoordinate))
         if (isempty(cell2mat(regexp(s(j), '_gt'))))
            landmarkColour = 'green';
         else
             landmarkColour = 'red';
         end
        currentFrame = insertMarker(currentFrame, currentCoordinate, 'color', landmarkColour);
     end
   end

   %Insert the frame number at the top left
   currentFrame = insertText(currentFrame, [1 1], sprintf('%d / %d', i, numFrames));

   step(videoFileWriter, currentFrame);
end


release(videoFileWriter);
Utilities.CustomPrinters.printInfo('Done writing video file');


    % --- Executes on key press with focus on landmarksListBox and none of its controls.
function landmarksListBox_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to landmarksListBox (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
uicontrol(handles.text9);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.hold_position = floor(get(handles.frameScrubber, 'Value'));
    set(handles.text12, 'String', globalStudyInfo.hold_position);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);

    
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.ramus_mandible = floor(get(handles.frameScrubber, 'Value'));
    set(handles.text13, 'String', globalStudyInfo.ramus_mandible);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);

    
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.hyoid_burst = floor(get(handles.frameScrubber, 'Value'));
    set(handles.text14, 'String', globalStudyInfo.hyoid_burst);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);

    
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.ues_closure = floor(get(handles.frameScrubber, 'Value'));
    set(handles.text15, 'String', globalStudyInfo.ues_closure);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.at_rest = floor(get(handles.frameScrubber, 'Value'));
    set(handles.text16, 'String', globalStudyInfo.at_rest);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);


% --- Executes on button press in deletebutton.
function deletebutton_Callback(hObject, eventdata, handles)
% hObject    handle to deletebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.start_frame = floor(get(handles.frameScrubber, 'Value'));
    set(handles.text17, 'String', globalStudyInfo.start_frame);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);

% --- Executes on button press in endButton.
function endButton_Callback(hObject, eventdata, handles)
% hObject    handle to endButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.end_frame = floor(get(handles.frameScrubber, 'Value'));
    set(handles.text18, 'String', globalStudyInfo.end_frame);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
