% 'invalid_type_error' Exception
%   Error raised when variables did not have the correct type
%
% INPUTS
% ------
% <vars>, cell: Contains the names of variables that caused the error
% <expectedTypes>, cell: Contains the data types that were expected
%
function [ME] = invalid_type_error(vars, expectedTypes)
    varList = cellstr_to_formatted_str(vars, '<', '>', ' ');
    typeList = cellstr_to_formatted_str(expectedTypes, '''', '''', ' ');
    formattedMsg = ['Variables ', varList, ' have the wrong type. Expected types: ', typeList, '.'];
    ME = MException('MATLAB:InvalidType', formattedMsg);
end