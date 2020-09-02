function [intData, redData, lifetimeData] = select_roi_data_from_table(selection, table, tableLayout)
    lifetimeData = [];
    
    %% Check if all inputs were given
    if nargin ~= 3
        throw(missing_inputs_error(nargin, 3));
    end
    
    %% Check if input types are valid
    if ~isnumeric(selection) || size(selection, 2) ~= 2 || ...
       ~isnumeric(table) || ~iscell(tableLayout) || size(tableLayout, 1) ~= 1 || size(tableLayout, 2) ~= 4
        throw(invalid_type_error({'selection', 'table', 'tableLayout'}, {'n x 2 matrix', 'matrix', '1 x 4 cell'}));
    end
    
    timeCol = tableLayout{1};
    intCols = tableLayout{2};
    redCols = tableLayout{3};
    lifetimeCols = tableLayout{4};
    
    %% Remove selections with time column
    validSelections = ~ismember(selection(:, 2), timeCol);
    selection = [selection(validSelections, 1), selection(validSelections, 2)];
    if isempty(selection)
        throw(general_error({'selection'}, 'Selection cannot contain data from time column'));
    end
    
    %% Get the int data
    intSelections = ismember(selection(:, 2), intCols);
    intSelection = [selection(intSelections, 1), selection(intSelections, 2)];
    intSelection = sub2ind(size(table), intSelection(:, 1), intSelection(:, 2));
    intData = table(intSelection);
    %% Get the red data
    redSelections = ismember(selection(:, 2), redCols);
    redSelection = [selection(redSelections, 1), selection(redSelections, 2)];
    redSelection = sub2ind(size(table), redSelection(:, 1), redSelection(:, 2));
    redData = table(redSelection);
    %% Get the lifetime data, if possible
    if ~isempty(lifetimeCols)
        ltSelections = ismember(selection(:, 2), lifetimeCols);
        ltSelection = [selection(ltSelections, 1), selection(ltSelections, 2)];
        ltSelection = sub2ind(size(table), ltSelection(:, 1), ltSelection(:, 2));
        lifetimeData = table(ltSelection);
    end
end