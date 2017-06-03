classdef StudyCoordinates < handle
   properties
      coordinates; %This holds the cell array of coordinates for each frame as stored in Data.FrameCoordinates
      trackedStatus; %This holds the cell array of tracked status for each frame as stored in Data.TrackedStatus
   end
   
   methods
       function obj = StudyCoordinates(vfVideoStructure)
           if ~(isa(vfVideoStructure, 'Data.VFVideoStructure'))
              throw(MException('StudyCoordinates:StudyCoordinates', 'Constructor requires VFVideoStructure to be initialize')); 
           end
           
           obj.coordinates = cell(vfVideoStructure.numFrames, 1);
           obj.trackedStatus = cell(vfVideoStructure.numFrames, 1);
           
           for i = 1:vfVideoStructure.numFrames
              obj.coordinates{i} = Data.FrameCoordinates; 
              obj.trackedStatus{i} = Data.TrackedStatus;
           end
           
           
       end
       
       function setCoordinate(obj, frameIndex, landmark, coordinate)
           obj.coordinates{frameIndex}.coordinates{uint8(landmark)} = coordinate;  
       end
       
       function result = getCoordinate(obj, frameIndex, landmark)
           result = obj.coordinates{frameIndex}.coordinates{uint8(landmark)};
       end
       
       function setTrackedStatus(obj, frameIndex, landmark, trackingStatus)
          obj.trackedStatus{frameIndex}.statuses{landmark} = trackingStatus; 
       end
       
       function result = getTrackedStatus(obj, frameIndex, landmark)
           result = obj.trackedStatus{frameIndex}.statuses{landmark};
       end
   end
    
end