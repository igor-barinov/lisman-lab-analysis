% 'combine_roi_files' Function
%   Combines data from 'file_data' structs into a single struct
%
% INPUTS
% ------
% <roiFiles>, struct array: Contains structs to be combined. Must be in the 'file_data' format
% 
% OUTPUTS
% -------
% <combinedFileData>, struct: Will contain the combined data in the 'file_data' format.
%                             Combination depends on the type of file as such:
%                             'raw_cz': 
%                                       ROI data is combined so that the
%                                       total number of ROIs increases. The longest
%                                       time data set is used.
%                             'raw_hz': 
%                                       ROI data is combined so that the
%                                       total number of data points increases. Data
%                                       is added in the order given, so ascending
%                                       time values are not guaranteed.
%                             'prep' and 'prep_old': 
%                                       ROI data is combined according to 'raw_cz' protocol.
%                                       Experiment info is combined by appending struct data, 
%                                       so no data is removed/prioritized
%                             'avg' and 'avg_old': 
%                                       TODO
%
% EXCEPTIONS
% ----------
% 'missing_inputs_error' if <roiFiles> was not given
% 'empty_array_error' if <roiFiles> is empty
% 'invalid_type_error' if <roiFiles> contain structs with different formats
% 'general_error' if the type of <roiFiles> is not recognized
%
% See also
%   'combine_roi_data_structs'
%   'add_to_roi_data'
%   'combine_exp_info_structs'
%
function [combinedFileData] = combine_roi_files(roiFiles)
    combinedFileData = struct;
    
    %% Check if at least one file was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    fileCount = numel(roiFiles);
    if fileCount < 1
        throw(empty_array_error('roiFiles'));
    end
    
    %% Check if the files are all the same type
    fileType = roiFiles(1).type;
    for i = 1:fileCount
        if (~strcmp(fileType, roiFiles(i).type))
            throw(invalid_type_error({'roiFiles'}, {fileType}));
        end
    end
    
    %% Combine the files depending on 'fileType'    
    if file_type_is(fileType, 'RAW_CZ')
        %% Combine RAW_CZ files by combining the data structs
        try
            [combinedFileData.rawData] = combine_roi_data_structs([roiFiles.rawData]);
        catch err
            rethrow(err);
        end
        combinedFileData.type = fileType;
        
    elseif file_type_is(fileType, 'RAW_HZ')
        %% Combine RAW_HZ files by adding data pts
        combinedRawData = roiFiles(1).rawData;
        for i = 2:fileCount
            try
                [combinedRawData] = add_to_roi_data(combinedRawData, roiFiles(i).rawData.time, roiFiles(i).rawData.int, roiFiles(i).rawData.red);
            catch err
                rethrow(err);
            end
        end
        combinedFileData.rawData = combinedRawData;
        combinedFileData.type = fileType;
        
    elseif file_type_is(fileType, 'PREP_OLD', 'PREP')
        %% Combine raw/prep data by combining the structs
        try
            [combinedRawData] = combine_roi_data_structs([roiFiles.rawData]);
            [combinedPrepData] = combine_roi_data_structs([roiFiles.prepData]);
            [combinedExpInfo] = combine_exp_info_structs([roiFiles.info]);
        catch err
            rethrow(err);
        end
        
        combinedFileData.rawData = combinedRawData;
        combinedFileData.prepData = combinedPrepData;
        combinedFileData.info = combinedExpInfo;
        combinedFileData.type = fileType;
    elseif file_type_is(fileType, 'AVG_OLD', 'AVG')
        try
            [combinedAvgData] = combine_avg_data_structs([roiFiles.avgData]);
            [combinedExpInfo] = combine_exp_info_structs([roiFiles.info]);
        catch err
            rethrow(err);
        end
        
        combinedFileData.avgData = combinedAvgData;
        combinedFileData.info = combinedExpInfo;
        combinedFileData.type = fileType;
    else
        %% Other file types don't have ROI data
        throw(general_error({'roiFiles'}, 'Data combination not supported'));
    end
end