classdef ImageAdjustProps < handle & ImageProcessing.FilterProps
   properties
      activated;
      gamma;
   end
   
   methods
       function obj = ImageAdjustProps(gamma)
          obj.activated = false;
          obj.gamma = gamma;
       end
   end
end