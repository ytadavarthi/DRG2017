classdef MedianFilterProps< handle & ImageProcessing.FilterProps
    properties
       activated;
       windowSize;
    end
    
    
    methods
        function obj = MedianFilterProps(varargin)
           obj.activated = false;
           if (numel(varargin) == 0)
              obj.windowSize = [3 3]; 
           else
               obj.windowSize = [varargin{1} varargin{1}];
           end
        end
    end
end