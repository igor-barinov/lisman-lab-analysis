% 'read_roi_file' Function
%   Reads a file and returns ROI data in a struct. 
%   If the type is not known, then the file type is determined based on file data
%
% INPUTS
% ------
% <filepath>, char: Path to file to be read
% optional <fileType>, char: File type that dictates the data format. 
%                            Must be one of the following:
%                               'RAW_CZ'
%                               'RAW_HZ'
%                               'PREP_OLD'
%                               'PREP'
%                               'AVG_OLD'
%                               'AVG'
%
% OUTPUTS
% -------
% <fileData>, struct: Will contain data in the 'file_data' format
%
% EXCEPTIONS
% ----------
% 'missing_inputs_error' if <filepath> was not given
% 'unsupported_file_error' if file could not be read
% 
% See also
%   'read_raw_cz_file'
%   'read_raw_hz_file'
%   'read_prep_old_file'
%   'read_prep_file'
%   'read_avg_old_file'
%   'read_avg_file'
%
function [fileData] = read_roi_file(filepath, fileType)
    fileData = struct;
    
    %% Determine which inputs were given
    if nargin == 2
        typeIsKnown = true;
    elseif nargin == 1
        typeIsKnown = false;
    else
        throw(missing_inputs_error(nargin, 1));
    end
    
    if typeIsKnown
        %% Try loading the file data into 'fileData' based on 'fileType'
        try
        fileData.type = fileType;
        switch fileType
            case 'RAW_CZ'
                [fileData.rawData] = read_raw_cz_file(filepath);
            case 'RAW_HZ'
                [fileData.rawData] = read_raw_hz_file(filepath);
            case 'PREP_OLD'
                [fileData.rawData, fileData.prepData, fileData.expInfo] = read_prep_old_file(filepath);
            case 'PREP'
                [fileData.rawData, fileData.prepData, fileData.expInfo] = read_prep_file(filepath);
            case 'AVG_OLD'
                [fileData.avgData, fileData.expInfo] = read_avg_old_file(filepath);
            case 'AVG'
                [fileData.avgData, fileData.expInfo] = read_avg_file(filepath);
            otherwise
                throw(unsupported_file_error(filepath));
        end
        catch err
            rethrow(err);
        end
    else        
        %% Try loading as a RAW_CZ file
        try
            [rawData] = read_raw_cz_file(filepath);
            fileData.type = 'RAW_CZ';
            fileData.rawData = rawData;
            isRawCz = true;
        catch
            isRawCz = false;
        end
        %% Try loading as a RAW_HZ file
        try 
            [rawData] = read_raw_hz_file(filepath);
            fileData.type = 'RAW_HZ';
            fileData.rawData = rawData;
            isRawHz = true;
        catch
            isRawHz = false;
        end
        %% Try loading as a PREP_OLD file
        try 
            [rawData, prepData, expInfo] = read_prep_old_file(filepath);
            fileData.type = 'PREP_OLD';
            fileData.rawData = rawData;
            fileData.prepData = prepData;
            fileData.info = expInfo;
            isPrepOld = true;
        catch
            isPrepOld = false;
        end
        %% Try loading as a PREP file
        try 
            [rawData, prepData, expInfo] = read_prep_file(filepath);
            fileData.type = 'PREP';
            fileData.rawData = rawData;
            fileData.prepData = prepData;
            fileData.info = expInfo;
            isPrep = true;
        catch
            isPrep = false;
        end
        %% Try loading as a AVG_OLD file
        try 
            [avgData, expInfo] = read_avg_old_file(filepath);
            fileData.type = 'AVG_OLD';
            fileData.avgData = avgData;
            fileData.info = expInfo;
            isAvgOld = true;
        catch
            isAvgOld = false;
        end
        %% Try loading as a AVG file
        try 
            [avgData, expInfo] = read_avg_file(filepath);
            fileData.type = 'AVG';
            fileData.avgData = avgData;
            fileData.info = expInfo;
            isAvg = true;
        catch
            isAvg = false;
        end
        
        %% Check if file was supported
        if ~isRawCz && ~isRawHz && ~isPrepOld && ~isPrep && ~isAvgOld && ~isAvg
            throw(unsupported_file_error(filepath));
        end
    end
end