% 'cellstr_to_formatted_str' Function
%   Converts a cell array of strings into a single formatted string with
%   decorators and delimiters
%
% INPUTS
% ------
% <cellStr>, cell: Cell containing strings to be combined
% <lDecorator>, char: Char(s) that will be placed left of each string
% <rDecorator>, char: Char(s) that will be placed right of each string
% <delimiter>, char: Char(s) that will be placed before and after each string
%
% OUTPUTS
% -------
% <formattedStr>, char: The resulting string in the form: '<delimiter><lDecorator><string><rDecorator><delimiter>'
%
function [formattedStr] = cellstr_to_formatted_str(cellStr, lDecorator, rDecorator, delimiter)
    formattedStr = [];
    for i = 1:numel(cellStr)
        formattedStr = [formattedStr, delimiter, lDecorator, cellStr{i}, rDecorator, delimiter];
    end
end