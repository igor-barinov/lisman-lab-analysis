function [newTable] = add_row_to_table(table, rowData)
    %% Check if inputs were given
    if nargin ~= 2
        throw(missing_inputs_error(nargin, 2));
    end
    
    %% Determine if table is cell or matrix
    if isempty(table)
        tableIsCell = iscell(rowData);
    elseif isa(table, 'cell')
        tableIsCell = true;
    elseif isnumeric(table)
        tableIsCell = false;
    else
        throw(invalid_type_error({'table'}, {'cell or matrix'}));
    end
    
    nCols = size(table, 2);
    %% Check if we can add row data
    if tableIsCell && ~isa(rowData, 'cell')
        throw(invalid_type_error({'rowData'}, {'cell'}));
    elseif ~tableIsCell && ~isnumeric(rowData)
        throw(invalid_type_error({'rowData'}, {'matrix'}));
    end

    %% Try padding and adding data
    try
        if isempty(rowData)
            newTable = table;
        elseif size(rowData, 2) < nCols
            [paddedRows] = pad_data(rowData, [size(rowData, 1), nCols]);
            newTable = [table; paddedRows];
        else
            [paddedTable] = pad_data(table, [size(table, 1), size(rowData, 2)]);
            newTable = [paddedTable; rowData];
        end
    catch err
        rethrow(err);
    end
    
end