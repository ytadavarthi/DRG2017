function quicklabel(data, inputfilename)
    landmarkLabels = {'L1', 'L2', 'L3', 'L4', 'L5', 'L6', 'L7', 'L8', 'L9'};
    landmarkLabelLocations = {'RightTop', 'RightTop', 'LeftBottom', 'RightTop', 'LeftTop', 'RightTop', 'LeftTop', 'RightBottom', 'LeftTop'};
    img = imread(inputfilename);
    
    numLandmarks = numel(landmarkLabels);

    %Coordinates needed to draw the skeletal axes lines.
    L1_coordinate = [data(1) data(2)];
    L2_coordinate = [data(3) data(4)];
    L3_coordinate = [data(5) data(6)];
    L5_coordinate = [data(9) data(10)];
    
    %Draw lines
    %Specify lineWidth
    lineWidth = 5
    %Draw mylohyoid line
    img = insertShape(img, 'line', [L1_coordinate(1) L1_coordinate(2) L3_coordinate(1) L3_coordinate(2)], 'color', 'red', 'LineWidth', lineWidth);
    %Draw vertebral line
    img = insertShape(img, 'line', [L3_coordinate(1) L3_coordinate(2) L5_coordinate(1) L5_coordinate(2)], 'color', 'green', 'LineWidth', lineWidth); 
    %Draw hard palate line
    img = insertShape(img, 'line', [L2_coordinate(1) L2_coordinate(2) L3_coordinate(1) L3_coordinate(2)], 'color', 'blue', 'LineWidth', lineWidth);     
    
    for i = 1:numLandmarks
       %These are the coordinates of the current landmark
       current_x_coord = data(2 * i - 1);
       current_y_coord = data(2 * i);
       currentCoordinate = [current_x_coord current_y_coord];
       %Draw the crosshairs
       img = insertMarker(img, currentCoordinate, 'x', 'size', 6);
       
       %Draw the text labels
       img = insertText(img, currentCoordinate, landmarkLabels{i}, 'AnchorPoint', landmarkLabelLocations{i});
    end
    
    


    
    %Mylohyoid line linear equation coefficient (L3 - L1)
%     mylohyoid_m = (L3_coordinate(2) - L1_coordinate(2)) / (L3_coordinate(1) - L1_coordinate(1));
%     mylohyoid_b = -1 * (mylohyoid_m * L3_coordinate(1) + L3_coordinate(2));
%     mylohyoid_x_dist = abs(L3_coordinate(1) - L1_coordinate(2));
%     x_extension_minus = L1_coordinate(1) - 0.1 * mylohyoid_x_dist;
%     x_extension_plus = L3_coordinate(1) + 0.1 * mylohyoid_x_dist;
%     y_minus = mylohyoid_m * x_extension_minus + mylohyoid_b;
%     y_plus = mylohyoid_m * x_extension_plus + mylohyoid_b;


%     y - y1 = m*x - m*x1
%     y = m*x - (m*x1 + y1)
%     b = -(m*x1 + y1)
    img = imcrop(img);
    imshow(img)

end