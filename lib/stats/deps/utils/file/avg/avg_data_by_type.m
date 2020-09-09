% 'avg_data_by_type' Function
%   Gets the mean and std. error of the specified data type
%
% INPUTS
% ------
% <avgDataStruct>, struct: Contains all averages. Must be in 'avg_data' struct format
% <dataType>, char: The desired data type. Must be 'int', 'red', or 'lifetime'
%
% OUTPUTS
% -------
% <mean>, matrix: Mean values
% <ste>, matrix: Std. error values
% <normMean>, matrix: Normalized mean values
% <normSte>, matrix: Normalized std. error values
% 
% EXCEPTIONS
% ----------
% 'missing_inputs_error' if 2 inputs were not given
% 'general_error' if <dataType> was 'lifetime', but <avgDataStruct> did not have the 'lifetime' field
%
% See also
%   'avg_data_count'
%   'read_avg_data_struct'
%   
function [mean, ste, normMean, normSte] = avg_data_by_type(avgDataStruct, dataType)
    mean = [];
    ste = [];
    normMean = [];
    normSte = [];
    
    %% Check if all inputs were given
    if nargin ~= 2
        throw(missing_inputs_error(nargin, 2));
    end
    
    %% Try reading the input struct
    try
        [numROI, ~, hasLifetime] = avg_data_count(avgDataStruct);
        [~, ~, int, red, lifetime] = read_avg_data_struct(avgDataStruct);
    catch err
        rethrow(err);
    end
    
    %% Get averages by data type
    if strcmp(dataType, 'int')
        mean = int.avg(:, 1:numROI);
        ste = int.avg(:, numROI+1:end);
        normMean = int.normAvg(:, 1:numROI);
        normSte = int.normAvg(:, numROI+1:end);
    elseif strcmp(dataType, 'red')
        mean = red.avg(:, 1:numROI);
        ste = red.avg(:, numROI+1:end);
        normMean = red.normAvg(:, 1:numROI);
        normSte = red.normAvg(:, numROI+1:end);
    elseif strcmp(dataType, 'lifetime')
        if ~hasLifetime
            throw(general_error({'avgDataStruct'}, '''lifetime'' field does not exist'));
        end
        
        mean = lifetime.avg(:, 1:numROI);
        ste = lifetime.avg(:, numROI+1:end);
        normMean = lifetime.normAvg(:, 1:numROI);
        normSte = lifetime.normAvg(:, numROI+1:end);
    end
end