classdef ROITable < ROIData
    properties
        roiData double
    end
    
    methods
        %% --------------------------------------------------------------------------------------------------------
        % 'ROITable' Constructor
        %
        function [this] = ROITable(time, lifetime, green, red)
            if nargin == 0
                this.roiData = [];
            else
                this.roiData = [time, lifetime, green, red];
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'roi_count' Accessor
        %
        function [count] = roi_count(obj)
            count = (size(obj.roiData,2) - 1) / 3;
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'point_counts' Accessor
        %
        function [counts] = point_counts(obj)
            counts = zeros(1, obj.roi_count());
            for i = 1:numel(counts)
                ROI = obj.roiData(:, i);
                counts(i) = numel(find(~isnan(ROI)));
            end
        end

        %% --------------------------------------------------------------------------------------------------------
        % 'roi_labels' Accessor
        %
        function [labels] = roi_labels(obj)
            roiCount = obj.roi_count();
            labels = cell(roiCount * 3 + 1, 1);
            labels{1} = 'Time';
            for i = 1:roiCount
                labels{i+1}             = ['Tau #', num2str(i)];
                labels{i+roiCount+1}    = ['Int #', num2str(i)];
                labels{i+2*roiCount+1}  = ['Red #', num2str(i)];
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'time' Accessor
        %
        function [values] = time(obj)
            values = obj.roiData(:, 1);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'adjusted_time' Accessor
        %
        function [adjVals] = adjusted_time(obj, nBaselinePts)
            adjVals = obj.time() * 60 * 24;
            adjVals = adjVals - adjVals(nBaselinePts);
        end

        %% --------------------------------------------------------------------------------------------------------
        % 'lifetime' Accessor
        %
        function [values] = lifetime(obj)
            values = obj.roiData(:, 2 : obj.roi_count() + 1);
        end
        
        
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_lifetime' Accessor
        %
        function [normVals] = normalized_lifetime(obj, nBaselinePts)
            normVals = ROIUtils.normalize(obj.lifetime(), nBaselinePts);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'green' Accessor
        %
        function [values] = green(obj)
            values = obj.roiData(:, obj.roi_count() + 2 : 2*obj.roi_count() + 1);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_green' Accessor
        %
        function [normVals] = normalized_green(obj, nBaselinePts)
            normVals = ROIUtils.normalize(obj.green(), nBaselinePts);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'red' Accessor
        %
        function [values] = red(obj)
            values = obj.roiData(:, 2*obj.roi_count() + 2 : 3*obj.roi_count() + 1);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_red' Accessor
        %
        function [normVals] = normalized_red(obj, nBaselinePts)
            normVals = ROIUtils.normalize(obj.red(), nBaselinePts);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'select_rois' Accessor
        %
        function [selectedROIs] = select_rois(obj, selection)
            uniqueCols = unique(selection(:, 2));
            
            roiCount = obj.roi_count();
            lifetimeCols = 2 : roiCount + 1;
            greenCols = roiCount + 2 : 2*roiCount + 1;
            redCols = 2*roiCount + 2 : 3*roiCount + 1;
            
            isLifetime = ismember(lifetimeCols, uniqueCols);
            isGreen = ismember(greenCols, uniqueCols);
            isRed = ismember(redCols, uniqueCols);
            
            selectedROIs = isLifetime | isGreen | isRed;
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'select_lifetime' Accessor
        %
        function [values, selectedROIs] = select_lifetime(obj, selection)
            uniqueRows = unique(selection(:, 1));
            uniqueCols = unique(selection(:, 2));
            
            lifetimeCols = 2 : obj.roi_count() + 1;
            selectedROIs = ismember(lifetimeCols, uniqueCols);
            
            values = obj.lifetime();
            values = values(uniqueRows, selectedROIs);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'select_green' Accessor
        %
        function [values, selectedROIs] = select_green(obj, selection)
            uniqueRows = unique(selection(:, 1));
            uniqueCols = unique(selection(:, 2));
            
            greenCols = obj.roi_count() + 2 : 2*obj.roi_count() + 1;
            selectedROIs = ismember(greenCols, uniqueCols);
            
            values = obj.green();
            values = values(uniqueRows, selectedROIs);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'select_red' Accessor
        %
        function [values, selectedROIs] = select_red(obj, selection)
            uniqueRows = unique(selection(:, 1));
            uniqueCols = unique(selection(:, 2));
            
            redCols = 2*obj.roi_count() + 2 : 3*obj.roi_count() + 1;
            selectedROIs = ismember(redCols, uniqueCols);
            
            values = obj.red();
            values = values(uniqueRows, selectedROIs);
        end
        
        
        
        %% --------------------------------------------------------------------------------------------------------
        % 'set_time' Modifier
        %
        function [newObj] = set_time(obj, newTime)
            newObj = obj;
            oldPointCount = max(obj.point_counts());
            newPointCount = numel(newTime);
            ptsToCopy = min(newPointCount, oldPointCount);
            newROIs = NaN(newPointCount, size(newObj.roiData,2));
            newROIs(:, 1) = newTime;
            newROIs(1:ptsToCopy, 2:end) = newObj.roiData(1:ptsToCopy, 2:end);
            newObj.roiData = newROIs;
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'set_lifetime' Modifier
        %
        function [newObj] = set_lifetime(obj, newLifetime)
            newObj = obj;
            newObj.roiData(:, 2 : obj.roi_count() + 1) = newLifetime;
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'set_green' Modifier
        %
        function [newObj] = set_green(obj, newGreen)
            newObj = obj;
            newObj.roiData(:, obj.roi_count() + 2 : 2*obj.roi_count() + 1) = newGreen;
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'set_red' Modifier
        %
        function [newObj] = set_red(obj, newRed)
            newObj = obj;
            newObj.roiData(:, 2*obj.roi_count() + 2 : 3*obj.roi_count() + 1) = newRed;
        end
    end
end