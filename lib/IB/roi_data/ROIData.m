classdef (Abstract) ROIData
    methods (Abstract)
        [count] = roi_count(obj);
        [counts] = point_counts(obj);
        [labels] = roi_labels(obj);
        
        [values] = time(obj);
        [adjVals] = adjusted_time(obj, nBaselinePts);
        
        [values] = lifetime(obj);
        [normVals] = normalized_lifetime(obj, nBaselinePts);
        
        [tf] = green_is_integral(obj);
        [values] = green(obj);
        [values] = green_integral(obj);
        [normVals] = normalized_green(obj, nBaselinePts);
        [normVals] = norm_green_integral(obj, nBaselinePts);
        
        [tf] = red_is_integral(obj);
        [values] = red(obj);
        [values] = red_integral(obj);
        [normVals] = normalized_red(obj, nBaselinePts);
        [normVals] = norm_red_integral(obj, nBaselinePts);
    end
end