function [intCols, redCols, lifetimeCols] = table_layout_of_roi_data(numROI, hasLifetime)
    lifetimeCols = [];
    
    %% Check if all inputs were given
    if nargin ~= 2
        throw(missing_inputs_error(nargin, 2));
    end
    
    %% Verify that <numROI> is valid
    if numROI < 1
        throw(range_error('numROI', 1, nan));
    end
    
    %% Get the table layout
    if hasLifetime
        lifetimeCols = 2:numROI+1;
        intCols = numROI+2:2*numROI+1;
        redCols = 2*numROI+2:3*numROI+1;
    else
        intCols = 2:numROI+1;
        redCols = numROI+2:2*numROI+1;
    end
end