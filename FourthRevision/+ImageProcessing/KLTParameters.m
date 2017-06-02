classdef(Sealed=true) KLTParameters < handle
   properties
       numPyramidLevels = 3;
       maxBidirectionalError = inf;
       blockSize = [31 31];
       maxIterations = 30;
   end
   
   methods
       function obj = KLTParameters
            %Nothing. Just a struct with field checking
       end
   end
    
end