classdef ROIUtils
    methods (Static)
        
        %% --------------------------------------------------------------------------------------------------------
        % 'data_exists' Method
        %
        % True if <ROIs> are not empty and have at least one non-NaN value.
        % False otherwise
        %        
        function [tf] = data_exists(ROIs)
            tf = ~isempty(ROIs) && ~all(isnan(ROIs), 'all');
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'normalize' Method
        %
        % Normalizes <ROIs> by setting the first <nBaselinePts> values to
        % have an average of 1
        %
        function [normVals] = normalize(ROIs, nBaselinePts)
            normVals = NaN(size(ROIs));
            for i = 1:size(ROIs, 2)
                roi = ROIs(:, i);
                factor = nBaselinePts / sum(roi(1:nBaselinePts));
                normVals(:, i) = roi * factor;
            end
        end
        
        
        %% --------------------------------------------------------------------------------------------------------
        % 'average' Method
        %
        % Gives the average and standard error of <ROIs>, excluding NaNs
        %
        function [avg, ste] = average(ROIs)
            n = size(ROIs,2);
            avg = nanmean(ROIs, 2);
            ste = nanstd(ROIs, 0, 2) / sqrt(n);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'enable' Method
        %
        % Converts <ROIs> columns that are not <enabledROIs> to NaNs
        %
        function [values] = enable(ROIs, enabledROIs)
            values = NaN(size(ROIs));
            values(:, enabledROIs) = ROIs(:, enabledROIs);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'fix' Method
        %
        % Converts 0s and NaNs in <ROIs> to valid data points by either
        % copying or averaging adjacent data points
        %
        function [roiWasFixed, fixedData] = fix(ROIs)
            pointCount = size(ROIs,1);
            badValues = (ROIs == 0 | isnan(ROIs));
            if any(badValues, 'all')
                badIndices = find(badValues);
                for j = 1:numel(badIndices)
                    % Get indices of the current and adjacent rows
                    [badRow, badColumn] = ind2sub(size(ROIs), badIndices(j));
                    if badRow == 1
                       prevIdx = -1;
                       nextIdx = sub2ind(size(ROIs), badRow+1, badColumn);
                    elseif badRow == pointCount
                       prevIdx = sub2ind(size(ROIs), badRow-1, badColumn);
                       nextIdx = -1;
                    else
                       prevIdx = sub2ind(size(ROIs), badRow-1, badColumn);
                       nextIdx = sub2ind(size(ROIs), badRow+1, badColumn);
                    end

                    % Only fix if the adjacent row is good
                    prevRowIsGood = ~ismember(prevIdx, badIndices);
                    nextRowIsGood = ~ismember(nextIdx, badIndices);
                    if badRow == 1 && nextRowIsGood
                       ROIs(badRow, badColumn) = ROIs(nextIdx);
                    elseif badRow == pointCount && prevRowIsGood
                       ROIs(badRow, badColumn) = ROIs(prevIdx);
                    elseif prevRowIsGood && nextRowIsGood
                       ROIs(badRow, badColumn) = (ROIs(prevIdx) + ROIs(nextIdx)) / 2;
                    end
                end
            end
            fixedData = ROIs;


            roiCount = size(ROIs, 2);
            roiWasFixed = true(1, roiCount);
            for i = 1:roiCount
                roi = fixedData(:, i);

                badValues = (roi == 0 | isnan(roi));
                if any(badValues, 'all')
                    roiWasFixed(i) = false;
                end
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'fix_time' Method
        %
        % Replaces 0s and NaNs in <time> with values that follow the same
        % rate of change as the other values. Assumes that <time> is linear
        %
        function [timeWasFixed, fixedTime] = fix_time(time)
            timeWasFixed = true;

            % Find issues in time data: zero or NaNs
            badTimeValues = (time == 0 | isnan(time));
            if any(badTimeValues, 'all')
                % Check if issues can be fixed
                goodIndices = find(~badTimeValues);
                if length(goodIndices) < 2
                    timeWasFixed = false;
                else
                    % time = (t(i') - t(i)) * (idx - i) + t(i)
                    startTime = time(goodIndices(1));
                    timeDiff = (time(goodIndices(2)) - time(goodIndices(1))) / (goodIndices(2) - goodIndices(1));

                    badIndices = find(badTimeValues);
                    newTime = timeDiff * (badIndices - goodIndices(1)) + startTime;
                    time(badIndices) = newTime;
                end
            end

            fixedTime = time;
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'has_number_of_baseline_pts' Method
        %
        % True if <solutionInfo> has at least 2 unique values in
        % the second column. False otherwise
        %
        function [tf] = has_number_of_baseline_pts(solutionInfo)
            if size(solutionInfo, 2) > 1
                uniqueTimings = unique([solutionInfo{:, 2}]);
                tf = numel(uniqueTimings) > 1;
            else
                tf = false;
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'number_of_baseline_pts' Method
        %
        % Returns the second unique value in the second column of
        % <solutionInfo>
        %
        function [count] = number_of_baseline_pts(solutionInfo)
            uniqueTimings = unique([solutionInfo{:, 2}]);
            count = uniqueTimings(2);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'combine_dna_types' Method
        %
        % Combines the strings in <allDNA> into a single string that is
        % semi-colon (;) delimted
        %
        function [dnaType] = combine_dna_types(allDNA)
            dnaType = '';
            for i = 1:numel(allDNA)
                dnaType = [dnaType, allDNA{i}];
                if i < numel(allDNA)
                    dnaType = [dnaType, '; '];
                end
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'split_dna_type' Method
        %
        % Converts <dnaType> into a list of strings by splitting at
        % semi-colons (;)
        %
        function [allDNA] = split_dna_type(dnaType)
            allDNA = strsplit(dnaType, ';');
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'combine_solution_info' Method
        %
        % Combines tables in <allSolutions> into a single, 2-column table
        % with names (strings) in the first column and timings (integers)
        % in the second column. The resulting table is sorted by the second
        % column (ascending)
        %
        function [solutionInfo] = combine_solution_info(allSolutions)            
            % Combine into a single table
            solutions = {};
            indexList = [];
            for i = 1:numel(allSolutions)
                solutions = [solutions; allSolutions{i}];
                solCount = size(allSolutions{i}, 1);
                indexList = [indexList, ones(1, solCount) * i];
            end
            
            if isempty(solutions)
                solutionInfo = {};
                return;
            end

            % Get the unique timings
            allTimings = [solutions{:, 2}];
            allNames = solutions(:, 1);
            uniqueTimings = unique(allTimings);

            % Add each time entry to the final table
            solutionInfo = {};
            for i = 1:numel(uniqueTimings)
                timing = uniqueTimings(i);
                nameIndices = (allTimings == timing);
                names = allNames(nameIndices);

                % Combine names using the current timing with the ';' delimeter
                nameIndices = find(nameIndices);
                combinedName = '';
                prevTableIdx = 1;
                for j = 1:numel(names)
                    nameIdx = nameIndices(j);
                    tableIdx = indexList(nameIdx);

                    delimCount = tableIdx - prevTableIdx;
                    delims = char(ones(1, delimCount) * double(';'));
                    combinedName = [combinedName, delims, names{j}];
                    prevTableIdx = tableIdx;
                end

                solutionInfo = [solutionInfo; {combinedName, timing}];
            end

            % Sort the final table
            solutionInfo = sortrows(solutionInfo, 2);
        end
        
        
        %% --------------------------------------------------------------------------------------------------------
        % 'split_solution_info' Method
        %
        % Converts <solutionInfo> into a list of tables by splitting names (strings)
        % in the first column at semi-colons (;). Each table in the
        % resulting list is sorted by the second column (ascending)
        %
        function [allSolutions] = split_solution_info(solutionInfo)
            solNames = solutionInfo(:, 1);
    
            % Count how many tables will be made
            timingCounter = @(c) numel(strfind(c, ';'))+1;
            timingCounts = cellfun(timingCounter, solNames);
            splitCount = max(timingCounts);

            % Split each entry into corresponding tables
            allSolutions = cell(1, splitCount);
            for i = 1:numel(solNames)
                names = solNames{i};
                timing = solutionInfo{i, 2};

                % Split entry by using name and ';' as a delimeter
                splitNames = strsplit(names, ';');
                for j = 1:numel(splitNames)
                    solName = splitNames{j};
                    if ~isempty(solName)
                        allSolutions{j} = [allSolutions{j}; {solName, timing}];
                    end
                end

            end

            % Sort tables
            for i = 1:numel(allSolutions)
                if ~isempty(allSolutions{i})
                    allSolutions{i} = sortrows(allSolutions{i}, 2);
                end
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'values_legend' Method
        %
        % Returns entries for a legend for a plot of <roiCount> ROI data
        %
        function [entries] = values_legend(roiCount)
            entries = cell(roiCount, 1);
            for i = 1:roiCount
                entries{i} = ['ROI #', num2str(i)];
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'averages_legend' Method
        %
        % Returns entries for a legend for a plot of multiple ROI averages,
        % with varying <dnaTypes> and <roiCounts>
        %
        function [entries] = averages_legend(dnaTypes, roiCounts)
            entries = cell(numel(dnaTypes), 1);
            for i = 1:numel(entries)
                if isempty(dnaTypes{i})
                    entries{i} = ['n=', num2str(roiCounts(i))];
                else
                    entries{i} = [dnaTypes{i}, ', n=', num2str(roiCounts(i))];
                end

            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'plot_annotations' Method
        %
        % Plots <allSolutions> as bars and text on <axis> that has <time> as x-data
        %
        function plot_annotations(axis, time, allSolutions)
            % Define plotting options
            lineStyles = {'-', ':'};
            lineOpts = {'linewidth', 4};
            txtBoxOpts = {'LineStyle', 'none'};

            % Get axis positioning
            xLimits = get(axis, 'xlim');
            axisPos = get(axis, 'position');
            xOffset = axisPos(1);
            yOffset = 0.9;
            txtBoxHeight = 0.07;

            % Plot each solution series, stacking vertically
            for i = 1:numel(allSolutions)
                solutions = allSolutions{i};
                solTimings = [solutions{:, 2}];
                solNames = solutions(:, 1);

                % Plot each timing once
                uniqueTimings = unique(solTimings);
                for j = 1:numel(uniqueTimings)
                    timing = uniqueTimings(j);
                    names = solNames(solTimings == timing);

                    % x = ((t(i) - xMin) / (xMax - xMin)) * axisW + axisX
                    if j < numel(uniqueTimings)
                        xPos = ((time(timing) - xLimits(1)) /  diff(xLimits)) * axisPos(3) + axisPos(1);
                    else
                        xPos = axisPos(1) + axisPos(3);
                    end

                    % Plot line
                    lineWidth = [xOffset, xPos];
                    lineHeight = [yOffset yOffset];
                    styleIdx = mod(j, 2) + 1;
                    annotation('line', lineWidth, lineHeight, 'linestyle', lineStyles{styleIdx}, lineOpts{:});    

                    % Combine solution names into a single string
                    nameStr = names{1};
                    for s = 2:numel(names)
                        nameStr = [nameStr, ' ', names{s}];
                    end

                    % Plot solution name
                    txtBoxPos = [xOffset, yOffset - 0.07, diff(lineWidth), txtBoxHeight];
                    annotation('textbox', txtBoxPos, 'String', nameStr, txtBoxOpts{:});

                    % Move x-offset to end of plotted annotation
                    xOffset = xPos;
                end

                % Reset x-offset
                xOffset = axisPos(1);

                % Move offset down for next series
                yOffset = yOffset - txtBoxHeight;
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'plot_averages' Method
        %
        % Plots error bars centered at <averages> with error of <errors>
        % over the course of <time>
        %
        function plot_averages(time, averages, errors)
            markers = {'o-', '+-', 'x-', 's-', 'd-'};
            plotOpts = {'MarkerFaceColor', 'k', 'color', 'k'};

            roiCount = size(averages, 2);
            for i = 1:roiCount
                % Select next marker type
                if i == numel(markers)
                    markerIdx = numel(markers);
                else
                    markerIdx = mod(i, numel(markers));
                end

                % Plot averages
                errorbar(time, averages(:, i), errors(:, i), markers{markerIdx}, plotOpts{:});
                hold('on');
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'plot_values' Method
        %
        % Plots <ROIs> over the course of <time> as a line plot
        %
        function plot_values(time, ROIs)
            plotOpts = {'o-'};
            plot(time, ROIs, plotOpts{:});
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'set_x_limits' Method
        %
        % Sets the current axis' x-axis limits based on the start and end of <time>
        %
        function set_x_limits(time)
            if time(1) < time(end)
                xlim([time(1), time(end)]);
            else
                xlim([min(time), max(time)]);
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'precision_format' Method
        %
        % Formats <value> by rounding it to 3 significant digits
        %
        function [newValue] = precision_format(value)
            newValue = round(value, 3, 'significant');
        end
    
    end
end