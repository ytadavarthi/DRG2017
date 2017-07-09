function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 11-Jun-2017 00:53:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

%     data = [firstColumn secondColumn];
%     data{1,100} = [];
%     t = uitable();
%     t.Data = data(2:end,:);
%     t.ColumnName = data(1,:);
%     t.ColumnEditable = true;
    
    
    fileNames = ['Swallow ID'; varargin{1}'];
    
    for i = 2:length(fileNames)
        fileNames{i} = fileNames{i}(1:end-4);
    end
    
    fileNames{1} = ['<html><b>' fileNames{1} '</b></html>'];
  
    handles.uitable1.Data = fileNames; %handles.uitable1.Data = fileNames(2:end,:);
    
    %handles.uitable1.ColumnName = fileNames(1,:);
    handles.uitable1.ColumnEditable = false;
    handles.uitable1.ColumnFormat = {'char'};
    handles.uitable1.RearrangeableColumns = 'on';
    handles.uitable1.FontSize = 11;
 
    % Fit Columns
    columnWidth = fitColumns(handles.uitable1.Data);%fitColumns([handles.uitable1.ColumnName;handles.uitable1.Data]);
    handles.uitable1.ColumnWidth = columnWidth;
    

% Choose default command line output for GUI
handles.output = hObject;
handles.outputData = [];

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes GUI wait for user response (see UIRESUME)
uiwait(handles.GUI);



% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

varargout{2} = handles.outputData;

delete(handles.GUI);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    %create new column
    data = handles.uitable1.Data;
    [m n] = size(data);
    data{m,n+1} = [];
    handles.uitable1.Data = data;
    %create new column's name
    %handles.uitable1.ColumnName = [handles.uitable1.ColumnName;handles.edit1.String{1}];
    %make new column editable
    [m n] = size(data);
    editable = false;
    format = {'char'};
    for i = 2:n
        editable(i) = true;
        format(i) = {'char'};
    end
    handles.uitable1.ColumnEditable = editable;
    handles.uitable1.ColumnFormat = format;
    % Fit Columns
    columnWidth = fitColumns(handles.uitable1.Data);
    handles.uitable1.ColumnWidth = columnWidth;



% % --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

    % Make bold
    if eventdata.Indices(1) == 1 && ~isempty(eventdata.NewData)
        handles.uitable1.Data{eventdata.Indices(1),eventdata.Indices(2)} = ['<html><b>' eventdata.NewData '</b></html>'];
    end
    % Fit Columns
    columnWidth = fitColumns(handles.uitable1.Data);
    handles.uitable1.ColumnWidth = columnWidth;
    



% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    handles.outputData = handles.uitable1.Data;
    
    guidata(hObject, handles);
    
    uiresume(handles.GUI);
    

% --- Executes on key press with focus on uitable1 and none of its controls.
function uitable1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

%if ctrl+v is pressed, paste clipboard into table at selected location
if strcmp(eventdata.Key,'v') && ~isempty(eventdata.Modifier) && (strcmp(eventdata.Modifier,'control') || strcmp(eventdata.Modifier,'command'))
    
    %use custom paste function to create clip_board
    clip_board = paste;
    [m,n] = size(clip_board);
    
    %find indices of where the table is clicked using uitable1_CellSelectionCallback
    firstRow = handles.indices(1);
    firstCol = handles.indices(2);
    
    %determine how large the data matrix will be
    finalRow = firstRow + m-1;
    finalCol = firstCol + n-1;
    
    %This if statement replaces the table's data with the information from
    %the clip_board.
    if isnumeric(clip_board)
        clip_board = num2cell(clip_board);
        handles.uitable1.Data(firstRow:finalRow,firstCol:finalCol) = clip_board;
    elseif ischar(clip_board)
        clip_board = {clip_board};
        [m,n] = size(clip_board);
        finalRow = firstRow + m-1;
        finalCol = firstCol + n-1;
        handles.uitable1.Data(firstRow:finalRow,firstCol:finalCol) = clip_board;
    elseif iscell(clip_board)
        handles.uitable1.Data(firstRow:finalRow,firstCol:finalCol) = clip_board;
        
    end
    
    %make new pasted columns editable, format = char, and bold the first
    %line. then fit column size.
    [m, n] = size(handles.uitable1.Data);
   
    editable = false;
    format = {'char'};
    for i = 2:n
        if length(handles.uitable1.Data{1,i}) > 8 && strcmp(handles.uitable1.Data{1,i}(1:9),'<html><b>')
            editable(i) = true;
            format(i) = {'char'};
        elseif isempty(handles.uitable1.Data{1,i})
            editable(i) = true;
            format(i) = {'char'};
        else
            handles.uitable1.Data{1,i} = ['<html><b>' handles.uitable1.Data{1,i} '</b></html>'];
            editable(i) = true;
            format(i) = {'char'};
        end
    end
    handles.uitable1.ColumnEditable = editable;
    handles.uitable1.ColumnFormat = format;
    
    columnWidth = fitColumns(handles.uitable1.Data);
    handles.uitable1.ColumnWidth = columnWidth;
end


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
handles.indices = eventdata.Indices;
guidata(hObject, handles);




% --- Executes on button press in removeColumn.
function removeColumn_Callback(hObject, eventdata, handles)
% hObject    handle to removeColumn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 %create new column
    data = handles.uitable1.Data;
    [m n] = size(data);
    if n > 1
        data = data(:,1:end-1);
        handles.uitable1.Data = data;
        %create new column's name
        %handles.uitable1.ColumnName = [handles.uitable1.ColumnName;handles.edit1.String{1}];
        %make new column editable
        handles.uitable1.ColumnEditable = handles.uitable1.ColumnEditable(1:end-1);
        handles.uitable1.ColumnFormat = handles.uitable1.ColumnFormat(1:end-1);
        % Fit Columns
        columnWidth = fitColumns(handles.uitable1.Data);
        handles.uitable1.ColumnWidth = columnWidth;
    end




function x = paste(dec,sep,lf)
    % PASTE copies the content of the clipboard to a variable; creates a
% string, a cell array, or a numerical array, depending on content.
%
% Usage:
%   x = paste;
%   x = paste(dec,sep,lf);
%
% The program will try to create an array. For this to succeed, the
% material that is passed from the clipboard must be a tab delimited array,
% such as produced by Excel's copy command. If the content does not have
% this structure, the program simply returns a string. If the content is an
% array, x will be a numerical array if all its components qualify as
% numerical. If not, it will be a cell array.
%
% Optional arguments:
%   dec   Single character that indicates the decimal separator. Default is
%         the period ('.').
%   sep   Single character that indicates how horizontal neigbors of a
%         matrix or cell array are separated. Default is the tabulator code
%         (char 9).
%   lf    Single character that indicates how rows are separated.(lf stands
%         for line feed). Default is the line feed code (char 10).
%
% Examples:
%
% 1) If the clipboard contains 'George's job is to chop wood.', then
%    x = paste produces x = 'George's job is to chop wood.'
%
% 2) If the content of the clipboard is a simple text with multiple lines
%    (copied from Notepad or Word or similar), then x = paste produces a
%    cell array with one column and one row per line of the input so each
%    line of text will be separated in different cells. For example, if you
%    copy the follwing text from some other program,
%
%       Manche meinen lechts und rinks kann man nicht velwechsern.
%       Werch ein Illtum!
%
%    then, in Matlab, x = paste produces a 2x1 cell array with
%
%       x{1} = 'Manche meinen lechts und rinks kann man nicht velwechsern.'
%       x{2} = 'Werch ein Illtum!'
%
%    [Note: x = clipboard('copy') would produce just a string in this case,
%    not an array of stringcells, so choose the code that is most useful for
%    your purpose.]
%
% 3) However, if your text contains an equal number of tabs on each line,
%    for instance because you've copied something like this from Word,
%      1  ->  item 1
%      2  ->  item 2
%      3  ->  item 3
%    where -> denotes TABs, then x = paste produces a 3x2 cell array,
%      x = 
%         [1]    'item 1'
%         [2]    'item 2'
%         [3]    'item 3'
%
% 4) If the clipboard contains an array of cells, e.g.
%         1  2  3
%         4  5  6
%    for instance by copying these six cells from an Excel spreadsheet,
%    then x = paste makes a 2x3 array of doubles with the same content.
%    The same is true if there are NaN cells. So if the Excel excerpt was
%         1     2     3
%         4   #N/A    6
%    then x =
%         1     2     3
%         4   NaN     6
%
% 5) If the cell collection in the clipboard is
%         A  1.3  NaN
%    then x will not be a numerical array, but a 1x3 cell array, with
%     x = 
%        'A'    [1.3000]    [NaN]
%    so x{1} is a string, but x{2} and x{3} are doubles.
%
% 6) If the clipboard contains '1,2', then x=paste with no arguments will
%    be 12 (because Matlabs str2double('1,2') interprets this as the number
%    12). However, x=paste(',') will return 1.2
%
% 7) If the clipboard contains '1,2 & 100', then x=paste with no arguments
%    will return just the string '1,2 & 100'. x=paste(',','&'), on the
%    other hand, will return a numerical array [1.2, 100].
%
% Here is a practical example:
% ----------------------------
%   In Excel, select your data, say, a sample of observations organized in
%   a few columns. Place them into the clipboard with Ctrl-C.
%   Now switch to Matlab and say
%       x = paste;
%   This puts the data that you copied in Excel into a variable x in
%   Matlab's workspace.
%   Next, you can analyze the data. For instance, compute the principal
%   components (an analysis that is not readily available in Excel), and
%   push the result back into the clipboard,
%       [c,s] = princomp(x);
%       copy(s)
%   Now, back in Excel, you can paste the result into your spreadsheet with
%   Ctrl-V.
%   
% This program was selected 'Pick of the Week' on March 7, 2014. :-)
%
% Author : Yvan Lengwiler
% Release: 1.51
% Date   : 2014-03-19
%
% See also COPY, CLIPBOARD

% History:
% 2010-06-25	correction of a bug that occurred with multiple string
%               cells on a single line.
% 2011-06-05	Simplified detection of line feeds.
% 2011-06-22	Removal of an unused variable.
% 2012-02-03	Tries to identify non-conventional decimal and thousand
%               separators.
% 2013-03-19	Three optional arguments (dec, sep, and lf).
% 2014-02-21    Corrected a bug found by Jiro Doke. (Thanks, Jiro)
% 2014-03-19    Bug fix, thanks to Soren Preus.
    % handle optional parameters
    if nargin < 3
        if ispc
            lf = char(10);  % default is line feed (char 10)
        elseif ismac
            lf = char(13);  % default is line feed for mac (char 13)
        end
    end
    if nargin < 2
        sep = char(9);  % default is tabulator (char 9)
    end
    if nargin < 1
        dec = '.';      % default is a period '.'
    end
    
    % get the material from the clipboard
    p = clipboard('paste');
    
    % get out of here if nothing usable is in the clipboard
    % (Note: MLs 'clipboard' interface supports only text, not images or
    % the like.)
    if isempty(p)
        x = [];
        return;
    end
    
    % find linebreaks
    if p(end) ~= lf
        p = [p,lf];               % append linefeed if missing
    end
    posLF = find(ismember(p,lf)); % find linefeeds
    nLF   = numel(posLF);         % count linefeeds
    
    % break into separate lines; parse each line by tab
    lines  = cell(nLF,1);
    posTab = cell(nLF,1);
    numTab = zeros(nLF,1);
    last = 0;
    for i = 1:nLF
        lines{i}  = [p(last+1:posLF(i)-1),sep]; % append a tabulator
        last      = posLF(i);
        tabs      = ismember(lines{i},sep);     % find tabulators
        aux       = linspace(1,numel(lines{i}),numel(lines{i}));
        posTab{i} = aux(tabs);                  % positions of tabs
        numTab(i) = sum(tabs(:));               % count tabs in line
    end

    % is it an array (i.e. a rectangle of cells)?
    isArray = true;
    i = 1;
    while isArray && i <= nLF
        isArray = (numTab(i) == numTab(1));
        i = i+1;
    end
    
    if ~isArray
        % it's not an array, so just return the raw content of the clipboard
        x = p;
        % Note: A simple single or multi-line text with no tabs *does*
        % qualify as an array, so the program splits such content line-wise
        % into a one-column cell array.
    else
        % it is an array, so put it into a Matlab cell array
        isNum = true;   % will remain true if it is never switched off below
        x = cell(nLF,numTab(1));
        for i = 1:nLF
            last = 0;
            pos = posTab{i};
            for j = 1:numTab(1);
                x{i,j} = lines{i,1}(last+1:pos(j)-1);
                % try to make numerical cells if possible
                if ismember(x{i,j},{'NaN','#N/A'})
                    x{i,j} = NaN;
                else
                    aux = x{i,j};   % copy to work on
                    % deal with decimal and thousand separators
                    if dec ~= '.'
                        aux = strrep(aux,dec,'.');  % replace decimal
                                                    % separators with periods
                    else
                        if numel(strfind(aux,'''')) > 0
                            % remove apostrophes
                            aux = strrep(aux,'''','');
                            % if it is a number, it is formatted conventionally
                        else
                            % determine if decimal separator is comma and
                            % thousand separator is period
                            posComma  = strfind(aux,',');
                            posPeriod = strfind(aux,'.');
                            if numel(posComma) == 1 && numel(posPeriod) > 0
                                if all(mod(posComma-posPeriod,4) == 0) && ...
                                        posComma > posPeriod(end)
                                    % this is potentially a non-conventionally
                                    % formatted number: remove periods first,
                                    % then replace comma with period
                                    aux = strrep(aux,'.','');
                                    aux = strrep(aux,',','.');
                                end
                            end
                        end
                    end
                    % determine if the cell is numerical
                    aux = str2double(aux);  % try to make a double
                    if isnan(aux)
                        % this cell is not numerical (turn off switch for
                        % later)
                        isNum = false;
                    else
                        % str2double has produced a ligit number
                        x{i,j} = aux;
                    end
                end
                last = pos(j);
            end
        end
        if isNum	% make a numerical array if possible
            x = cell2mat(x);
        end
    end
    
    % remove cell encapsulation if there is only one cell
    if numel(x) == 1
        try
            x = x{1};
        end
    end
    
function columnWidth = fitColumns(data)
    dataSize = size(data);
    maxLen = zeros(1,dataSize(2));
    for i = 1:dataSize(2)
        for j = 1:dataSize(1)
            len = length(data{j,i});
            if j == 1
                len = length(data{j,i}) - length('<html><b></b></html>');
            end
            
            if(len>maxLen(1,i))
                maxLen(1,i) = len;
            end
           
        end
        if maxLen(1,i) < 5
            maxLen(1,i) = 7;
        end
    end
    
    columnWidth = num2cell(maxLen*8.5);
