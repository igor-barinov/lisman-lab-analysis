% 'is_avg_file_data' Function
%   Checks if a 'file_data' struct contains 'avg' or 'avg_old' file data
%
% INPUTS
% ------
% <fileDataStruct>, struct: Struct to be checked
% 
% OUTPUTS
% -------
% <tf>, logical: True if <fileDataStruct> has fields 'type', 'avgData', and 'info'.
%                'type' must be either 'AVG_OLD' or 'AVG'. False otherwise
%
% EXCEPTIONS
% ----------
% 'missing_inputs_error' if <fileDataStruct> was not given
% 
% See also
%   'file_type_is'
%
function [tf] = is_avg_file_data(fileDataStruct)
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Check if type is correct
    if ~isfield(fileDataStruct, 'type') || ~file_type_is(fileDataStruct.type, 'AVG_OLD', 'AVG')
        tf = false;
        return;
    end
    
    %% Check if avg data exists along with experiment info
    if ~isfield(fileDataStruct, 'avgData') || ~isfield(fileDataStruct, 'info')
        tf = false;
        return;
    end
    
    tf = true;
end