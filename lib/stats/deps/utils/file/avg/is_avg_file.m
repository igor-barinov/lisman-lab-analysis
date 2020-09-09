% 'is_avg_file' Function
%   Checks if an input struct follows the 'avg_file' struct format
%
% INPUTS
% ------
% <fileStruct>, struct: Struct to be checked
%
% OUTPUTS
% -------
% <tf>, logical: True if <fileStruct> has the fields 'avgData' and 'info'.
%                'avgData' must follow the 'avg_data' struct format and
%                'info' must follow the 'exp_info' struct format.
%                False otherwise
%
% EXCEPTIONS
% ----------
% 'missing_inputs_error' if <fileStruct> was not given
% 
% See also
%   'is_avg_data_struct'
%   'is_exp_info_struct'
%
function [tf] = is_avg_file(fileStruct)
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Check if input struct has fields 'avgData' and 'info'
    if ~isfield(fileStruct, 'avgData') || ~isfield(fileStruct, 'info')
        tf = false;
        return;
    end
    
    %% Verify that 'avgData' is an 'avg_data' struct
    if ~is_avg_data_struct(fileStruct.avgData)
        tf = false;
        return;
    end
    if ~is_exp_info_struct(fileStruct.info)
        tf = false;
        return;
    end
    
    tf = true;
end