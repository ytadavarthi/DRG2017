function graphCorrection
    
    %open dialogue box and ask for file name.
    [file_name, folder_name] = uigetfile({'*.*'},'File Selector');
    
    %import the .svg file as a cell matrix of strings.
    raw = importdata([folder_name,file_name]);
    
    %for each line of text...
    cell_coordinates = {};
    line_numbers = [];
    for i = 1:length(raw)
        
        %check to see if the figure width is recorded on this line. if so,
        %record it in the variable width
        [width_start,width_end] = regexp(raw{i},'width="[0-9.]+"');
        
        if ~isempty(width_start) && ~isempty(width_end)
            width = str2double(raw{i}(width_start+length('width="'):width_end-1));
        end
        
        %check to see if the figure height is recorded on this line if so,
        %record it in the variable height
        [height_start,height_end] = regexp(raw{i},'height="[0-9.]+"');
        
        if ~isempty(height_start) && ~isempty(height_end)
            height = str2double(raw{i}(height_start+length('height="'):height_end-1));
        end
        
        %if the first bit of the line of text is equal to '      /><line',
        %which is what is expected to be the first number of characters of
        %the text in the .svg that include the appropriate coordinates.
        line_identifier = '      /><line';
        if length(raw{i})>length(line_identifier) && strcmp(raw{i}(1:length(line_identifier)),line_identifier)
            
            %This line searches through line i and finds anywhere that
            %there is quotation marks with a number value inbetween. It
            %then spits out all of those numbers as a cell matrix of
            %characters
            cell_coordinates = [cell_coordinates;regexp(raw{i},'"[0-9.]+"', 'match')];
            
            %record which line numbers had the coordinate information
            line_numbers = [line_numbers,i];
        end
    end
    
    %remove the quotation marks from the numbers, and convert them into
    %type double and store in regular matrix.
    cell_coordinates_size = size(cell_coordinates);
    coordinates = zeros(cell_coordinates_size(1),cell_coordinates_size(2));
    for i = 1:cell_coordinates_size(1)
        for j = 1:cell_coordinates_size(2)
            coordinates(i,j) = str2double(cell_coordinates{i,j}(2:end-1));
        end
    end
    
    %in morphoJ, the y values are inversed for some reason, i.e. the top of
    %the graph is y = 0, so this should correct the y values to make them
    %easier to work with and plot as I write the rest of the code. This
    %will probably be un-done later.
    %coordinates(:,[3,4]) = height - coordinates(:,[3,4]);
    plot(coordinates(:,1),coordinates(:,3),'rx',coordinates(:,2),coordinates(:,4),'bx');
    
    %define variables that store the coordinates of the tips and the dots
    %for coordinates 1 through 5
    dots_to_fit = coordinates([1:5],[1,3]);
    tips_to_fit = coordinates([1:5],[2,4]);
    
    %use a procrustes fit to fit the tips to the dots.
    %The tr variable is a structure array with fields:
    % c — Translation component
    % T — Orthogonal rotation and reflection component
    % b — Scale component
    % That is:
    % c = transform.c;
    % T = transform.T;
    % b = transform.b;
    % 
    % Z = b*Y*T + c;
    %
    %This formula will be used to transform all the tips and find the new
    %value for the tips.
    [d,fittedTips,tr] = procrustes(dots_to_fit,tips_to_fit);
    hold on
    plot(fittedTips(:,1),fittedTips(:,2),'ko')

    %define original coordinate points for all the tips, and then use the
    %transformation to make new tips
    tips = coordinates(:,[2,4]);
    newTipsMinusC = tr.b*tips*tr.T;
    for i = 1:length(newTipsMinusC(:,1))
        newTips(i,:) = newTipsMinusC(i,:) + tr.c(1,:);
    end
    
    figure
    plot(coordinates(:,1),coordinates(:,3),'rx',coordinates(:,2),coordinates(:,4),'bx',newTips(:,1),newTips(:,2),'gs');
    
    %writing new vector files
    newVectors = raw;
   %creates a new cell matrix called newVectors which replaces all of the
   %lines in raw that include dimensions with the updated dimensions for
   %the tips.
    for i = 1:length(line_numbers)
        newVectors{line_numbers(i)} = regexprep(newVectors{line_numbers(i)},'x2="[0-9.]+"',['x2="' num2str(newTips(i,1)) '"']);
        newVectors{line_numbers(i)} = regexprep(newVectors{line_numbers(i)},'y2="[0-9.]+"',['y2="' num2str(newTips(i,2)) '"']);
    end
    
    %creates a new cell matrix called bothVectors which has both the
    %original vectors and the new vectors.
    bothVectors = newVectors;
    for i = 1:length(line_numbers)
        bothVectors{line_numbers(i)} = regexprep(bothVectors{line_numbers(i)},'stroke:\w+','stroke:red');
    end
    bothVectors = [bothVectors(1:line_numbers(end));raw(line_numbers);bothVectors(line_numbers(end)+1:end)];
    
    %this writes a text file called newVectors.txt which includes the new
    %vector coordinates.
    newVectors_ID = fopen([folder_name file_name(1:end-4) '_newVectors.svg'],'w');
    for i = 1:length(newVectors)
        fprintf(newVectors_ID,'%s\r\n',newVectors{i,:});
    end
    fclose(newVectors_ID);
    
    %this writes a text file called bothVectors.txt which includes both
    %vector coordinates.
    bothVectors_ID = fopen([folder_name file_name(1:end-4) '_bothVectors.svg'],'w');
    for i = 1:length(bothVectors)
        fprintf(bothVectors_ID,'%s\r\n',bothVectors{i,:});
    end
    fclose(bothVectors_ID);
    
end