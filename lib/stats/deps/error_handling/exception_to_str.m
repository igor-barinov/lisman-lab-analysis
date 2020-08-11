% 'exception_to_str' Function
%   Converts an exception struct to a formatted string
%
% INPUTS
% ------
% <exception>, MException: Exception to be formatted
%
% OUTPUTS
% -------
% <formattedStr>, char: Resulting string with exception information. 
%                       String is in the format
%                       '<exception -> message> Call Stack: <function>[<line>] -> [...]'
%
function [formattedStr] = exception_to_str(exception)
    formattedStr = [exception.message, ' Call Stack: '];
    for i = 1:numel(exception.stack)
       formattedStr = [formattedStr, ' ', exception.stack(i).name, '[', num2str(exception.stack(i).line), '] -> '];
    end
end