classdef GlobalStudyInfo < handle
   properties
      %These are all classes I made
      vfVideoStructure;
      studyImageProcessingInfo;
      studyCoordinates;
      
      %Kinematic Frame Numbers
      hold_position;
      ramus_mandible;
      hyoid_burst;
      ues_closure;
      at_rest;
      start_frame;
      end_frame;
      
      %Calibration for SI units
      point1;
      point2;
      pixelspercm;
      
      %Global sessoin info
      currentlyTrackedLandmark = Data.JoveLandmarks.Mandible;
      
      %These are MATLAB provided classes I will use. These 2 are not being
      %used
      vfTracker;
      harrisCorner
      
      %Settings to use for the KLT Tracker
      kltNumPyramidLevels = 3;
      kltBlockSize = [11 11];
      kltMaxIterations = 100;
      
      %These will supercede he above 3 parameters
      harrisFeatureDetectorParameters = ImageProcessing.HarrisFeatureDetectorParameters;
      kltTrackerParameters = ImageProcessing.KLTParameters;
      
      
   end
    
end