function [dataTable, labels] = roi_data_to_table(roiDataStruct)
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    %% Try getting all data fields
    try
        [hasLifetime, time, int, red, lifetime] = read_roi_data_struct(roiDataStruct);
    catch err
        rethrow(err);
    end

    %% Check if data fields are uniform
    if hasLifetime
        fields = {time, int, red, lifetime};
    else
        fields = {time, int, red};
    end

    if ~columns_are_uniform(fields)
        throw(non_uniform_error({'time', 'int', 'red', 'lifetime'}));
    end

    %% Combine data into a table
    dataTable = time;
    if hasLifetime
        dataTable = [dataTable, lifetime];
    end
    dataTable = [dataTable, int];
    dataTable = [dataTable, red];

    %% Generate table labels
    labels = {'Time'};
    if hasLifetime
        numROI = (size(dataTable, 2) - 1) / 3;

        %% Generate lifetime labels
        for roi = 1:numROI
            labels{end+1} = strcat('Tau', ' ', '#', num2str(roi));
        end

        %% Generate int labels
        for roi = 1:numROI
            labels{end+1} = strcat('Int', ' ', '#', num2str(roi));
        end

        %% Generate red labels
        for roi = 1:numROI
            labels{end+1} = strcat('Red', ' ', '#', num2str(roi));
        end
    else
        numROI = (size(dataTable, 2) - 1) / 2;

        %% Generate int labels
        for roi = 1:numROI
            labels{end+1} = strcat('Int', ' ', '#', num2str(roi));
        end

        %% Generate red labels
        for roi = 1:numROI
            labels{end+1} = strcat('Red', ' ', '#', num2str(roi));
        end
    end
end