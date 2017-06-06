%An enumeration to keep track of whether a landmark in a certain frame has
%yet to be annotated, was manually annotated, or automatically annotated.
classdef (Sealed=true) TrackingType
    enumeration
       Untracked, Manual, Automatic 
    end
end