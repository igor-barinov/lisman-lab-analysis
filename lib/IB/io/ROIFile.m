classdef (Abstract) ROIFile < ROIData
%% ----------------------------------------------------------------------------------------------------------------
% 'ROIFile' Interface
%
% Interface that describes operations for files that handle ROI data
%
    methods (Abstract)        
        [fileType] = type(obj);
        [filepaths] = source_files(obj);
        [names] = experiment_names(obj);
        [count] = file_count(obj);
        [counts] = file_roi_counts(obj);
        
        [tf] = has_exp_info(obj);
        [dnaTypes] = dna_types(obj);
        [solutions] = solution_info(obj);
        
        [tf] = has_preferences(obj);
        [defaults] = plotting_defaults(obj);
        [profile] = figure_defaults_profile(obj);
    end
    
    methods (Abstract, Static)
        [tf] = follows_format(filepaths);
        save(filepath, roiData, dnaType, solutionInfo);
    end
end