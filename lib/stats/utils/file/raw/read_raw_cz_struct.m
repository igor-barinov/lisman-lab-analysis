function [roiData] = read_raw_cz_struct(czStruct)
    roiData = struct;
    
    %% Verify that a 'raw_cz' struct was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    if ~is_raw_cz_struct(czStruct)
        throw(invalid_struct_error(czStruct, raw_cz_struct_format()));
    end
    
    %% Try loading struct data into 'roiData'
    ROIs = czStruct.roiData;
    
    roiData.time = {};
    roiData.lifetime = {};
    roiData.int = {};
    roiData.red = {};
    maxLength = 0;
    maxROI = 1;
    for i = 1:numel(ROIs)
        roiData.time{end+1} = ROIs(i).time';
        roiData.lifetime{end+1} = ROIs(i).tau_m';
        roiData.int{end+1} = ROIs(i).mean_int';
        roiData.red{end+1} = ROIs(i).red_mean';

        if length(roiData.time{end}) > maxLength
            maxROI = i;
            maxLength = length(roiData.time{end});
        end
    end
    
    %% Try padding the data
    try
        roiData.time = roiData.time{maxROI};
        [roiData.lifetime] = columns_to_matrix(roiData.lifetime, maxLength);
        [roiData.int] = columns_to_matrix(roiData.int, maxLength);
        [roiData.red] = columns_to_matrix(roiData.red, maxLength);
    catch err
        rethrow(err);
    end
end