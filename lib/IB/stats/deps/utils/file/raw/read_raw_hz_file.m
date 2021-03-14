function [roiData] = read_raw_hz_file(filepath)
    roiData = struct;
    
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
    
    %% Verify that the input file follows HZ format
    if ~is_raw_hz_file(inputFile)
        throw(invalid_struct_error(inputFile, raw_hz_file_format()));
    end
    
    %% Load the data into 'roiData' and return successfully
    roiData.time = datenum(inputFile.Aout.timestr);
    roiData.int = inputFile.Aout.green;
    roiData.red = inputFile.Aout.red;
end