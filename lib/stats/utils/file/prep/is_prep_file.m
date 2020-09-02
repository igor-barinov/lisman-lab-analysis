% 'is_prep_file' Function
%   Checks if the input struct contains 'prep' file data
%
% INPUTS
% ------
% <fileStruct>, struct: Struct to be checked
% 
% OUTPUTS
% -------
% <tf>, logical: True if <fileStruct> has fields 'rawData', 'prepData', and 'info'.
%                'rawData' and 'prepData' must follow the 'roi_data' struct format.
%                'info' must follow the 'exp_info' struct format
%
% EXCEPTIONS
% ----------
% 'missing_inputs_error' if <fileStruct> was not given
% 
% See also
%   'is_roi_data_struct'
%   'is_exp_info_struct'
%
function [tf] = is_prep_file(fileStruct)    
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Check if input struct has all fields
    if  ~isfield(fileStruct, 'rawData') || ...
        ~isfield(fileStruct, 'prepData') || ...
        ~isfield(fileStruct, 'info')
        tf = false;
        return;
    end
    
    %% Verify data fields
    if ~is_roi_data_struct(fileStruct.rawData)
        tf = false;
        return;
    end
    if ~is_roi_data_struct(fileStruct.prepData)
        tf = false;
        return;
    end
    
    %% Verify info field
    if ~is_exp_info_struct(fileStruct.info)
        tf = false;
        return;
    end
    
    tf = true;
end