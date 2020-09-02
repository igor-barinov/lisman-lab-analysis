% 'invalid_user_input_error' Exception
%   Error raise when the user inputs invalid values into a dialog
%
% INPUTS
% ------
% <inputFields>, cell: Contains the names of the input fields
% <expectedInputs>, cell: Contains descriptions of expected values
%
function [ME] = invalid_user_input_error(inputFields, expectedInputs)
    invalidFields = cellstr_to_formatted_str(inputFields, '''', '''', ' ');
    validInputs = cellstr_to_formatted_str(expectedInputs, '[', ']', ' ');
    formattedMsg = ['Values for inputs ', invalidFields, ' are invalid. Expected ', validInputs, '.'];
    ME = MException('MATLAB:InvalidUserInput', formattedMsg);
end