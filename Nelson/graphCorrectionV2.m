function graphCorrectionV2
    
    %open dialogue box and ask for file name.
    [file_name, folder_name] = uigetfile({'*.*'},'File Selector');
    
    %import the .svg file as a cell matrix of strings.
    raw = importdata([folder_name,file_name]);
    
    %use the function below to analyze the raw .svg file. This extracts the
    %line numbers that include the line, circle, and text commands, as well
    %as the coordinates for the lines, the line where the 'defs' command
    %occures, and the total width and height of the vector file
    [cell_coordinates,line_numbers,circle_numbers,text_numbers,defs_line,width,height] = analyzeRaw(raw);
    
    %the cell_coordinates variable is a cell matrix of strings that include
    %the coordinates. this function transforms it into a normal matrix of
    %type double where the 4 columns are X1 X2 Y1 Y2 and the rows are each
    %point in ascending order.
    coordinates = makeDoubleCoordinates(cell_coordinates);
    
    %This function will generate new coordinate points for the tips of the
    %vectors. This is done by using a procrustean fit to fit the tips of
    %vectors 3-5 to the base of those vectors, and then using that
    %transformation on adjust the location of the tips of each other
    %vector.
    [newTips] = adjustTips(coordinates);
    
    %insert marker code into .svg file that allows for creation of the
    %arrowhead. The arrowhead is a triangle with the following properties.
    %These can be changed to manipulate the size of the triangle arrowhead.
    triangle_width = 2.5;
    triangle_height = 2.5;
    
    %this long function breaks up the raw .svg data into smaller pieces and
    %does any necessary manipulation. At this point all that's left to do
    %is put the code back together piece by piece for each .svg file.
    [before_defs_line,arrowhead_lines,post_arrowhead_lines,circle_lines, ...
     text_lines,final_lines,new_vectors_blue,new_vectors_red,orig_vectors_blue, ... 
     orig_anchor,tips_anchor, new_anchor] = splitRaw(raw,triangle_width,triangle_height,coordinates,newTips,line_numbers,circle_numbers,text_numbers,defs_line);
    
    %here we arrange the newVectors and bothVectors .svg to include what we
    %want.
    newVectors = [before_defs_line;arrowhead_lines;post_arrowhead_lines;new_vectors_blue;orig_anchor;new_anchor;circle_lines;text_lines;final_lines];
    
    bothVectors = [before_defs_line;arrowhead_lines;post_arrowhead_lines;new_vectors_blue;new_vectors_red;orig_vectors_blue;orig_anchor;tips_anchor;circle_lines;text_lines;final_lines];
    
    newVectors_no_numbers = [before_defs_line;arrowhead_lines;post_arrowhead_lines;new_vectors_blue;orig_anchor;new_anchor;circle_lines;'      />';final_lines];
    
    %this writes a text file called newVectors.txt which includes the new
    %vector coordinates.
    newVectors_ID = fopen([folder_name file_name(1:end-4) '_newVectors.svg'],'w');
    for i = 1:length(newVectors)
        fprintf(newVectors_ID,'%s\r\n',newVectors{i,:});
    end
    fclose(newVectors_ID);
    
    %this writes a text file called newVectors.txt which includes the new
    %vector coordinates.
    newVectors_no_numbers_ID = fopen([folder_name file_name(1:end-4) '_newVectors_no_numbers.svg'],'w');
    for i = 1:length(newVectors_no_numbers)
        fprintf(newVectors_no_numbers_ID,'%s\r\n',newVectors_no_numbers{i,:});
    end
    fclose(newVectors_no_numbers_ID);
    
    %this writes a text file called bothVectors.txt which includes both
    %vector coordinates.
    bothVectors_ID = fopen([folder_name file_name(1:end-4) '_bothVectors.svg'],'w');
    for i = 1:length(bothVectors)
        fprintf(bothVectors_ID,'%s\r\n',bothVectors{i,:});
    end
    fclose(bothVectors_ID);
    
end

function [cell_coordinates,line_numbers,circle_numbers,text_numbers,defs_line,width,height] = analyzeRaw(raw)

    %for each line of text...
    cell_coordinates = {};
    line_numbers = [];
    circle_numbers = [];
    text_numbers = [];
    for i = 1:length(raw)
        
        %this line finds where <defs id=" is found in the text. This is
        %later used to insert some lines that format the arrow head
        if ~isempty(regexp(raw{i},'<defs id="'))
            defs_line = i;
        end
        

        %check to see if the figure width is recorded on this line. if so,
        %record it in the variable width
        [width_start,width_end] = regexp(raw{i},' width="[0-9.]+"');
        
        if ~isempty(width_start) && ~isempty(width_end)
            width = str2double(raw{i}(width_start+length(' width="'):width_end-1));
        end
        
        %check to see if the figure height is recorded on this line if so,
        %record it in the variable height
        [height_start,height_end] = regexp(raw{i},' height="[0-9.]+"');
        
        if ~isempty(height_start) && ~isempty(height_end)
            height = str2double(raw{i}(height_start+length(' height="'):height_end-1));
        end
        
        %if the first bit of the line of text is equal to '      /><line',
        %which is what is expected to be the first number of characters of
        %the text in the .svg that include the appropriate coordinates.
        %similarly, find all lines that start with '      /><circle' and '
        %><text'
        line_identifier   = '      /><line';
        text_identifier   = '      ><text';
        text_identifier2  = '      /><text';
        circle_identifier = '      /><circle';
        if length(raw{i})>length(line_identifier) && strcmp(raw{i}(1:length(line_identifier)),line_identifier)
            
            %This line searches through line i and finds anywhere that
            %there is quotation marks with a number value inbetween. It
            %then spits out all of those numbers as a cell matrix of
            %characters
            cell_coordinates = [cell_coordinates;regexp(raw{i},'"[0-9.]+"', 'match')];
            
            %record which line numbers had the coordinate information
            line_numbers = [line_numbers,i];
            
        elseif length(raw{i})>length(text_identifier) && (strcmp(raw{i}(1:length(text_identifier)),text_identifier) || strcmp(raw{i}(1:length(text_identifier2)),text_identifier2))
            text_numbers = [text_numbers,i,i+1];
            
        elseif length(raw{i})>length(circle_identifier) && strcmp(raw{i}(1:length(circle_identifier)),circle_identifier)
            circle_numbers = [circle_numbers,i];
        end
    end

end

function coordinates = makeDoubleCoordinates(cell_coordinates)
%remove the quotation marks from the numbers, and convert them into
    %type double and store in regular matrix.
    cell_coordinates_size = size(cell_coordinates);
    coordinates = zeros(cell_coordinates_size(1),cell_coordinates_size(2));
    for i = 1:cell_coordinates_size(1)
        for j = 1:cell_coordinates_size(2)
            coordinates(i,j) = str2double(cell_coordinates{i,j}(2:end-1));
        end
    end
    
    %this plot can be helpful in debugging
    % plot(coordinates(:,1),coordinates(:,3),'rx',coordinates(:,2),coordinates(:,4),'bx');
    
end

function [newTips] = adjustTips(coordinates)
%define variables that store the coordinates of the tips and the dots
    %for coordinates 1 through 5
    dots_to_fit = coordinates(3:5,[1,3]);
    tips_to_fit = coordinates(3:5,[2,4]);
    
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
    [~,~,tr] = procrustes(dots_to_fit,tips_to_fit);
   
    %this plot can help with debugging
%     hold on
%     plot(fittedTips(:,1),fittedTips(:,2),'ko')

    %define original coordinate points for all the tips, and then use the
    %transformation to make new tips
    tips = coordinates(:,[2,4]);
    newTipsMinusC = tr.b*tips*tr.T;
    for i = 1:length(newTipsMinusC(:,1))
        newTips(i,:) = newTipsMinusC(i,:) + tr.c(1,:);
    end
    
    %this plot can help with debugging
%     figure
%     plot(coordinates(:,1),coordinates(:,3),'rx',coordinates(:,2),coordinates(:,4),'bx',newTips(:,1),newTips(:,2),'gs');
end

function [before_defs_line,arrowhead_lines,post_arrowhead_lines,circle_lines,text_lines,final_lines,new_vectors_blue,new_vectors_red,orig_vectors_blue,orig_anchor,tips_anchor,new_anchor] = splitRaw(raw,triangle_width,triangle_height,coordinates,newTips,line_numbers,circle_numbers,text_numbers,defs_line)
    
    %.svg lines above where the defs statement is written. This is never
    %changed.
    before_defs_line = raw(1:defs_line-1);
    
    %this function creates the .svg code needed to make the arrowhead
    %marker. 
    arrowhead_lines = create_arrowhead_lines(raw,defs_line,triangle_height,triangle_width);
    
    %the two lines after the arrowhead_lines are also un-changed from the
    %original
    post_arrowhead_lines = raw(defs_line+2:defs_line+3);
    
    %store the lines that include code for lines, circles, and text in
    %separate variables
    line_lines = raw(line_numbers);
    circle_lines = raw(circle_numbers);
    text_lines = raw(text_numbers);
    
    %the final lines are also unchanged.
    final_lines = raw(text_numbers(end)+1:end);
    
    %Creates lines of .svg code that create the new vector coordinates
    %after the transformation. There are two sets of thses, one is blue,
    %the other is red. 
    [new_vectors_blue,new_vectors_red,orig_vectors_blue] = create_new_vectors(line_lines,newTips);
    
    %this line uses the function defined below to generate .svg code lines
    %that will create the anchor lines connecting the mandible, hard palat,
    %and spine. 
    [orig_anchor,tips_anchor,new_anchor] = draw_anchor_lines(coordinates,newTips);
    
end

function arrowhead_lines = create_arrowhead_lines(raw,defs_line,triangle_height,triangle_width)
    %add the code to the SVG to create a blue triangle and a red triangle
    %which will be used as arrowheads
    arrowhead_lines = {[raw{defs_line} '>']};
    arrowhead_lines = [arrowhead_lines; '  <marker id="arrowhead_blue" stroke-width=".01" stroke="blue" markerWidth="' num2str(triangle_width) '" markerHeight="' num2str(triangle_height) '" refX="0" refY="' num2str(triangle_width/2) '" orient="auto">'];
    arrowhead_lines = [arrowhead_lines; '    <polygon points="0 0, ' num2str(triangle_height) ' ' num2str(triangle_width/2) ', 0 ' num2str(triangle_width) '" fill="blue" stroke="blue" stroke-width=".01" />'];
    arrowhead_lines = [arrowhead_lines; '  </marker>'];
    arrowhead_lines = [arrowhead_lines; '  <marker id="arrowhead_red" stroke-width=".01" stroke="red" markerWidth="' num2str(triangle_width) '" markerHeight="' num2str(triangle_height) '" refX="0" refY="' num2str(triangle_width/2) '" orient="auto">'];
    arrowhead_lines = [arrowhead_lines; '    <polygon points="0 0, ' num2str(triangle_height) ' ' num2str(triangle_width/2) ', 0 ' num2str(triangle_width) '" fill="red" stroke="red" stroke-width=".01" />'];
    arrowhead_lines = [arrowhead_lines; '  </marker>'];
    arrowhead_lines = [arrowhead_lines; '  </defs><g'];
end
    
function [new_vectors_blue,new_vectors_red,orig_vectors_blue] = create_new_vectors(line_lines,newTips)
    
    %Creates lines of .svg code that create the new vector coordinates
    %after the transformation. There are two sets of thses, one is blue,
    %the other is red. 
    new_vectors_blue = line_lines;
    new_vectors_red = line_lines;
    orig_vectors_blue = line_lines;
    for i = 1:length(new_vectors_blue)
        new_vectors_blue{i} = regexprep(new_vectors_blue{i},'x2="[0-9.]+"',['x2="' num2str(newTips(i,1)) '"']);
        new_vectors_blue{i} = regexprep(new_vectors_blue{i},'y2="[0-9.]+"',['y2="' num2str(newTips(i,2)) '"']);
        new_vectors_red{i} = regexprep(new_vectors_red{i},'x2="[0-9.]+"',['x2="' num2str(newTips(i,1)) '"']);
        new_vectors_red{i} = regexprep(new_vectors_red{i},'y2="[0-9.]+"',['y2="' num2str(newTips(i,2)) '"']);
        new_vectors_blue{i} = regexprep(new_vectors_blue{i},'stroke:\w+','stroke:blue');
        new_vectors_red{i} = regexprep(new_vectors_red{i},'stroke:\w+','stroke:red');
        if i>5
            new_vectors_blue{i} = regexprep(new_vectors_blue{i},';" y2="','; marker-end:url(#arrowhead_blue)" y2="');
            new_vectors_red{i} = regexprep(new_vectors_red{i},';" y2="','; marker-end:url(#arrowhead_red)" y2="');
            orig_vectors_blue{i} = regexprep(orig_vectors_blue{i},';" y2="','; marker-end:url(#arrowhead_blue)" y2="');
        end
    end
end

function [orig_anchor,tips_anchor,new_anchor] = draw_anchor_lines(coordinates,newTips)
    %create anchor lines for original & new points. These connect mand,
    %hard, c1, c2, and c3
    anchor_line_template = '      /><line x1="%d" x2="%d" y1="%d" style="fill:none; stroke:blue; stroke-width:3;" y2="%d"';
    mand_to_c1_orig = {sprintf(anchor_line_template, coordinates(1,1), coordinates(3,1), coordinates(1,3),coordinates(3,3))};
    hard_to_c1_orig = {sprintf(anchor_line_template, coordinates(2,1), coordinates(3,1), coordinates(2,3),coordinates(3,3))};
    c1_to_c2_orig   = {sprintf(anchor_line_template, coordinates(3,1), coordinates(4,1), coordinates(3,3),coordinates(4,3))};
    c2_to_c3_orig   = {sprintf(anchor_line_template, coordinates(4,1), coordinates(5,1), coordinates(4,3),coordinates(5,3))};
    orig_anchor     = [mand_to_c1_orig;hard_to_c1_orig;c1_to_c2_orig;c2_to_c3_orig];
    
    anchor_line_template_tips = '      /><line x1="%d" x2="%d" y1="%d" style="fill:none; stroke-dasharray:15, 10, 5, 10; stroke:red; stroke-width:3;" y2="%d"';
    mand_to_c1_tips = {sprintf(anchor_line_template_tips, coordinates(1,2), coordinates(3,2), coordinates(1,4),coordinates(3,4))};
    hard_to_c1_tips = {sprintf(anchor_line_template_tips, coordinates(2,2), coordinates(3,2), coordinates(2,4),coordinates(3,4))};
    c1_to_c2_tips   = {sprintf(anchor_line_template_tips, coordinates(3,2), coordinates(4,2), coordinates(3,4),coordinates(4,4))};
    c2_to_c3_tips   = {sprintf(anchor_line_template_tips, coordinates(4,2), coordinates(5,2), coordinates(4,4),coordinates(5,4))};
    tips_anchor     = [mand_to_c1_tips;hard_to_c1_tips;c1_to_c2_tips;c2_to_c3_tips];
    
    anchor_line_template_new = '      /><line x1="%d" x2="%d" y1="%d" style="fill:none; stroke-dasharray:15, 10, 5, 10; stroke:red; stroke-width:3;" y2="%d"';
    mand_to_c1_new  = {sprintf(anchor_line_template_new, newTips(1,1), newTips(3,1), newTips(1,2), newTips(3,2))};
    hard_to_c1_new  = {sprintf(anchor_line_template_new, newTips(2,1), newTips(3,1), newTips(2,2), newTips(3,2))};
    c1_to_c2_new    = {sprintf(anchor_line_template_new, newTips(3,1), newTips(4,1), newTips(3,2), newTips(4,2))};
    c2_to_c3_new    = {sprintf(anchor_line_template_new, newTips(4,1), newTips(5,1), newTips(4,2), newTips(5,2))};
    new_anchor      = [mand_to_c1_new;hard_to_c1_new;c1_to_c2_new;c2_to_c3_new];
   
end


