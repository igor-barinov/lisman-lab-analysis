function [rawRoiData, prepRoiData, expInfo] = read_prep_old_file(filepath)
    prepRoiData = struct;
    expInfo = struct;
    
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
    
    %% Verify that the file matches the old PREP format
    [~, filename, ~] = fileparts(filepath);
    formatStrIdx = strfind(filename, 'ROI2');
    expName = filename(1:formatStrIdx + 3);
    
    if ~is_prep_old_file(expName, inputFile)
        throw(invalid_struct_error(inputFile, prep_old_file_format(expName)));
    end
    
    %% Try reading raw ROI data into 'rawRoiData'
    try
        czStruct = getfield(inputFile, expName);
        [rawRoiData] = read_raw_cz_struct(czStruct);
    catch err
        rethrow(err);
    end
    
    %% Read prepared ROI data into 'prepRoiData'
    prepData = inputFile.prepData;    
    ROIs = prepData.alladj;
    numROI = (size(ROIs, 2) - 1) / 3;
    prepRoiData.time = ROIs(:, 1);
    prepRoiData.lifetime = ROIs(:, 2:1+numROI);
    prepRoiData.int = ROIs(:, 2+numROI:1+2*numROI);
    prepRoiData.red = ROIs(:, 2+2*numROI:1+3*numROI);

    %% Read experiment info into 'expInfo'
    expInfo.numROI = prepData.numROI;
    expInfo.dnaType = prepData.dnaType;
    expInfo.solutions = prepData.solutions;
end