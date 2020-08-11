function [rowsSelected, selectionLayout] = table_selection_layout(selection, table, tableLayout)
    %% Check if all inputs were given
    if nargin ~= 3
        throw(missing_inputs_error(nargin, 3));
    end
    
    %% Check if selection is valid
    if ~isnumeric(selection) || size(selection, 2) ~= 2
        throw(invalid_type_error({'selection'}, {'n x 2 matrix'}));
    end
    %% Check if table is valid
    if ~isnumeric(table) && ~iscell(table)
        throw(invalid_type_error({'table'}, {'matrix or cell'}));
    end
    %% Check if table layout is valid
    if ~iscell(tableLayout) || size(tableLayout, 1) ~= 1
        throw(invalid_type_error({'tableLayout'}, {'1 x m matrix'}));
    end
    
    %% Get the rows selected
    rowsSelected = unique(selection(:, 1));
    
    %% Get the selection layout
    selectionLayout = cell(1, length(tableLayout));
    for i = 1:length(tableLayout)
        tableCols = tableLayout{i};
        selectionCols = selection(:, 2);
        selectionIndices = ismember(selectionCols, tableCols);
        selectionLayout{i} = unique(selectionCols(selectionIndices))';
    end
end