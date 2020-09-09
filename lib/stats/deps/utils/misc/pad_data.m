% 'pad_data' Function
%   Pads an input cell or matrix with empty values or NaNs
%
% INPUTS
% ------
% <inputData>, cell or matrix: Contains values to be padded
% <targetSize>, matrix: The desired output dimensions. 
%                       Must be 2-dimensional and at least
%                       the size of <inputData>
%
% OUTPUTS
% -------
% <paddedData>, cell or matrix: Contains original values with padding. 
%                               If the input was a cell, the padding is empty arrays. 
%                               If the input was a matrix, the padding is NaNs
%
% EXCEPTIONS
% ----------
% 'missing_inputs_error' if 2 inputs were not given
% 'invalid_type_error' if 
%   <inputData> was not a matrix nor a cell
%   <targetSize> was not a 1 x 2 matrix
% 'range_error' if 
%   <targetSize> @ (1) was less than the number of rows in <inputData>
%   <targetSize> @ (2) was less than the number of columns in <inputData>
%
function [paddedData] = pad_data(inputData, targetSize)
    %% Check if all inputs were given
    if nargin ~= 2
        throw(missing_inputs_error(nargin, 2));
    end
    
    %% Get the input data type
    if isnumeric(inputData)
        inputIsMatrix = true;
    elseif iscell(inputData)
        inputIsMatrix = false;
    else
        throw(invalid_type_error({'inputData'}, {'matrix or cell'}));
    end
   
    %% Check if target size is valid
    nRows = size(inputData, 1);
    nCols = size(inputData, 2);
    if ~isnumeric(targetSize) || size(targetSize, 1) ~= 1 || size(targetSize, 2) ~= 2
        throw(invalid_type_error({'targetSize'}, {'1 x 2 matrix'}));
    end
    if targetSize(1) < nRows
        throw(range_error('targetSize(1)', nRows, nan));
    elseif targetSize(2) < nCols
        throw(range_error('targetSize(2)', nCols, nan));
    end
    
    %% Pad rows
    nMissingRows = targetSize(1) - nRows;
    if inputIsMatrix
        rowPadding = nan(nMissingRows, nCols);
    else
        rowPadding = cell(nMissingRows, nCols);
    end
    paddedData = [inputData; rowPadding];
    
    
    %% Pad columns
    nMissingCols = targetSize(2) - nCols;
    if inputIsMatrix
        colPadding = nan(size(paddedData, 1), nMissingCols);
    else
        colPadding = cell(size(paddedData, 1), nMissingCols);
    end
    paddedData = [paddedData, colPadding];
end