% 'invalid_struct_error' Exception
%   Error raised when a struct is missing fields
%
% INPUTS
% ------
% <invalidStruct>, struct: Struct that caused the error
% <expectedFields>, cell: Contains the names of fields that were expected
%
function [ME] = invalid_struct_error(invalidStruct, expectedFields)
    invalidFields = cellstr_to_formatted_str(fieldnames(invalidStruct), '<', '>', ' ');
    validFields = cellstr_to_formatted_str(expectedFields, '<', '>', ' ');
    formattedMsg = ['Invalid struct. Given fields: ', invalidFields, '. '];
    formattedMsg = [formattedMsg, 'Expected fields: ', validFields, '.'];
    ME = MException('MATLAB:InvalidStruct', formattedMsg);
end