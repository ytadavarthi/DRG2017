classdef JoveLandmarks < uint8
    
    
    
   enumeration
      Mandible (1);
      Hard_Palate (2);
      C1 (3);
      C2 (4);
      C4 (5);
      UES (6);
      PostCric (7);
      AntCric (8);
      Hyoid (9);
      Valleculae (10);
      SPC (11);
      MPC (12);
      Landmark_13 (13);
      Landmark_14 (14);
      Landmark_15 (15);
      Landmark_16 (16);
      Landmark_17 (17);
      Landmark_18 (18);
      Landmark_19 (19);
      Landmark_20 (20);      
   end
   
   methods(Static=true)       
       function res = numLandmarks
          [m, s] = enumeration('Data.JoveLandmarks');
          res = size(s, 1);
       end
    
       
   end
end