function [roiFile] = make_roi_file(fileType, rawData, prepData, expInfo, avgData)
    roiFile = struct;
    
    %% Check if file type was given
    if nargin < 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    
    if file_type_is(fileType, 'PREP')
        %% Check if we have all data
        if nargin ~= 4
            throw(missing_inputs_error(nargin, 4));
        end
        
        %% Check if data is valid        
        if ~is_roi_data_struct(rawData)
            throw(invalid_struct_error(rawData, roi_data_struct_format()));
        elseif ~is_roi_data_struct(prepData)
            throw(invalid_struct_error(prepData, roi_data_struct_format()));
        elseif ~is_exp_info_struct(expInfo)
            throw(invalid_struct_error(expInfo, exp_info_struct_format()));
        end
        
        roiFile.rawData = rawData;
        roiFile.prepData = prepData;
        roiFile.info = expInfo;
        roiFile.type = fileType;
    elseif file_type_is(fileType, 'AVG')
        %% Check if we have all data
        if nargin ~= 5
            throw(missing_inputs_error(nargin, 5));
        end
        
        %% Check if data is valid
        if ~is_avg_data_struct(avgData)
            throw(invalid_struct_error(avgData, avg_data_struct_format()));
        elseif ~is_exp_info_struct(expInfo)
            throw(invalid_struct_error(expInfo, exp_info_struct_format()));
        end
        
        roiFile.avgData = avgData;
        roiFile.info = expInfo;
        roiFile.type = fileType;
    else
        throw(general_error({'fileType'}, 'Type is not recognized'));
    end
end