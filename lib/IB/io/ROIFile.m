classdef (Abstract) ROIFile < ROIData
    methods (Abstract)        
        [fileType] = type(obj);
        [filepaths] = source_files(obj);
        [names] = experiment_names(obj);
        [count] = file_count(obj);
        [counts] = file_roi_counts(obj);
        
        [tf] = has_exp_info(obj);
        [dnaTypes] = dna_types(obj);
        [solutions] = solution_info(obj);
    end
    
    methods (Abstract, Static)
        [tf] = follows_format(filepaths);
        save(filepath, roiData, dnaType, solutionInfo);
    end
end