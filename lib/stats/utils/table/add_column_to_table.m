function [newTable] = add_column_to_table(table, columnData)
    %% Check if inputs were given
    if nargin ~= 2
        throw(missing_inputs_error(nargin, 2));
    end
    
    %% Determine if table is cell or matrix
    if isa(table, 'cell')
        tableIsCell = true;
    elseif isnumeric(table)
        tableIsCell = false;
    else
        throw(invalid_type_error({'table'}, {'cell or matrix'}));
    end
    
    nRows = size(table, 1);
    %% Check if we can add column data
    if tableIsCell && ~isa(columnData, 'cell')
        throw(invalid_type_error({'columnData'}, {'cell'}));
    elseif ~tableIsCell && ~isnumeric(columnData)
        throw(invalid_type_error({'columnData'}, {'matrix'}));
    end
    
    %% Try padding and adding data
    try
        if isempty(columnData)
            newTable = table;
        elseif size(columnData, 1) < nRows
            [paddedCols] = pad_data(columnData, [nRows, size(columnData, 2)]);
            newTable = [table, paddedCols];
        else
            [paddedTable] = pad_data(table, [size(columnData, 1), size(table, 2)]);
            newTable = [paddedTable, columnData];
        end
    catch err
        rethrow(err);
    end
end