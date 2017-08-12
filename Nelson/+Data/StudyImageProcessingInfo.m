classdef StudyImageProcessingInfo < handle
   properties
      framePipelines; 
   end
   
   methods
       function obj = StudyImageProcessingInfo(vfVideoStructure)
           obj.framePipelines = cell(vfVideoStructure.numFrames, 1);
       end
   end
    
end