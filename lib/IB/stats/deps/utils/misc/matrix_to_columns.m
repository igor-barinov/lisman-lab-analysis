% 'matrix_to_columns' Function
%   Converts a matrix to a cell array of vectors
%
% INPUTS
% ------
% <mat>, matrix: Matrix to be converted
%
% OUTPUTS
% -------
% <cols>, 1 x N cell: Will contain each column of <mat>
%
% EXCEPTIONS
% ----------
% 'missing_inputs_error' if <mat> was not given
% 'invalid_type_error' if <mat> is not a matrix
%
function [cols] = matrix_to_columns(mat)    
    %% Check if we have a matrix input
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    if ~isnumeric(mat)
        throw(invalid_type_error({'mat'}, {'numeric'}));
    end

    cols = cell(1,size(mat,2));
    for i = 1:size(mat,2)
        cols{i} = mat(:,i);
    end
end