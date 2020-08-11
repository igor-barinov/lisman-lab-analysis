function [selection] = table_selection_by_rows(rows, table)
    %% Check if all inputs were given
    if nargin ~= 2
        throw(missing_inputs_error(nargin, 2));
    end
    
    %% Check if table is valid
    if ~isnumeric(table) && ~iscell(table)
        throw(invalid_type_error({'table'}, {'matrix or cell'}));
    end
    %% Check if rows are valid
    if ~isnumeric(rows)
        throw(invalid_type_error({'rows'}, {'matrix'}));
    elseif min(rows) < 1 || max(rows) > size(table, 1)
        throw(range_error('rows', 1, size(table, 1)));
    end
    
    %% Get the selection
    nCols = size(table, 2);
    selection = [];
    for r = 1:length(rows)
        for c = 1:nCols
            selection = [selection; [rows(r), c]];
        end
    end
end