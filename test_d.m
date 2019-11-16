function [files_button_clicked, folder_button_clicked, normalize] = Choice()
    files_button_clicked = false;
    folder_button_clicked = false;
    normalize = false;

%choice = menu('Select an option','Compile selected files','Compile all _morphoj files in a selected folder', 'Compile all files with Normalization');
    d = dialog('Name','Make a selection', 'Units', 'normalized', 'Position', [0.2 0.7 0.18 0.2]);
    
    selectionText = uicontrol('Parent', d, 'Style', 'text', 'Units', 'normalized', 'Position', [0.05 0.8 0.9 0.15], 'String', 'Make a Selection', 'FontSize', 11);
    filesButton = uicontrol('Parent', d, 'Style', 'pushbutton', 'Units', 'normalized', 'Position', [0.05 0.65 0.9 0.15], 'String', 'Compile selected files', 'Callback', @files_button_click); 
    folderButton = uicontrol('Parent', d, 'Style', 'pushbutton', 'Units', 'normalized','Position', [0.05 0.45 0.9 0.15], 'String', 'Compile all files in a selected folder', 'Callback', @folder_button_click);
    checkbox = uicontrol('Parent', d, 'Style', 'checkbox', 'Units', 'normalized', 'Position', [0.4 0.2 0.9 0.15], 'String', ' Normalize', 'Callback', @normalize_checked);

    waitfor(d);
    function files_button_click(src,event)
        if normalize
            display('Compiling selected files and normalizing');
        else
            display('Compiling selected files');
        end
        
        files_button_clicked = true;
        close(d)
    end

    function folder_button_click(src,event)
        if normalize
            display('Compiling entire folder and normalizing');
        else
            display('Compiling entire folder');
        end
        
        folder_button_clicked = true;
        close(d)
    end

    function normalize_checked(hObject,event)
        if (get(hObject,'Value') == get(hObject,'Max'))
            display('Selected');
            normalize = true;
        else
            display('Not selected');
            normalize = false;
        end
    end
end 