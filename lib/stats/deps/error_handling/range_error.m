% 'range_error' Exception
%   Error raised when a value is outside an expected range
%
% INPUTS
% ------
% <argName>, char: Name of argument that caused the error
% <minVal>, number: The smallest value expected
% <maxVal>, number, The largest value expected
%
function [ME] = range_error(argName, minVal, maxVal)
    formattedMsg = ['<', argName, '> '];
    if isnan(minVal)
        formattedMsg = [formattedMsg, 'must be no more than ', num2str(maxVal), '.'];
    elseif isnan(maxVal)
        formattedMsg = [formattedMsg, 'must be at least ', num2str(minVal), '.'];
    else
        formattedMsg = [formattedMsg, 'must be between ', num2str(minVal), ' and ', num2str(maxVal), ' (inclusive).'];
    end
    ME = MException('MATLAB:Range', formattedMsg);
end