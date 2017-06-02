classdef VFVideoStructure < handle
   properties(Hidden=false)
      videoFrames;
      resolution;
      nativeDataType;
      fileName; %This is actually the full file name
      numFrames;
   end
   
   
   methods
       function obj = VFVideoStructure(vfFileName)
          if (~exist(vfFileName, 'file'))
             throw (MException('VFVideoStructure:VFVideoStructure', 'Bad file name or file not found: ')); 
          end
          
          try
            videoFileReader = vision.VideoFileReader(vfFileName);
            
            obj.fileName = videoFileReader.Filename;
            obj.nativeDataType = videoFileReader.VideoOutputDataType;
            
            obj.numFrames = 0;
            obj.videoFrames = {};
            while (~isDone(videoFileReader))
               obj.numFrames = obj.numFrames + 1;
               obj.videoFrames{end + 1} = step(videoFileReader);
            end
            
            release(videoFileReader);
            
            obj.resolution = size(obj.videoFrames{1});
            
          catch e
             rethrow(e); 
          end
          
       end
   end
    
    
end