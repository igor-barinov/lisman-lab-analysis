function [dataTable, labels] = avg_data_to_table(avgData)    
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    try
        %% Try reading the input struct
        [hasLifetime, time, int, red, lifetime] = read_avg_data_struct(avgData);        
        
        %% Try building the table
        dataTable = time;
        if hasLifetime
            [dataTable] = add_column_to_table(dataTable, [lifetime.avg, lifetime.normAvg]);
        end
        [dataTable] = add_column_to_table(dataTable, [int.avg, int.normAvg]);
        [dataTable] = add_column_to_table(dataTable, [red.avg, red.normAvg]);
        
        %% Generate the labels
        numROI = size(int.avg, 2) / 2; % int.avg = [mean1, mean2, ... meanN, ste1, ..., steN]
        labels = {'time'};
        if hasLifetime
            for roi = 1:numROI
                labels{end+1, 1} = ['Tau Mean #', num2str(roi)];
            end
            for roi = 1:numROI
                labels{end+1, 1} = ['Tau Ste #', num2str(roi)];
            end
            for roi = 1:numROI
                labels{end+1, 1} = ['Norm Tau Mean #', num2str(roi)];
            end
            for roi = 1:numROI
                labels{end+1, 1} = ['Norm Tau Ste #', num2str(roi)];
            end
        end
        
        for roi = 1:numROI
            labels{end+1, 1} = ['Int Mean #', num2str(roi)];
        end
        for roi = 1:numROI
            labels{end+1, 1} = ['Int Ste #', num2str(roi)];
        end
        for roi = 1:numROI
            labels{end+1, 1} = ['Norm Int Mean #', num2str(roi)];
        end
        for roi = 1:numROI
            labels{end+1, 1} = ['Norm Int Ste #', num2str(roi)];
        end
        for roi = 1:numROI
            labels{end+1, 1} = ['Red Mean #', num2str(roi)];
        end
        for roi = 1:numROI
            labels{end+1, 1} = ['Red Ste #', num2str(roi)];
        end
        for roi = 1:numROI
            labels{end+1, 1} = ['Norm Red Mean #', num2str(roi)];
        end
        for roi = 1:numROI
            labels{end+1, 1} = ['Norm Red Ste #', num2str(roi)];
        end
        
        
    catch err
        rethrow(err);
    end
end