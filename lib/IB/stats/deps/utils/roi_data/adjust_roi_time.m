function [adjTime] = adjust_roi_time(timeValues, numBasePts)
    %% Check if all inputs were given
    if nargin ~= 2
        throw(missing_inputs_error(nargin, 2));
    end
    
    %% Check if time values are valid
    if ~isnumeric(timeValues) || size(timeValues, 2) ~= 1
        throw(invalid_type_error({'timeValues'}, {'n x 1 matrix'}));
    end
    
    %% Check if the # of base points is valid
    if numBasePts < 1 || numBasePts > length(timeValues)
        throw(range_error('numBasePts', 1, length(timeValues)));
    end
   
    %% adjusted time = minutes - minutes[baseline]
    adjTime = timeValues * 60 * 24;
    adjTime = adjTime - adjTime(numBasePts);
end