classdef ImageProcessingPipeline < handle
    properties
       operations; 
    end
    
    methods
        function obj = ImageProcessingPipeline(varargin)
           obj.operations = {};
            for i = 1:numel(varargin)
              obj.operations{end + 1} = varargin{i}; 
           end
        end
        
        function addOperations(obj, varargin)
            for i = 1:numel(varargin)
              obj.operations{end + 1} = varargin{i}; 
           end
        end
    end
    
end