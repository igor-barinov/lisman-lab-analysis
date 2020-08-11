classdef (Abstract) ROIData
    methods (Abstract)
        [count] = roi_count(obj);
        [counts] = point_counts(obj);
        [labels] = roi_labels(obj);
        
        [values] = time(obj);
        [adjVals] = adjusted_time(obj, nBaselinePts);
        
        [values] = lifetime(obj);
        [normVals] = normalized_lifetime(obj, nBaselinePts);
        [values] = green(obj);
        [normVals] = normalized_green(obj, nBaselinePts);
        [values] = red(obj);
        [normVals] = normalized_red(obj, nBaselinePts);
    end
end