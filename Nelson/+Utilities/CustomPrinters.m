classdef CustomPrinters
    %CUSTOMPRINTERS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods(Static=true)
        function printInfo(message)
           fprintf('INFO: %s\n', message); 
        end
        
        function printWarning(message)
           fprintf('WARNING: %s\n', message); 
        end
        
        function printError(message)
           fprintf(2, 'ERROR: %s\n', message);
        end
                
    end
    
end

