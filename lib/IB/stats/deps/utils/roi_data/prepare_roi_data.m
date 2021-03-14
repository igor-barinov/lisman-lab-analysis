function [preparedRoiData] = prepare_roi_data(roiDataStruct, numBasePts)
    %% Check if both inputs were given
    if nargin ~= 2
        throw(missing_inputs_error(nargin, 2));
    end
    
    %% Check if input struct is a 'roi_data' struct
    if ~is_roi_data_struct(roiDataStruct)
        throw(invalid_struct_error(roiDataStruct, roi_data_struct_format()));
    end
    
    %% Try adjusting time values
    try
        [adjTime] = adjust_roi_time(roiDataStruct.time, numBasePts);
    catch err
        rethrow(err);
    end
    
    preparedRoiData = roiDataStruct;
    preparedRoiData.time = adjTime;
end