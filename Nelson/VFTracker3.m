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

% Last Modified by GUIDE v2.5 08-Aug-2017 18:50:31

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

%setting theme of application
%  set(0,'defaultUicontrolBackgroundColor',[.212 .212 .212]);
 set(0,'defaultUicontrolBackgroundColor',[.94 .94 .94]);
 set(0,'defaultUicontrolForegroundColor',[0 0 0]);
% set(hObject,'Color', [.212 .212 .212]);


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
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

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
if ~isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
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

    [fileName, pathName] = uigetfile({'*.mp4;*.mov;*.avi;*.flv;*.wmv',...
                                      'Video Files (*.mp4,*.mov,*.avi,*.flv,*.wmv)';...
                                      '*.*', 'All Files (*.*)'});
                                  

    fullFileName = strcat(pathName, fileName);
    
    %store file name and path for use in kinematicsbutton
    setappdata(handles.kinematicsButton,'fullFileName',fullFileName)
    

    
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
%     globalStudyInfo.pas_coordinates = {0,0,0};

    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    
    %Add a listener to listen to the value property of the frameScrubber to
    %update the frameNumberIndicator
    addlistener(handles.frameScrubber,'Value','PostSet',@(hFigure, eventdata) frameNumberListener(handles.appFigure, eventdata));

    %Add the handler for the frame scrubber
    addlistener(handles.frameScrubber,'ContinuousValueChange', ...
                                      @(hFigure,eventdata) slider1ContValCallback(...
                                        handles.appFigure,eventdata));
        
    
    %Storing the files from nelson's excel file in handles   
    [pressure_filename, pressure_pathname] = uigetfile({'*.xls;*.xlsx',...
                                      'Excel Files (*.xls, *.xlsx)';...
                                      '*.*', 'All Files (*.*)'});
    [num,txt,raw] = xlsread(fullfile(pressure_pathname,pressure_filename));
    pressure.num = num;
    pressure.txt = txt;
    pressure.raw = raw;
    pressure.fullfile = fullfile(pressure_pathname,pressure_filename);
    pressure.max_index = [];
    globalStudyInfo.pressure = pressure; 
    
    %display file name
    handles.text11.String = [fileName ' & ' pressure_filename];
    
    %adjust filename font until entire file name fits on screen.
    for fontSize = [22,20,18,16,14,12,10,9,8,7,6,5,4]
        set(handles.text11,'FontSize',fontSize)
        titleExtent = get(handles.text11,'Extent');
        titleSize = handles.text11.Position;
        titleWidth = titleSize(3);
        if titleExtent(3) < titleWidth
            break;
        end
    end
    
    uicontrol(handles.frameScrubber);
    
    %filling table with frame numbers
    data = num2cell([1:vfVideoStructure.numFrames]');
    data = [data,cell(vfVideoStructure.numFrames,1)];
    data = [{'Frame #','UES Sensor'};data];
    handles.ues_table.Data = data;
    handles.ues_table.ColumnEditable = [false,true];
    
    %Initialize the frame scrubber control
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
        
        if exist(fullfile(pathStr,[name, '_morphoj_.txt']),'file')
            %loading frame information for push buttons.
            morphoJTable = readtable(fullfile(pathStr,[name, '_morphoj_.txt']),'Delimiter','\t', 'ReadVariableNames',false);
            morphoJTable = table2cell(morphoJTable);
            
            %skip this step if no push button information is found, as in
            %the case of the old tracker tool's morphoJ files.
            if ~strcmpi(morphoJTable{1,1},'FrameNumber')
                
                %this for loop reads the first two rows of the morphoJ file
                %and loads the variables into globalStudyInfo. Each
                %variable is named based on the first row of the morphoJ
                %file and each variable's value is based on the second row
                %of the morphoJ file. These values are then loaded into the 
                % appropriate text boxes. The exception is the si point values
                %which have to be loaded separately
                calibration_points = struct;
                for j = 1:length(morphoJTable(1,:))
                    if strcmp(morphoJTable{1,j},'si_point1_x') || strcmp(morphoJTable{1,j},'si_point1_y') || ...
                            strcmp(morphoJTable{1,j},'si_point2_x') || strcmp(morphoJTable{1,j},'si_point2_y')
                        
                        calibration_points.(morphoJTable{1,j}) = str2double(morphoJTable{2,j});
                        if isnan(calibration_points.(morphoJTable{1,j}))
                           calibration_points.(morphoJTable{1,j}) = [];
                        end
                    elseif strcmp(morphoJTable{1,j},'point1_x') || strcmp(morphoJTable{1,j},'point1_y') || ...
                           strcmp(morphoJTable{1,j},'point2_x') || strcmp(morphoJTable{1,j},'point2_y')
                        
                        calibration_points.(strcat('si_', morphoJTable{1,j})) = str2double(morphoJTable{2,j});
                        if isnan(calibration_points.(strcat('si_', morphoJTable{1,j})))
                           calibration_points.(strcat('si_', morphoJTable{1,j})) = [];
                        end
                        
                    %converting number from morphoJ into an array for
                    %pas_classifiers
                    elseif strcmp(morphoJTable{1,j},'pas_classifiers')
                        globalStudyInfo.(morphoJTable{1,j}) = ...
                            [floor(str2double(morphoJTable{2,j}) / 100), ...
                            floor(mod(str2double(morphoJTable{2,j}),100) / 10) , ...
                            mod(str2double(morphoJTable{2,j}),10)];
                        
                        if(globalStudyInfo.pas_classifiers(1) == 2)
                            set(handles.beforePAS, 'Value', 1);
                        end
                        if(globalStudyInfo.pas_classifiers(2) == 2)
                            set(handles.duringPAS, 'Value', 1);
                        end
                        if(globalStudyInfo.pas_classifiers(3) == 2)
                            set(handles.afterPAS, 'Value', 1);
                        end
                        
                    elseif strcmp(morphoJTable{1,j},'frameRate') || strcmp(morphoJTable{1,j},'')
                        %if frameRate is stored, we do not want to load it.
                        %The value will be extracted from video file later.
                        %otherwise, if the value is blank, it means there
                        %are extraneous columns in the _morphoJ file,
                        %ignore those too.
                    elseif isprop(globalStudyInfo,morphoJTable{1,j})
                        globalStudyInfo.(morphoJTable{1,j}) = str2double(morphoJTable{2,j});
                        if isnan(globalStudyInfo.(morphoJTable{1,j}))
                           globalStudyInfo.(morphoJTable{1,j}) = [];
                        end
                        
                        if isfield(handles,[morphoJTable{1,j} '_text'])
                            set(handles.([morphoJTable{1,j} '_text']), 'String', globalStudyInfo.(morphoJTable{1,j}));
                        end
                        
                    else
                        Utilities.CustomPrinters.printError(sprintf('Error on reading "%s\" from _morphoJ_ file \n', morphoJTable{1,j}));
                        if strcmp('holdarea', morphoJTable{1,j})
                            continue;
                        end
                        error('Something went wrong with loading the _morphoJ_ file!')         
                    end
                    
                end
                
                globalStudyInfo.si_point1 = [calibration_points.si_point1_x,calibration_points.si_point1_y];
                globalStudyInfo.si_point2 = [calibration_points.si_point2_x,calibration_points.si_point2_y];

                if isempty(globalStudyInfo.si_point1) || isempty(globalStudyInfo.si_point2)
                    estSize = '';
                    set(handles.estSize, 'String', num2str(estSize));
                else
                    set(handles.si_point1_text, 'String', sprintf('%-.2f, \t %-.2f',globalStudyInfo.si_point1(1),globalStudyInfo.si_point1(2)));
                    set(handles.si_point2_text, 'String', sprintf('%-.2f, \t %-.2f',globalStudyInfo.si_point1(1),globalStudyInfo.si_point1(2)));
                
                    bothPoints = [globalStudyInfo.si_point1(1),globalStudyInfo.si_point1(2);globalStudyInfo.si_point2(1),globalStudyInfo.si_point2(2)];
                    bothPoints_dist = coordinates_dist(bothPoints);

                    estSize = bothPoints_dist / globalStudyInfo.pixelspercm;
                    set(handles.estSize, 'String', num2str(estSize));
                end

            end
        end

        %set calibration button font to red if calibration is not found, to
        %green if calibration is found
        if ~isempty(globalStudyInfo.pixelspercm) && globalStudyInfo.pixelspercm > 0
            handles.unitCalibrationButton.ForegroundColor = [0 1 0];
        else
            handles.unitCalibrationButton.ForegroundColor = [1 0 0];
        end
        
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
    uicontrol(handles.frameScrubber); %prevents click off problem
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

function dist = coordinates_dist(points)
    dist = sqrt((points(1,1) - points(2,1))^2 + (points(1,2) - points(2,2))^2);

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
if ~isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
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
if ~isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
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
% This is not being used.
function appFigure_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to appFigure (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
% 	Key: name of the key that was pressed, in lower case
% 	Character: character interpretation of the key(s) that was pressed
% 	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

appFigure_WindowKeyPressFcn(hObject, eventdata, handles);



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
            showFeedbackPopup(handles,'No corners detected',3);
        else
%            disp('corners detected');
            Utilities.CustomPrinters.printInfo('Harris corner detected');
            cornersFound = true;
            showFeedbackPopup(handles,'No corners detected',0);
        end
    end
    
    
    showFeedbackPopup(handles,'Tracking...',1);
    
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
     showFeedbackPopup(handles,'Tracking is done',2);
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
totalFrames = globalStudyInfo.vfVideoStructure.numFrames;

    
switch(lower(eventdata.Key))
    case 's'
        performTracking(handles);
    case 'q'
        close(handles.appFigure);
    case 'm'
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
    case 'rightarrow'
        %frameScrubber
        currentFrame = get(handles.frameScrubber, 'Value');
        
        if (currentFrame ~= totalFrames)
            currentFrame = currentFrame + 1;
        end

        set(handles.frameScrubber, 'Value', currentFrame);
        uicontrol(handles.frameScrubber);
    
    case 'leftarrow'
        %frameScrubber
        currentFrame = get(handles.frameScrubber, 'Value');
        
        if (currentFrame ~= 1)
            currentFrame = currentFrame - 1;
        end

        set(handles.frameScrubber, 'Value', currentFrame);          
        uicontrol(handles.frameScrubber);

%     %'i' for interpolation
%     case 'i'
%         userQuery = inputdlg('Enter start and end frame numbers');
%         userQuery = userQuery{1};
%         userQuery = str2num(userQuery);
%         startFrame = userQuery(1);
%         endFrame = userQuery(2);
%         Interpolater(handles, startFrame, endFrame);
    case 'escape'
        return;
end


% --------------------------------------------------------------------
function saveButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
oldFeedbackLabelMessage = get(handles.feedbackLabel, 'String');
% set(handles.feedbackLabel, 'String', 'Saving...');
showFeedbackPopup(handles, 'Saving...',1);

drawnow()
Utilities.ResultFileWriter(globalStudyInfo);
showFeedbackPopup(handles, 'Saved', 2);


%allows you to display text to the screen
function showFeedbackPopup(handles, string, visibility)
    if (visibility == 1)
        set(handles.feedbackPanel, 'visible', 'on');
        set(handles.feedbackLabel, 'String', string);
    elseif (visibility == 0)
        set(handles.feedbackLabel, 'String', '');
        set(handles.feedbackPanel, 'visible', 'off');
    elseif (visibility == 2)
        set(handles.feedbackPanel, 'BackgroundColor', 'green');
        set(handles.feedbackLabel, 'BackgroundColor', 'green');
        set(handles.feedbackLabel, 'ForegroundColor', 'black');
        set(handles.feedbackPanel, 'visible', 'on');
        set(handles.feedbackLabel, 'String', string);
        pause(.5)
        set(handles.feedbackLabel, 'String', '');
        set(handles.feedbackPanel, 'visible', 'off');
        set(handles.feedbackPanel, 'BackgroundColor', 'red');
        set(handles.feedbackLabel, 'BackgroundColor', 'red');
        set(handles.feedbackLabel, 'ForegroundColor', 'white');
    elseif (visibility == 3)
        set(handles.feedbackPanel, 'BackgroundColor', 'yellow');
        set(handles.feedbackLabel, 'BackgroundColor', 'yellow');
        set(handles.feedbackLabel, 'ForegroundColor', 'black');
        set(handles.feedbackPanel, 'visible', 'on');
        set(handles.feedbackLabel, 'String', string);
        pause(.5)
        set(handles.feedbackLabel, 'String', '');
        set(handles.feedbackPanel, 'visible', 'off');
        set(handles.feedbackPanel, 'BackgroundColor', 'red');
        set(handles.feedbackLabel, 'BackgroundColor', 'red');
        set(handles.feedbackLabel, 'ForegroundColor', 'white');
    end
    
    
% --------------------------------------------------------------------
function WriteHighResVideo_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to WriteHighResVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%display "saving video" in top left corner
showFeedbackPopup(handles, 'Saving...',1);

drawnow()
    
VideoWriterCallback(handles, 'high');   

showFeedbackPopup(handles, 'Saved',2);
    
    
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

%display "saving video" in top left corner
showFeedbackPopup(handles, 'Saving...',1);
drawnow()
    
VideoWriterCallback(handles, 'low');

showFeedbackPopup(handles, 'Saved',2);
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
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
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

   %Insert the frame number at the bottom right
   frameSize = size(currentFrame);
   AnchorPoint = 'LeftBottom';
   currentFrame = insertText(currentFrame, [1 frameSize(1)], sprintf('%d / %d', i, numFrames),'AnchorPoint', AnchorPoint);
   
   
   %Insert push button frames
   if i == globalStudyInfo.start_frame
       position_x = floor(frameSize(2)/4);
       position_y = frameSize(1);
       AnchorPoint = 'LeftBottom';
       currentFrame = insertText(currentFrame,[position_x position_y], 'Start Frame','AnchorPoint', AnchorPoint);
       
   elseif i == globalStudyInfo.end_frame
       position_x = floor(frameSize(2)/4);
       position_y = frameSize(1);
       AnchorPoint = 'LeftBottom';
       currentFrame = insertText(currentFrame,[position_x position_y], 'End Frame','AnchorPoint', AnchorPoint);
   end
   
   repeatCounter = 0;
   
   if i == globalStudyInfo.hold_position
       position_x = floor(frameSize(2)*3/4);
       position_y = frameSize(1);
       AnchorPoint = 'RightBottom';
       currentFrame = insertText(currentFrame,[position_x position_y], 'Hold Position', 'AnchorPoint', AnchorPoint);
       repeatCounter = repeatCounter + 1;
   end
       
   if i == globalStudyInfo.ramus_mandible
       frameSize = size(currentFrame);
       position_x = floor(frameSize(2)*3/4);
       position_y = frameSize(1);
       AnchorPoint = 'RightBottom';
       if repeatCounter == 1
           AnchorPoint = 'LeftBottom';
       end
       currentFrame = insertText(currentFrame,[position_x position_y], 'Ramus Mandible', 'AnchorPoint', AnchorPoint);
       repeatCounter = repeatCounter + 1;
   end
       
   if i == globalStudyInfo.hyoid_burst
       position_x = floor(frameSize(2)*3/4);
       position_y = frameSize(1);
       AnchorPoint = 'RightBottom';
       if repeatCounter == 1
           AnchorPoint = 'LeftBottom';
       elseif repeatCounter == 2
           AnchorPoint = 'RightBottom';
           position_y = floor(0.92*frameSize(1));
       end
       currentFrame = insertText(currentFrame,[position_x position_y], 'Hyoid Burst', 'AnchorPoint', AnchorPoint);
       repeatCounter = repeatCounter + 1;
   end
       
   if i == globalStudyInfo.ues_closure
       position_x = floor(frameSize(2)*3/4);
       position_y = frameSize(1);
       AnchorPoint = 'RightBottom';
       if repeatCounter == 1
           AnchorPoint = 'LeftBottom';
       elseif repeatCounter == 2
           AnchorPoint = 'RightBottom';
           position_y = floor(0.92*frameSize(1));
       elseif repeatCounter == 3
           AnchorPoint = 'LeftBottom';
           position_y = floor(.92*frameSize(1));
       end
       currentFrame = insertText(currentFrame,[position_x position_y], 'UES Closure', 'AnchorPoint', AnchorPoint);
       repeatCounter = repeatCounter + 1;
   end
   
   if i == globalStudyInfo.at_rest
       position_x = floor(frameSize(2)*3/4);
       position_y = frameSize(1);
       AnchorPoint = 'RightBottom';
       if repeatCounter == 1
           AnchorPoint = 'LeftBottom';
       elseif repeatCounter == 2
           AnchorPoint = 'RightBottom';
           position_y = floor(0.92*frameSize(1));
       elseif repeatCounter == 3
           AnchorPoint = 'LeftBottom';
           position_y = floor(0.92*frameSize(1));
       elseif repeatCounter == 4;
           AnchorPoint = 'RightBottom';
           position_x = frameSize(2);
       end
       currentFrame = insertText(currentFrame,[position_x position_y], 'At Rest', 'AnchorPoint', AnchorPoint);
   end
       
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
uicontrol(handles.frameScrubber);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.hold_position = floor(get(handles.frameScrubber, 'Value'));
    set(handles.hold_position_text, 'String', globalStudyInfo.hold_position);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    uicontrol(handles.frameScrubber);
    
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.ramus_mandible = floor(get(handles.frameScrubber, 'Value'));
    set(handles.ramus_mandible_text, 'String', globalStudyInfo.ramus_mandible);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    uicontrol(handles.frameScrubber);
    
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.hyoid_burst = floor(get(handles.frameScrubber, 'Value'));
    set(handles.hyoid_burst_text, 'String', globalStudyInfo.hyoid_burst);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    uicontrol(handles.frameScrubber);
    
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.ues_closure = floor(get(handles.frameScrubber, 'Value'));
    set(handles.ues_closure_text, 'String', globalStudyInfo.ues_closure);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    uicontrol(handles.frameScrubber);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.at_rest = floor(get(handles.frameScrubber, 'Value'));
    set(handles.at_rest_text, 'String', globalStudyInfo.at_rest);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    uicontrol(handles.frameScrubber);

% --- Executes on button press in deletebutton.
function deletebutton_Callback(hObject, eventdata, handles)
% hObject    handle to deletebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    currentFrameIndex = floor(get(handles.frameScrubber, 'Value'));
    currentLandmark = globalStudyInfo.currentlyTrackedLandmark;
    numFramesTotal = globalStudyInfo.vfVideoStructure.numFrames;
    globalStudyInfo.studyCoordinates.deleteLaterCoordinates(currentFrameIndex, numFramesTotal, currentLandmark);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    Render(handles);
    uicontrol(handles.frameScrubber);

% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.start_frame = floor(get(handles.frameScrubber, 'Value'));
    set(handles.start_frame_text, 'String', globalStudyInfo.start_frame);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    uicontrol(handles.frameScrubber);

% --- Executes on button press in endButton.
function endButton_Callback(hObject, eventdata, handles)
% hObject    handle to endButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.end_frame = floor(get(handles.frameScrubber, 'Value'));
    set(handles.end_frame_text, 'String', globalStudyInfo.end_frame);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    uicontrol(handles.frameScrubber);
% --- Executes on button press in laryngeal vestibule closing.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.lvc_onset = floor(get(handles.frameScrubber, 'Value'));
    set(handles.lvc_onset_text, 'String', globalStudyInfo.lvc_onset);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    uicontrol(handles.frameScrubber);

% --- Executes on button press for laryngeal vestibule opening.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.lvc_offset = floor(get(handles.frameScrubber, 'Value'));
    set(handles.lvc_offset_text, 'String', globalStudyInfo.lvc_offset);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    uicontrol(handles.frameScrubber);

% --- Executes on button press in pushbutton16 - ues opening.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.ues_opening = floor(get(handles.frameScrubber, 'Value'));
    set(handles.ues_opening_text, 'String', globalStudyInfo.ues_opening);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    uicontrol(handles.frameScrubber);

% --- Executes on button press in pushbutton17 - laryngeal jump.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    globalStudyInfo.laryngeal_jump = floor(get(handles.frameScrubber, 'Value'));
    set(handles.laryngeal_jump_text, 'String', globalStudyInfo.laryngeal_jump);
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    uicontrol(handles.frameScrubber);


% --- Executes during object creation, after setting all properties.
function numPyramidLevelsLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numPyramidLevelsLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% set(hObject,'BackgroundColor',[.21 .21 .21]);
% set(hObject,'Font',[1 1 1]);
% set(hObject, 'Parent', handles.semiautoPanel);


% --- Executes during object creation, after setting all properties.
function text11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
% set(hObject,'ForegroundColor',[1 1 1]);


% --- Executes on key press with focus on text21 and none of its controls.
function text21_Callback(hObject, eventdata, handles)
% hObject    handle to text21 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
button_state = get(hObject,'Value');

if button_state == get(hObject,'Max')
    set(handles.semiautoPanel, 'visible', 'on');
    set(handles.unitCalibrationPanel, 'visible', 'off');

elseif button_state == get(hObject,'Min')
    set(handles.semiautoPanel, 'visible', 'off');
    set(handles.unitCalibrationPanel, 'visible', 'off');
end

drawnow();


% --- Executes during object creation, after setting all properties.
function semiautoPanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to semiautoPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'visible', 'off');

function estSize_Callback(hObject, eventdata, handles)
% hObject    handle to estSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of estSize as text
%        str2double(get(hObject,'String')) returns contents of estSize as a double
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    
    if(isempty(globalStudyInfo.si_point1) || isempty(globalStudyInfo.si_point2))
        showFeedbackPopup(handles,'Please Track Points',1);

    else
        if(isnan(str2double(get(hObject,'String'))))
            showFeedbackPopup(handles,'Please Enter Valid Number',1);
        end
        bothPoints = [globalStudyInfo.si_point1(1),globalStudyInfo.si_point1(2);globalStudyInfo.si_point2(1),globalStudyInfo.si_point2(2)];
        bothPoints_dist = coordinates_dist(bothPoints);
        %bothPoints_dist2 = pdist(bothPoints, 'euclidean');

        estSize = str2double(get(hObject,'String'));
        globalStudyInfo.pixelspercm = bothPoints_dist / estSize;
        set(handles.pixelspercm_text, 'String', num2str(globalStudyInfo.pixelspercm));
        showFeedbackPopup(handles,'SI Scalar Calculated',2);

    end
    
    %Change the font color of the calibration button if calibration has
    %been completed.
    if ~isempty(globalStudyInfo.pixelspercm) && globalStudyInfo.pixelspercm > 0 && globalStudyInfo.pixelspercm < 10e6
        handles.unitCalibrationButton.ForegroundColor = [0 1 0];
    else
        handles.unitCalibrationButton.ForegroundColor = [1 0 0];
        
    end
    
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);


% --- Executes during object creation, after setting all properties.
function estSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to estSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calibrateSIbutton.
function calibrateSIbutton_Callback(hObject, eventdata, handles)
% hObject    handle to calibrateSIbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    button_state = get(hObject,'Value');
    
    if (button_state == get(hObject,'Max'))
        set(hObject,'String','Click one edge');

        [x, y] = mygetpts();
        globalStudyInfo.si_point1 = [x(1) y(1)];
        set(handles.si_point1_text, 'String', sprintf('%-.2f  ,  %-.2f',x,y));
        set(hObject,'String','Click opposite edge');
        showFeedbackPopup(handles,'Point 1 Tracked',2);

        [x, y] = mygetpts();
        globalStudyInfo.si_point2 = [x(1) y(1)];
        set(handles.si_point2_text, 'String', sprintf('%-.2f  ,  %-.2f',x,y));
        set(hObject,'String','Calibrate SI Units');
        set(hObject,'Value',0);
        showFeedbackPopup(handles,'Point 2 Tracked',2);
    end
        
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over estSize.
function estSize_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to estSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'String', '');
set(hObject, 'enable', 'on');
uicontrol(hObject);

function kineBool = checkStartEndFrames(handles)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    if (isempty(globalStudyInfo.start_frame) || isempty(globalStudyInfo.end_frame))
        kineBool = false;
        warningMessage = sprintf('Error: Cannot display kinematics because start and end frames not designated. Please assign these frames.');
        uiwait(msgbox(warningMessage));
    else
        kineBool = true;
    end

% --- Executes on button press in kinematicsButton.
function kinematicsButton_Callback(hObject, eventdata, handles)
% hObject    handle to kinematicsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if (checkStartEndFrames(handles))
        %automatically saving the file
        saveButton_ClickedCallback(hObject, eventdata, handles);

        %close previous window if it exists
        close(findobj('type','figure','name','Kinematic Variables'))

        % %retreive file path information stored in initialize
        fullFileName = getappdata(handles.kinematicsButton,'fullFileName');
        [pathstr name ext] = fileparts(fullFileName);

        if exist([fullFileName(1:end-length(ext)) '_morphoj_.txt'],'file')

        %     %change directory
        %     cd Compiler

            %run compiler
            kinematicValues = Compiler(fullFileName);

        %     %return directory
        %     cd ../

            %create table and format
            h = figure('Visible','off','Name','Kinematic Variables','NumberTitle','off', 'MenuBar', 'none', 'ToolBar' , 'none');
            u = uitable(h,'Data',kinematicValues);
            columnWidth = fitColumns(u.Data);
            u.ColumnWidth = columnWidth;
            table_extent = get(u,'Extent');
            figure_size = get(h,'outerposition');
            desired_fig_size = [figure_size(1) figure_size(2) table_extent(3)+36 table_extent(4)+65];
            set(u,'Position',[1 20 table_extent(3)+35 table_extent(4)])
            set(h,'outerposition', desired_fig_size);
            set(h,'Visible','on');

        else
            warningMessage = sprintf('WARNING: Cannot display kinematics because file does not exist. Click "save" first!');
            uiwait(msgbox(warningMessage));
        end
    end

function columnWidth = fitColumns(data)
    dataSize = size(data);
    maxLen = zeros(1,dataSize(2));
    for i = 1:dataSize(2)
        for j = 1:dataSize(1)
            len = length(data{j,i});
            if j == 1
                len = length(data{j,i}) - length('<html><b></b><html>');
            end
            
            if(len>maxLen(1,i))
                maxLen(1,i) = len;
            end
           
        end
        if maxLen(1,i) < 5
            maxLen(1,i) = 7;
        end
    end
    
    columnWidth = num2cell(maxLen*6);

% --- Executes on button press in unitCalibrationButton.
function unitCalibrationButton_Callback(hObject, eventdata, handles)
% hObject    handle to unitCalibrationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of unitCalibrationButton

button_state = get(hObject,'Value');

if button_state == get(hObject,'Max')
    set(handles.unitCalibrationPanel, 'visible', 'on');
    set(handles.semiautoPanel, 'visible', 'off');
%     set(handles.text21, 'visible', 'off');
%     set(handles.noiseFilterLevelSlider, 'visible', 'off');
%     set(handles.gammaAdjustSlider, 'visible', 'off');
%     set(handles.noiseFilterLevelIndicator, 'visible', 'off');
%     set(handles.gammaAdjustLevelIndicator, 'visible', 'off');

elseif button_state == get(hObject,'Min')
    set(handles.unitCalibrationPanel, 'visible', 'off');
%     set(handles.semiautoPanel, 'visible', 'on');
%     set(handles.text21, 'visible', 'on');
%     set(handles.noiseFilterLevelSlider, 'visible', 'on');
%     set(handles.gammaAdjustSlider, 'visible', 'on');
%     set(handles.noiseFilterLevelIndicator, 'visible', 'on');
%     set(handles.gammaAdjustLevelIndicator, 'visible', 'on');
end

drawnow();

% --- Executes during object creation, after setting all properties.
function unitCalibrationPanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unitCalibrationPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'visible', 'off');

% --------------------------------------------------------------------
function customZoom_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to customZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.zoomHandle = zoom;
handles.zoomHandle.ActionPostCallback = {@un_zoom,handles};
handles.zoomHandle.Enable = 'on';
%

function un_zoom(obj,evd,handles)
    
persistent chk
if isempty(chk)
      chk = 1;
      pause(0.3); %Add a delay to distinguish single click from a double click
      if chk == 1
        chk = [];
        handles.zoomHandle.ModeHandle.Blocking = false;
        handles.zoomHandle.Enable = 'off';
        handles.zoomHandle.ActionPostCallback = [];
      end
else
      chk = [];
      zoom out
      zoom reset
      handles.zoomHandle.ModeHandle.Blocking = false;
      handles.zoomHandle.Enable = 'off';
      handles.zoomHandle.ActionPostCallback = [];
end


% --- Executes on key press with focus on frameScrubber and none of its controls.
function frameScrubber_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to frameScrubber (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch(lower(eventdata.Key))
    case '1'
        startButton_Callback(hObject, eventdata, handles);
    case '2'
        pushbutton1_Callback(hObject, eventdata, handles);
    case '3'
        pushbutton2_Callback(hObject, eventdata, handles);
    case '4'
        pushbutton3_Callback(hObject, eventdata, handles);
    case '5'
        pushbutton4_Callback(hObject, eventdata, handles);
    case '6'
        pushbutton5_Callback(hObject, eventdata, handles);
    case '7'
        endButton_Callback(hObject, eventdata, handles);
end

% --------------------------------------------------------------------
function legendToggle_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to legendToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(hObject, 'State', 'Off');
    h = msgbox({'Shortcuts' '' 's - Semiautomatic tracking' 'm - Manual tracking' 'p - Pointer' '' ...
        'Right Arrow - Increase Frame Number +1' 'Left Arrow - Increase Frame Number - 1' '' ...
        '1 - Start Frame' '2 - Hold Position' '3 - Ramus of Mandible' '4 - Hyoid Burst' '5 - UES Closure' '6 - At Rest' '7 - End Frame' '' ...
        'Kinematics' '' 'ahm - Anterior Hyoid Movement' 'shm - Superior Hyoid Movement'...
        'hyExMand - Hyoid Excursion To Mandible' 'hyExC4 - Hyoid Excursion To Only C4' ...
        'hyExVert - Hyoid Excursion To Vertebrae (C1-C4)'  ...
        'alm - Anterior Laryngeal Movement' 'slm - Superior Laryngeal Movement' ...
        'hla - Hyolaryngeal Approximation' 'le - Laryngeal Elevation' ...
        'ps - Pharyngeal Shortening' 'botrr - Base of Tongue Retraction Ratio' ''...
        'ott - Oral Transport Time' 'std - Stage Transition Duration' ...
        'ptt - Pharyngeal Transport Time' 'optt - Oropharyngeal Transport Time' ...
        'pdt - Pharyngeal Delay Time' 'lvc - Laryngeal Vestibule Closure Duration' ...
        'uesod - UES Opening Duration' 'hmd - Hyoid Movement Duration' ...
        'lvcrt - Laryngeal Vestibule Closure Reaction Time' '' ...
        'nrrs_val - National Residue Ratio Scale for Valleculae' ...
        'nrrs_piri - National Residue Ratio Scale for Piriform' ...
        'pcr - Pharyngeal Constriction Ratio'...
        'ePCR - Experimental Pharyngeal Constriction Ratio using Coordinates'...
        'pas - Penetration Aspiration Scale'...
        'ues_dist - UES Distension' ...
        '' 'Suffixes' ''...
        '_vert - Normalized to the length of C2-C4' ... 
        '_si - Normalized to the size of the coin on the screen'});


% --- Executes on button press in pcr_min_area_button.
function pcr_min_area_button_Callback(hObject, eventdata, handles)
% hObject    handle to pcr_min_area_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pcr_min_area_button
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    button_state = get(hObject,'Value');
    allPoints = [0,0];
    
    if (button_state == get(hObject,'Max'))
        [x, y] = mygetline(handles.frameViewer);
        allPoints = [x,y];
        
        showFeedbackPopup(handles,sprintf('Total %d Points Tracked', length(x)), 2);
        set(hObject,'Value',0);
    end
    
    pcr = 0;
    numPoints = size(allPoints,1);
    
    for i = 1:numPoints
        if numPoints == 1
            disp('Only 1 point selected, PCR will not be calculated');
            break;
        end
        
        % Coordinate based area calculation
        if i == numPoints
            pcr = pcr + ((allPoints(i,1) * allPoints(mod(i+1,numPoints),2)) ...
                - (allPoints(i,2) * allPoints(mod(i+1,numPoints),1)));
            
            pcr = abs(pcr / 2);
            showFeedbackPopup(handles, sprintf('PCR: %-.2f', pcr), 2);
            Utilities.CustomPrinters.printInfo(sprintf('PCR: %-.2f', pcr));
        else
            pcr = pcr + ((allPoints(i,1) * allPoints(i+1,2)) ...
                - (allPoints(i,2) * allPoints(i+1,1)));
        end
    end
    
    if numPoints>2
        globalStudyInfo.pcr_min_points = allPoints;
        globalStudyInfo.pcr_min_area = pcr;
        handles.pcr_min_area_text.String = num2str(pcr);
        setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    end

% --- Executes on button press in pcr_max_area_button.
function pcr_max_area_button_Callback(hObject, eventdata, handles)
% hObject    handle to pcr_max_area_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pcr_max_area_button
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    button_state = get(hObject,'Value');
    allPoints = [0,0];
    
    if (button_state == get(hObject,'Max'))
        [x, y] = mygetline(handles.frameViewer);
        allPoints = [x,y];
        
        showFeedbackPopup(handles,sprintf('Total %d Points Tracked', length(x)), 2);
        set(hObject,'Value',0);
    end
    
    pcr = 0;
    numPoints = size(allPoints,1);
    
    for i = 1:numPoints
        if numPoints == 1
            disp('Only 1 point selected, PCR will not be calculated');
            break;
        end
        
        % Coordinate based area calculation
        if i == numPoints
            pcr = pcr + ((allPoints(i,1) * allPoints(mod(i+1,numPoints),2)) ...
                - (allPoints(i,2) * allPoints(mod(i+1,numPoints),1)));
            
            pcr = abs(pcr / 2);
            showFeedbackPopup(handles, sprintf('PCR: %-.2f', pcr), 2);
            Utilities.CustomPrinters.printInfo(sprintf('PCR: %-.2f', pcr));
        else
            pcr = pcr + ((allPoints(i,1) * allPoints(i+1,2)) ...
                - (allPoints(i,2) * allPoints(i+1,1)));
        end
    end
    
    if numPoints>2
        globalStudyInfo.pcr_max_points = allPoints;
        globalStudyInfo.pcr_max_area = pcr;
        handles.pcr_max_area_text.String = num2str(pcr);

        setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    end


% --------------------------------------------------------------------
function openFileButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to openFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close('VFTracker3');
    VFTracker3;

% --------------------------------------------------------------------
function semiautoOptions_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to semiautoPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    button_state = get(hObject,'State');
    
    switch button_state
        case 'on'
            set(handles.semiautoPanel, 'visible', 'on');
            set(handles.unitCalibrationPanel, 'visible', 'off');
        case 'off'
            set(handles.semiautoPanel, 'visible', 'off');
            set(handles.unitCalibrationPanel, 'visible', 'off');
    end

% --- Executes during object creation, after setting all properties.
function semiautoOptions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to semiautoOptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    set(hObject, 'State', 'off');

% --- Executes on button press in valres_toggle.
function valres_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to valres_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of valres_toggle
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    button_state = get(hObject,'Value');
    allPoints = [0,0];
    
    if (button_state == get(hObject,'Max'))
        
        [x, y] = mygetline(handles.frameViewer);
        allPoints = [x,y];
        
        showFeedbackPopup(handles,sprintf('Total %d Points Tracked', length(x)), 2);
        set(hObject,'String','Valleculae Residue');
        set(hObject,'Value',0);
    end
    
    valres_area = 0;
    numPoints = size(allPoints,1);
    
    for i = 1:numPoints
        if numPoints == 1
            disp('Only 1 point selected, Valleculae Residue will not be calculated');
            break;
        end
        
        % Coordinate based area calculation
        if i == numPoints
            valres_area = valres_area + ((allPoints(i,1) * allPoints(mod(i+1,numPoints),2)) ...
                - (allPoints(i,2) * allPoints(mod(i+1,numPoints),1)));
            
            valres_area = abs(valres_area / 2);
            showFeedbackPopup(handles, sprintf('Val Res Area: %-.2f', valres_area), 2);
            Utilities.CustomPrinters.printInfo(sprintf('Val Res Area: %-.2f', valres_area));
        else
            valres_area = valres_area + ((allPoints(i,1) * allPoints(i+1,2)) ...
                - (allPoints(i,2) * allPoints(i+1,1)));
        end
    end

    
    if numPoints>2
        globalStudyInfo.nrrs_valres_points = allPoints;
        globalStudyInfo.nrrs_valres_area = valres_area;
        handles.nrrs_valres_area_text.String = num2str(valres_area);
        setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    end
    
% --- Executes on button press in valarea_toggle.
function valarea_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to valarea_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of valarea_toggle
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    button_state = get(hObject,'Value');
    allPoints = [0,0];
    
    if (button_state == get(hObject,'Max'))
        
        [x, y] = mygetline(handles.frameViewer);
        allPoints = [x,y];
        
        showFeedbackPopup(handles,sprintf('Total %d Points Tracked', length(x)), 2);
        set(hObject,'String','Valleculae Area');
        set(hObject,'Value',0);
    end
    
    totalval_area = 0;
    numPoints = size(allPoints,1);
    
    for i = 1:numPoints
        if numPoints == 1
            disp('Only 1 point selected, Total Valleculae Area will not be calculated');
            break;
        end
        
        % Coordinate based area calculation
        if i == numPoints
            totalval_area = totalval_area + ((allPoints(i,1) * allPoints(mod(i+1,numPoints),2)) ...
                - (allPoints(i,2) * allPoints(mod(i+1,numPoints),1)));
            
            totalval_area = abs(totalval_area / 2);
            showFeedbackPopup(handles, sprintf('Total Valleculae Area: %-.2f', totalval_area), 2);
            Utilities.CustomPrinters.printInfo(sprintf('Total Valleculae Area: %-.2f', totalval_area));
        else
            totalval_area = totalval_area + ((allPoints(i,1) * allPoints(i+1,2)) ...
                - (allPoints(i,2) * allPoints(i+1,1)));
        end
    end
    
    if numPoints>2
        globalStudyInfo.nrrs_totalval_points = allPoints;
        globalStudyInfo.nrrs_totalval_area = totalval_area;
        handles.nrrs_totalval_area_text.String = num2str(totalval_area);

        setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    end
    
% --- Executes on button press in pirires_toggle.
function pirires_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to pirires_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pirires_toggle
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    button_state = get(hObject,'Value');
    allPoints = [0,0];
    
    if (button_state == get(hObject,'Max'))
        
        [x, y] = mygetline(handles.frameViewer);
        allPoints = [x,y];
        
        showFeedbackPopup(handles,sprintf('Total %d Points Tracked', length(x)), 2);
        set(hObject,'String','Piriform Residue');
        set(hObject,'Value',0);
    end
    
    pirires_area = 0;
    numPoints = size(allPoints,1);
    
    for i = 1:numPoints
        if numPoints == 1
            disp('Only 1 point selected, Piriform Residue Area will not be calculated');
            break;
        end
        
        % Coordinate based area calculation
        if i == numPoints
            pirires_area = pirires_area + ((allPoints(i,1) * allPoints(mod(i+1,numPoints),2)) ...
                - (allPoints(i,2) * allPoints(mod(i+1,numPoints),1)));
            
            pirires_area = abs(pirires_area / 2);
            showFeedbackPopup(handles, sprintf('Piriform Residue Area: %-.2f', pirires_area), 2);
            Utilities.CustomPrinters.printInfo(sprintf('Piriform Residue Area: %-.2f', pirires_area));
        else
            pirires_area = pirires_area + ((allPoints(i,1) * allPoints(i+1,2)) ...
                - (allPoints(i,2) * allPoints(i+1,1)));
        end
    end
    
    if numPoints>2
        globalStudyInfo.nrrs_pirires_points = allPoints;
        globalStudyInfo.nrrs_pirires_area = pirires_area;
        handles.nrrs_pirires_area_text.String = num2str(pirires_area);
        setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    end
    

% --- Executes on button press in piriarea_toggle.
function piriarea_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to piriarea_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of piriarea_toggle
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    button_state = get(hObject,'Value');
    allPoints = [0,0];
    
    if (button_state == get(hObject,'Max'))
        
        [x, y] = mygetline(handles.frameViewer);
        allPoints = [x,y];
        
        showFeedbackPopup(handles,sprintf('Total %d Points Tracked', length(x)), 2);
        set(hObject,'String','Piriform Area');
        set(hObject,'Value',0);
    end
    
    totalpiri_area = 0;
    numPoints = size(allPoints,1);
    
    for i = 1:numPoints
        if numPoints == 1
            disp('Only 1 point selected, Total Piriform Area will not be calculated');
            break;
        end
        
        % Coordinate based area calculation
        if i == numPoints
            totalpiri_area = totalpiri_area + ((allPoints(i,1) * allPoints(mod(i+1,numPoints),2)) ...
                - (allPoints(i,2) * allPoints(mod(i+1,numPoints),1)));
            
            totalpiri_area = abs(totalpiri_area / 2);
            showFeedbackPopup(handles, sprintf('Total Piriform Area: %-.2f', totalpiri_area), 2);
            Utilities.CustomPrinters.printInfo(sprintf('Total Piriform Area: %-.2f', totalpiri_area));
        else
            totalpiri_area = totalpiri_area + ((allPoints(i,1) * allPoints(i+1,2)) ...
                - (allPoints(i,2) * allPoints(i+1,1)));
        end
    end
        

    if numPoints>2
        globalStudyInfo.nrrs_totalpiri_points = allPoints;
        globalStudyInfo.nrrs_totalpiri_area = totalpiri_area;
        handles.nrrs_totalpiri_area_text.String = num2str(totalpiri_area);
        setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    end
    
% --- Executes on button press in uesd_toggle.
function uesd_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to uesd_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of uesd_toggle
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    button_state = get(hObject,'Value');
    allPoints = [0,0];
    
    if (button_state == get(hObject,'Max'))
        %getting all points for distension distance
        allPoints = mygetline(handles.frameViewer);
        showFeedbackPopup(handles,sprintf('Total %d Points Tracked', size(allPoints, 1)), 2);
        set(hObject,'String','UES Distension');
        set(hObject,'Value',0);
    end
    
    if size(allPoints, 1) == 1
        disp('Only 1 point selected, UES distension will not be calculated');
        return;
    end

    uesd = coordinates_dist(allPoints);
    showFeedbackPopup(handles,sprintf('UES Distension: %-.2f', uesd), 2);

    if size(allPoints,1)>1
        globalStudyInfo.uesd_points = allPoints;
        globalStudyInfo.uesd_dist = uesd;
        handles.uesd_dist_text.String = num2str(uesd);
        setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
    end

% --- Executes on button press in pas_toggle.
function pas_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to pas_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pas_toggle
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    button_state = get(hObject,'Value');
    allPoints = [0,0];
    
    if (button_state == get(hObject,'Max'))
        set(handles.pas_panel,'Visible','on');
        set(handles.pas_text,'Visible','on');
        uicontrol(handles.pas_text);
    else
        set(handles.pas_panel, 'Visible','off');
        set(handles.pas_text, 'Visible','off');
        uicontrol(handles.frameScrubber);
    end


function pas_text_Callback(hObject, eventdata, handles)
% hObject    handle to pas_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pas_text as text
%        str2double(get(hObject,'String')) returns contents of pas_text as a double
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    
    if(isnan(str2double(get(hObject,'String'))))
        showFeedbackPopup(handles,'Please Enter Valid Number',1);
    else
        pas = str2double(get(hObject,'String'));
        globalStudyInfo.pas = pas;
        showFeedbackPopup(handles,sprintf('PAS Saved: %d', pas),2);
    end
    
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);

% --- Executes during object creation, after setting all properties.
function pas_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pas_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'Visible', 'off');


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pas_text.
function pas_text_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pas_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(hObject, 'String', '');
    set(hObject, 'enable', 'on');
    uicontrol(hObject);



% --- Executes on button press in results.
function results_Callback(hObject, eventdata, handles)
% hObject    handle to results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of results
toggle_state = get(hObject,'Value');
if toggle_state == 1
    %make visible
    handles.pas_text_in_panel.String = handles.pas_text.String;
    handles.pas_panel.Visible = 'Off';
    handles.pas_toggle.Value = 0;
    handles.results_panel.Visible = 'On';
elseif toggle_state == 0
    %make invisible
    handles.results_panel.Visible = 'Off';
end


% --------------------------------------------------------------------
function erase_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to erase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');

non_erasable_properties = {'vfVideoStructure','studyImageProcessingInfo','studyCoordinates', ...
                           'ues_point1','ues_point2','uesd_points','nrrs_valres_points',...
                           'nrrs_totalval_points','nrrs_pirires_points','nrrs_totalpiri_points',...
                           'pcr_min_points','pcr_max_points','currentlyTrackedLandmark','vfTracker',...
                           'harrisCorner','kltNumPyramidLevels','kltBlockSize','kltMaxIterations',...
                           'harrisFeatureDetectorParameters', 'kltTrackerParameters'};
                       
all_properties = properties(globalStudyInfo);

erasable_properties = {};
for i = 1:length(all_properties)
    is_non_erasable = any(strcmp(all_properties{i},non_erasable_properties));
    if is_non_erasable
    elseif ~is_non_erasable
        erasable_properties = [erasable_properties;all_properties{i}];
    else
        error('something went wrong! try again')
    end
end

[listbox_selection,~] = listdlg('ListString',erasable_properties,'InitialValue',[],'PromptString','Use CTRL and/or SHIFT to select multiple landmarks');

for i = listbox_selection
    globalStudyInfo.(erasable_properties{i}) = [];
    handles.([erasable_properties{i} '_text']).String = '';
end

%Change the font color of the calibration button if calibration has
%been completed.
if ~isempty(globalStudyInfo.pixelspercm) && globalStudyInfo.pixelspercm > 0 && globalStudyInfo.pixelspercm < 10e6
    handles.unitCalibrationButton.ForegroundColor = [0 1 0];
else
    handles.unitCalibrationButton.ForegroundColor = [1 0 0];

end
   
setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);


% --------------------------------------------------------------------
function Save_as_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Save_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
oldFeedbackLabelMessage = get(handles.feedbackLabel, 'String');
% set(handles.feedbackLabel, 'String', 'Saving...');
showFeedbackPopup(handles, 'Saving...',1);

drawnow()
Utilities.save_as_ResultFileWriter(globalStudyInfo);
showFeedbackPopup(handles, 'Saved', 2);


% --- Executes on button press in goToStartFrame.
function goToStartFrame_Callback(hObject, eventdata, handles)
% hObject    handle to goToStartFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
    if ~isnan(globalStudyInfo.start_frame)
        set(handles.frameScrubber, 'Value', globalStudyInfo.start_frame); 
    else
        set(handles.frameScrubber, 'Value', 1);
    end


% --- Executes on button press in beforePAS.
function beforePAS_Callback(hObject, eventdata, handles)
% hObject    handle to beforePAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of beforePAS

globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');

if (get(hObject,'Value') == get(hObject,'Max'))
    if(isempty(globalStudyInfo.pas_classifiers))
        globalStudyInfo.pas_classifiers = [2, 1, 1];
    elseif length(globalStudyInfo.pas_classifiers)==1
        globalStudyInfo.pas_classifiers(1) = 2;
    elseif length(globalStudyInfo.pas_classifiers)==2
        globalStudyInfo.pas_classifiers(1) = 2;
    elseif length(globalStudyInfo.pas_classifiers)==3
        globalStudyInfo.pas_classifiers(1) = 2;
    end
    
else
    if(isempty(globalStudyInfo.pas_classifiers))
        globalStudyInfo.pas_classifiers = [1,1,1];
    elseif length(globalStudyInfo.pas_classifiers)==1
        globalStudyInfo.pas_classifiers(1) = 1;
    elseif length(globalStudyInfo.pas_classifiers)==2
        globalStudyInfo.pas_classifiers(1) = 1;
    elseif length(globalStudyInfo.pas_classifiers)==3
        globalStudyInfo.pas_classifiers(1) = 1;
    end
    
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);

end



% --- Executes on button press in duringPAS.
function duringPAS_Callback(hObject, eventdata, handles)
% hObject    handle to duringPAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of duringPAS
globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');

if (get(hObject,'Value') == get(hObject,'Max'))
    if(isempty(globalStudyInfo.pas_classifiers))
        globalStudyInfo.pas_classifiers = [1,2,1];
    elseif length(globalStudyInfo.pas_classifiers)==1
        globalStudyInfo.pas_classifiers(2) = 2;
    elseif length(globalStudyInfo.pas_classifiers)==2
        globalStudyInfo.pas_classifiers(2) = 2;
    elseif length(globalStudyInfo.pas_classifiers)==3
        globalStudyInfo.pas_classifiers(2) = 2;
    end
    
else
    if(isempty(globalStudyInfo.pas_classifiers))
        globalStudyInfo.pas_classifiers = [1,1,1];
    elseif length(globalStudyInfo.pas_classifiers)==1
        globalStudyInfo.pas_classifiers(2) = 1;
    elseif length(globalStudyInfo.pas_classifiers)==2
        globalStudyInfo.pas_classifiers(2) = 1;
    elseif length(globalStudyInfo.pas_classifiers)==3
        globalStudyInfo.pas_classifiers(2) = 1;
    end
    
    
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
end

% --- Executes on button press in afterPAS.
function afterPAS_Callback(hObject, eventdata, handles)
% hObject    handle to afterPAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of afterPAS

globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');

if (get(hObject,'Value') == get(hObject,'Max'))
    if(isempty(globalStudyInfo.pas_classifiers))
        globalStudyInfo.pas_classifiers = [1,1,2];
    elseif length(globalStudyInfo.pas_classifiers)==1
        globalStudyInfo.pas_classifiers(3) = 2;
    elseif length(globalStudyInfo.pas_classifiers)==2
        globalStudyInfo.pas_classifiers(3) = 2;
    elseif length(globalStudyInfo.pas_classifiers)==3
        globalStudyInfo.pas_classifiers(3) = 2;
    end
    
else
    if(isempty(globalStudyInfo.pas_classifiers))
        globalStudyInfo.pas_classifiers = [1,1,1];
    elseif length(globalStudyInfo.pas_classifiers)==1
        globalStudyInfo.pas_classifiers(3) = 1;
    elseif length(globalStudyInfo.pas_classifiers)==2
        globalStudyInfo.pas_classifiers(3) = 1;
    elseif length(globalStudyInfo.pas_classifiers)==3
        globalStudyInfo.pas_classifiers(3) = 1;
    end
    
    setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);
end



function sens_num_Callback(hObject, eventdata, handles)
% hObject    handle to sens_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sens_num as text
%        str2double(get(hObject,'String')) returns contents of sens_num as a double


% --- Executes during object creation, after setting all properties.
function sens_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sens_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in graph.
function graph_Callback(hObject, eventdata, handles)
% hObject    handle to graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(findobj('type','figure','name','Pressure Vs. Time'))

globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
%adds one to the string value because the sensor number is one less than
%the column number due to teh first column being the times.
col_num = str2double(handles.sens_num.String)+1;
time = globalStudyInfo.pressure.num(2:end-3,1);
pressure = globalStudyInfo.pressure.num(2:end-3,col_num);

f1 = figure('Name','Pressure Vs. Time','NumberTitle','off');
figure(f1);
plot(time,pressure);
[pks,I] = max(pressure);
peak_text = [num2str(time(I)) ' , ' num2str(pks)];
handles.peak_text.String = peak_text;
globalStudyInfo.pressure.max_index = I;
setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);

%use max instead

% --- Executes on button press in graph_next.
function graph_next_Callback(hObject, eventdata, handles)
% hObject    handle to graph_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(findobj('type','figure','name','Pressure Vs. Time'))

globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
new_sens_num = str2double(handles.sens_num.String)+1;
handles.sens_num.String = num2str(new_sens_num);
col_num = new_sens_num+1;
time = globalStudyInfo.pressure.num(2:end-3,1);
pressure = globalStudyInfo.pressure.num(2:end-3,col_num);

f1 = figure('Name','Pressure Vs. Time','NumberTitle','off');
figure(f1);
plot(time,pressure);
[pks,I] = max(pressure);
peak_text = [num2str(time(I)) ' , ' num2str(pks)];
handles.peak_text.String = peak_text;
globalStudyInfo.pressure.max_index = I;
setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);

% --- Executes on button press in graph_previous.
function graph_previous_Callback(hObject, eventdata, handles)
% hObject    handle to graph_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(findobj('type','figure','name','Pressure Vs. Time'))

globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
new_sens_num = str2double(handles.sens_num.String)-1;
handles.sens_num.String = num2str(new_sens_num);
col_num = new_sens_num+1;
time = globalStudyInfo.pressure.num(2:end-3,1);
pressure = globalStudyInfo.pressure.num(2:end-3,col_num);

f1 = figure('Name','Pressure Vs. Time','NumberTitle','off');
figure(f1);
plot(time,pressure);
[pks,I] = max(pressure);
peak_text = [num2str(time(I)) ' , ' num2str(pks)];
handles.peak_text.String = peak_text;
globalStudyInfo.pressure.max_index = I;
setappdata(handles.appFigure, 'globalStudyInfo', globalStudyInfo);




function ues_num_Callback(hObject, eventdata, handles)
% hObject    handle to ues_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ues_num as text
%        str2double(get(hObject,'String')) returns contents of ues_num as a double


% --- Executes during object creation, after setting all properties.
function ues_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ues_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ues_button.
function ues_button_Callback(hObject, eventdata, handles)
% hObject    handle to ues_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
currentFrameIndex = floor(get(handles.frameScrubber, 'Value'));

numFrames = globalStudyInfo.vfVideoStructure.numFrames;
ues_num = str2double(handles.ues_num.String);
        
    if currentFrameIndex <= numFrames && ~isnan(ues_num)
        data = handles.ues_table.Data;
        table_size = size(data);
        for i = 1:table_size(1)
            if data{i,1} == currentFrameIndex
                data{i,2} = ues_num;
            end
        end
        
        handles.ues_table.Data = data;
        if currentFrameIndex < numFrames
            currentFrameIndex = currentFrameIndex + 1;
            set(handles.frameScrubber, 'Value', currentFrameIndex);
        end
        %drawnow()
    end



% --- Executes on button press in pressure_save.
function pressure_save_Callback(hObject, eventdata, handles)
% hObject    handle to pressure_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
showFeedbackPopup(handles, 'Saving...',1);
drawnow()


%first load some variables we may use
globalStudyInfo = getappdata(handles.appFigure, 'globalStudyInfo');
vfVideoStructure = globalStudyInfo.vfVideoStructure;
frameRate = vfVideoStructure.frameRate;
numFrames = vfVideoStructure.numFrames; 

%find the frame that was chosen for the soft palate. error if unavailable
soft_palate_frame = str2double(handles.soft_palate_text.String);
if isempty(soft_palate_frame)
    error('please select soft palate string')
end


%import the UES table from the GUI
frames = cell2mat(handles.ues_table.Data(2:end,1));
ues_nums = handles.ues_table.Data(2:end,2);

%import numerical data from pressure excel sheet, ignore last three rows
%because of that stuff added to the end. define times to be column vector of
%all the times associated with pressure
num = globalStudyInfo.pressure.num(2:end-3,:);
times = num(:,1);

%find the time at which the soft palate closes
soft_palate_time = num(globalStudyInfo.pressure.max_index);

%calculate the number of sensors
num_sensors = length(num(1,:))-1;

%initialize final_data table, starting with a column of frame numbers. Also
%initialize index
final_data = frames;
index = 0;
for k = 1:length(frames)
    %the expected time for each frame is calculated based on the frame
    %rate.
    expected_time = soft_palate_time + (k-soft_palate_frame)*(1/frameRate);
    
    %initialize current_time to zero. Count down through the times on the
    %pressure file, until the time surpasses the time you expect. Then go
    %back one to get the index where the current_time is the closest to the
    %expected_time, but still greater. (hence index = index-1)
    current_time = 0;
    while expected_time >= current_time && expected_time <= times(end)
        index = index+1;
        current_time = times(index);

    end
    index = index-1;
    
    %take the pressure data from the correct time, and fill them into the
    %final data table for the corresponding frame. 
    if expected_time <= times(end) && index > 0
        final_data(k,2:num_sensors+1) = num(index,2:end);
    elseif index == 0
        final_data(k,2:num_sensors+1) = nan(1,length(num(index+1,2:end)));
    else
        final_data(k,2:num_sensors+1) = nan(1,length(num(index,2:end)));
    end
end


%initialize ues pressures column.
ues_pressures = cell(length(ues_nums),1);
ues_pressures_minus_1 = cell(length(ues_nums),1);
ues_pressures_plus_1 = cell(length(ues_nums),1);
for i = 1:length(ues_pressures)
    %find the sensor number for the correct frame
    ues_sensor_num = ues_nums{i};
    if ~isempty(ues_sensor_num)
        %find the pressure corresponding to that frame. The pressure values
        %for the sensor selected by the user, as well as the sensor above
        %and below are stored
        ues_pressures{i} = final_data(i,ues_sensor_num+1);
        ues_pressures_minus_1{i} = final_data(i,ues_sensor_num);
        ues_pressures_plus_1{i} = final_data(i,ues_sensor_num+2);
    end
end

%add additional columns requested by Nelson
%first: column of pressures of sensor that is deemed UES at rest. 
initial_ues = ues_nums(~cellfun('isempty',ues_nums));
initial_ues = initial_ues{1};
initial_ues_col = num2cell(final_data(:,initial_ues+1));

%second: column of pressures from the sensor 1 before and 1 after the initial ues
initial_ues_col_minus_1 = num2cell(final_data(:,initial_ues));
initial_ues_col_plus_1  = num2cell(final_data(:,initial_ues+2));

[a, b] = enumeration('Data.JoveLandmarks');
numLandmarks = numel(b);
%disp(numLandmarks)
%disp(b)
tableColumnLabels = {};

for i = 1:numLandmarks
   tableColumnLabels{end+1} = strcat(b{i}, '_x');
   tableColumnLabels{end+1} = strcat(b{i}, '_y');
end
    
%combining both coordinates and the sensor information
morphoJCoordinatesArray = zeros(numFrames, numLandmarks*2, 'double');
studyCoordinates = globalStudyInfo.studyCoordinates;
imageHeight = globalStudyInfo.vfVideoStructure.resolution(1);

for frameNumberIterator = 1:numFrames
   for landmarkNumberIterator = 1:numLandmarks
       currentCoordinate = studyCoordinates.getCoordinate(frameNumberIterator, landmarkNumberIterator);
       if (isempty(currentCoordinate))
           currentCoordinate = [ 0 0 ];
       end

       morphoJCoordinatesArray(frameNumberIterator, landmarkNumberIterator*2-1) = currentCoordinate(1);
       morphoJCoordinatesArray(frameNumberIterator, landmarkNumberIterator*2) = imageHeight - currentCoordinate(2) + 1;
   end        
end
morphoJCoordinatesArray= horzcat((1:1:numFrames)', morphoJCoordinatesArray);

t2 = num2cell(morphoJCoordinatesArray);

all_col_headers = [{'Frame Numbers'} tableColumnLabels num2cell(1:num_sensors) {'UES Sens #','UES-1 Pressures','UES Pressrue','UES+1 Pressures','UES_i-1','UES_i','UES_i+1'}];
combined_final_cell = [all_col_headers; ...
    horzcat(t2, [num2cell(final_data(:,2:end)),ues_nums,ues_pressures_minus_1, ues_pressures, ues_pressures_plus_1, initial_ues_col_minus_1,initial_ues_col,initial_ues_col_plus_1])];
final_combined_table = cell2table(combined_final_cell);
[path,name,ext] = fileparts(globalStudyInfo.pressure.fullfile);
full_combined_name = fullfile(path,[name '_calibrated_withCoordinates' '.txt']);

writetable(final_combined_table, full_combined_name, 'Delimiter', '\t', 'WriteVariableNames', false);

%%%%%%%end combining

%create final cell matrix that will include column headers
col_headers = [{'Frame Numbers'} num2cell(1:num_sensors) {'UES Sens #','UES-1 Pressures','UES Pressrue','UES+1 Pressures','UES_i-1','UES_i','UES_i+1'}];
final_cell = [col_headers; [num2cell(final_data),ues_nums,ues_pressures_minus_1, ues_pressures, ues_pressures_plus_1, initial_ues_col_minus_1,initial_ues_col,initial_ues_col_plus_1]];
final_table = cell2table(final_cell);

[path,name,ext] = fileparts(globalStudyInfo.pressure.fullfile);
full_name = fullfile(path,[name '_calibrated' '.txt']);

writetable(final_table, full_name, 'Delimiter', '\t', 'WriteVariableNames', false);
showFeedbackPopup(handles, 'Saved', 2);
drawnow()


% --- Executes on button press in Soft_Palate.
function Soft_Palate_Callback(hObject, eventdata, handles)
% hObject    handle to Soft_Palate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    soft_palate = floor(get(handles.frameScrubber, 'Value'));
    set(handles.soft_palate_text, 'String', soft_palate);
    uicontrol(handles.frameScrubber);
