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
      lvc_onset;
      lvc_offset;
      laryngeal_jump;
      ues_opening;
      
      %UES Distension Points
      ues_point1;
      ues_point2;
      
      %Calibration for SI units
      si_point1;
      si_point2;
      pixelspercm;
      
      %UES distension
      uesd_points;
      uesd_dist;
      
      %NRRS valleculae - val res = residue in valleculae
      nrrs_valres_points;
      nrrs_valres_area;
      nrrs_totalval_points;
      nrrs_totalval_area;
      
      %NRRS piriform - piri res = residue in piriform recess
      nrrs_pirires_points;
      nrrs_pirires_area;
      nrrs_totalpiri_points;
      nrrs_totalpiri_area;
      
      %Calibration for PCR
      pcr_min_points;
      pcr_min_area;
      pcr_max_points;
      pcr_max_area;
      
      %Penetration Aspiration Ratio
      pas;
      pas_classifiers;
      
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