classdef (Sealed = true) TrackedStatus < handle
    properties
       statuses; %This holds the cell array of tracked status for each landmark in this frame 
    end
    
    methods
        function obj = TrackedStatus()
            [~, s] = enumeration('Data.JoveLandmarks');
            obj.statuses = cell([size(s, 1), 1]);
            for i = 1:numel(s)
               obj.statuses{i} = Data.TrackingType.Untracked; 
            end
        end
    end
    
end