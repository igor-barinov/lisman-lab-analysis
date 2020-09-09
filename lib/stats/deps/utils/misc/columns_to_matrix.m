% 'columns_to_matrix' Function
%   Converts a cell array of matrices to a single matrix with a specific length
%
% INPUTS
% ------
% <columns>, 1 X N cell: Contains matrices to be combined
% <targetLength>, number: The desired length of the output matrix
%
% OUTPUTS
% -------
% <mat>, matrix: Matrix containing the values of the input matrices. Input
%                matrices smaller than the desired length will be padded with NaNs. 
%                Input matrices larger than the desired length will be resized, 
%                losing some values.
%
% EXCEPTIONS
% ----------
% 'missing_inputs_error' if 2 inputs were not given
% 'invalid_type_error' if <columns> is not a cell with size [1 N]
%
function [mat] = columns_to_matrix(columns, targetLength)
    mat = [];    
    
    %% Check if we have the necessary inputs
    if nargin ~= 2
        throw(missing_inputs_error(nargin, 2));
    end

    %% Verify that a 1 X n cell was given
    if ~isa(columns, 'cell') || size(columns, 1) ~= 1
        throw(invalid_type_error({'columns'}, {'1 X n cell'}));
    end
    
    %% Build the matrix column by column, padding where necessary
    for i = 1:size(columns, 2)
        col = columns{:, i};
        
        if length(col) < targetLength
            col = [col; NaN(targetLength - length(col), 1)];
        elseif length(col) > targetLength
            col = col(1:targetLength);
        end

        mat = [mat, col];
    end
end