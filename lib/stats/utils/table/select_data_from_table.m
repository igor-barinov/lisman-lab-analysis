function [data] = select_data_from_table(table, selection)
    %% Check if all inputs were given
    if nargin ~= 2
        throw(missing_inputs_error(nargin, 2));
    end
    
    %% Check if table is valid
    if ~isnumeric(table) && ~iscell(table)
        throw(invalid_type_error({'table'}, {'matrix or cell'}));
    end
    
    %% Check if selection is valid
    if ~isnumeric(selection) || size(selection, 2) ~= 2
        throw(invalid_type_error({'selection'}, {'n x 2 matrix'}));
    end
    
    %% Get the selected data
    indices = sub2ind(size(table), selection(:, 1), selection(:, 2));
    data = table(indices);
end