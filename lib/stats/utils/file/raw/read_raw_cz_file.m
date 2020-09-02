function [roiData] = read_raw_cz_file(filepath)
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
    
    %% Verify that the file follows CZ format
    [~, expName, ~] = fileparts(filepath);
    if ~is_raw_cz_file(expName, inputFile)
        throw(invalid_struct_error(inputFile, raw_cz_file_format(expName)));
    end
    
    %% Read the raw ROI data
    try
        czStruct = getfield(inputFile, expName);
        [roiData] = read_raw_cz_struct(czStruct);
    catch err
        rethrow(err);
    end
end