classdef(Sealed=true) HarrisFeatureDetectorParameters < handle
    properties
       minQuality = double(0.01);
       filterSize = double(5);
       searchRadius = double(3); %This is not an actual parameter of MATLAB's Harris corner detector. By default, MATLAB's Harris corner detector searches the entire image.
    end
    
    methods

        function obj = HarrisFeatureDetectorParameters
            obj.minQuality = 0.01;
            obj.filterSize = 5;
            obj.searchRadius = 3;
        end
    end
end