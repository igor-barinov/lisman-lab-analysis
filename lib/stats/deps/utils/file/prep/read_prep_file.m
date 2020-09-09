function [rawRoiData, prepRoiData, expInfo] = read_prep_file(filepath)    
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Try loading the file
    try
        inputFile = load(filepath);
    catch
        throw(file_open_error(filepath));
    end
    
    %% Verify that the file follows the current PREP format
    if ~is_prep_file(inputFile)
        throw(invalid_struct_error(inputFile, prep_file_format()));
    end
    
    %% Read ROI data
    rawRoiData = inputFile.rawData;
    prepRoiData = inputFile.prepData;
    
    %% Read experiment info
    expInfo = inputFile.info;
end