classdef FrameCoordinates < handle
   properties
        coordinates; %This holds the cell array of coordinates for one particular frame
   end
   
   methods
       function obj = FrameCoordinates()
%           obj.jaw = [-1 -1];
%           obj.skull = [-1 0.0];
%           obj.c1 = [0.0 0.0];
%           obj.c2 = [0.0 0.0];
%           obj.c4 = [0.0 0.0];
%           obj.ues = [0.0 0.0];
%           obj.postCric = [0.0 0.0];
%           obj.antCric = [0.0 0.0];
%           obj.hyoid = [0.0 0.0];
            [~, s] = enumeration('Data.JoveLandmarks');
            obj.coordinates = cell([size(s, 1), 1]);
       end
   end
    
end