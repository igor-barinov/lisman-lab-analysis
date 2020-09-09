% 'is_raw_file_data' Function
%   Checks if a 'file_data' struct contains 'raw_cz' or 'raw_hz' file data
%
% INPUTS
% ------
% <fileDataStruct>, struct: Struct to be checked
% 
% OUTPUTS
% -------
% <tf>, logical: True if <fileDataStruct> has fields 'type' and 'rawData'.
%                'type' must be either 'RAW_CZ' or 'RAW_HZ'. False otherwise
%
% EXCEPTIONS
% ----------
% 'missing_inputs_error' if <fileDataStruct> was not given
% 
% See also
%   'file_type_is'
%
function [tf] = is_raw_file_data(fileDataStruct)
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Check if type is correct
    if ~isfield(fileDataStruct, 'type') || ~file_type_is(fileDataStruct.type, 'RAW_CZ', 'RAW_HZ')
        tf = false;
        return;
    end
    
    %% Check if raw data exists
    if ~isfield(fileDataStruct, 'rawData')
        tf = false;
        return;
    end
    
    tf = true;
end