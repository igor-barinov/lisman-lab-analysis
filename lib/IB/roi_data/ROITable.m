classdef ROITable < ROIData
    properties
        roiData double
        seriesIsIntegral logical
    end
    
    methods
        function [this] = ROITable(time, lifetime, green, red, isIntegral)
        %% --------------------------------------------------------------------------------------------------------
        % 'ROITable' Constructor
        %
            if nargin == 0
                this.roiData = [];
                this.seriesIsIntegral = false;
            else
                this.roiData = [time, lifetime, green, red];
                this.seriesIsIntegral = isIntegral;
            end
        end
        
        
        function [count] = roi_count(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'roi_count' Accessor
        %
            count = (size(obj.roiData,2) - 1) / 3;
        end
        
        
        function [counts] = point_counts(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'point_counts' Accessor
        %
            counts = zeros(1, obj.roi_count());
            for i = 1:numel(counts)
                ROI = obj.roiData(:, i);
                counts(i) = numel(find(~isnan(ROI)));
            end
        end

        
        function [labels] = roi_labels(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'roi_labels' Accessor
        %
            roiCount = obj.roi_count();
            labels = cell(roiCount * 3 + 1, 1);
            labels{1} = 'Time';
            for i = 1:roiCount
                labels{i+1}             = ['Tau #', num2str(i)];
                labels{i+roiCount+1}    = ['Int #', num2str(i)];
                labels{i+2*roiCount+1}  = ['Red #', num2str(i)];
            end
        end
        
        
        function [tf] = is_integral(obj)
            tf = obj.seriesIsIntegral;
        end
        
        function [values] = time(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'time' Accessor
        %
            values = obj.roiData(:, 1);
        end
        
        
        function [adjVals] = adjusted_time(obj, nBaselinePts)
        %% --------------------------------------------------------------------------------------------------------
        % 'adjusted_time' Accessor
        %
            adjVals = obj.time() * 60 * 24;
            adjVals = adjVals - adjVals(nBaselinePts);
        end

        
        function [values] = lifetime(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'lifetime' Accessor
        %
            values = obj.roiData(:, 2 : obj.roi_count() + 1);
        end
        
        function [normVals] = normalized_lifetime(obj, nBaselinePts)
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_lifetime' Accessor
        %
            normVals = ROIUtils.normalize(obj.lifetime(), nBaselinePts);
        end
        
        function [tf] = green_is_integral(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'green_is_integral' Accessor
        %
            tf = all(isnan(obj.green()));
        end
        
        
        function [values] = green(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'green' Accessor
        %
            nonIntVals = obj.roiData;
            nonIntVals(:, obj.seriesIsIntegral) = NaN;            
            values = nonIntVals(:, obj.roi_count() + 2 : 2*obj.roi_count() + 1);
        end
        
        function [values] = green_integral(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'green_integral' Accessor
        %
            intVals = obj.roiData;
            intVals(:, ~obj.seriesIsIntegral) = NaN;            
            values = intVals(:, obj.roi_count() + 2 : 2*obj.roi_count() + 1);
        end
        
        
        function [normVals] = normalized_green(obj, nBaselinePts)
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_green' Accessor
        %
            normVals = ROIUtils.normalize(obj.green(), nBaselinePts);
        end
                
        
        function [normVals] = norm_green_integral(obj, nBaselinePts)
        %% --------------------------------------------------------------------------------------------------------
        % 'norm_green_integral' Accessor
        %
            normVals = ROIUtils.normalize(obj.green_integral(), nBaselinePts);
        end
        
        
        function [tf] = red_is_integral(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'red_is_integral' Accessor
        %
            tf = all(isnan(obj.red()));
        end
        
        function [values] = red(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'red' Accessor
        %
            nonIntVals = obj.roiData;
            nonIntVals(:, obj.seriesIsIntegral) = NaN;            
            values = nonIntVals(:, 2*obj.roi_count() + 2 : 3*obj.roi_count() + 1);
        end
        
        
        function [values] = red_integral(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'red_integral' Accessor
        %
            intVals = obj.roiData;
            intVals(:, ~obj.seriesIsIntegral) = NaN;            
            values = intVals(:, 2*obj.roi_count() + 2 : 3*obj.roi_count() + 1);
        end
        
        
        function [normVals] = normalized_red(obj, nBaselinePts)
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_red' Accessor
        %
            normVals = ROIUtils.normalize(obj.red(), nBaselinePts);
        end
        
        function [normVals] = norm_red_integral(obj, nBaselinePts)
       %% --------------------------------------------------------------------------------------------------------
        % 'norm_red_integral' Accessor
        %
            normVals = ROIUtils.normalize(obj.red_integral(), nBaselinePts);
        end
        
        
        
        function [selectedROIs] = select_rois(obj, selection)
        %% --------------------------------------------------------------------------------------------------------
        % 'select_rois' Accessor
        %
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
        
        
        function [values, selectedROIs] = select_lifetime(obj, selection)
        %% --------------------------------------------------------------------------------------------------------
        % 'select_lifetime' Accessor
        %
            uniqueRows = unique(selection(:, 1));
            uniqueCols = unique(selection(:, 2));
            
            lifetimeCols = 2 : obj.roi_count() + 1;
            selectedROIs = ismember(lifetimeCols, uniqueCols);
            
            values = obj.lifetime();
            values = values(uniqueRows, selectedROIs);
        end
        
        
        function [values, intValues, selectedROIs] = select_green(obj, selection)
        %% --------------------------------------------------------------------------------------------------------
        % 'select_green' Accessor
        %
            uniqueRows = unique(selection(:, 1));
            uniqueCols = unique(selection(:, 2));
            
            greenCols = obj.roi_count() + 2 : 2*obj.roi_count() + 1;
            selectedROIs = ismember(greenCols, uniqueCols);
            
            values = obj.green();
            intValues = obj.green_integral();
            values = values(uniqueRows, selectedROIs);
            intValues = intValues(uniqueRows, selectedROIs);
        end
        
        
        function [values, intValues, selectedROIs] = select_red(obj, selection)
        %% --------------------------------------------------------------------------------------------------------
        % 'select_red' Accessor
        %
            uniqueRows = unique(selection(:, 1));
            uniqueCols = unique(selection(:, 2));
            
            redCols = 2*obj.roi_count() + 2 : 3*obj.roi_count() + 1;
            selectedROIs = ismember(redCols, uniqueCols);
            
            values = obj.red();
            intValues = obj.red_integral();
            values = values(uniqueRows, selectedROIs);
            intValues = intValues(uniqueRows, selectedROIs);
        end
        
        
        
        
        function [newObj] = set_time(obj, newTime)
        %% --------------------------------------------------------------------------------------------------------
        % 'set_time' Modifier
        %
            newObj = obj;
            oldPointCount = max(obj.point_counts());
            newPointCount = numel(newTime);
            ptsToCopy = min(newPointCount, oldPointCount);
            newROIs = NaN(newPointCount, size(newObj.roiData,2));
            newROIs(:, 1) = newTime;
            newROIs(1:ptsToCopy, 2:end) = newObj.roiData(1:ptsToCopy, 2:end);
            newObj.roiData = newROIs;
        end
        
        
        function [newObj] = set_lifetime(obj, newLifetime)
        %% --------------------------------------------------------------------------------------------------------
        % 'set_lifetime' Modifier
        %
            newObj = obj;
            newObj.roiData(:, 2 : obj.roi_count() + 1) = newLifetime;
        end
        
        
        function [newObj] = set_green(obj, newGreen, isInt)
        %% --------------------------------------------------------------------------------------------------------
        % 'set_green' Modifier
        %
            newObj = obj;
            newObj.roiData(:, obj.roi_count() + 2 : 2*obj.roi_count() + 1) = newGreen;
            
            if nargin > 2
                newObj.seriesIsIntegral(obj.roi_count() + 2 : 2*obj.roi_count() + 1) = isInt;
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'set_red' Modifier
        %
        function [newObj] = set_red(obj, newRed, isInt)
            newObj = obj;
            newObj.roiData(:, 2*obj.roi_count() + 2 : 3*obj.roi_count() + 1) = newRed;
            
            if nargin > 2
                newObj.seriesIsIntegral(2*obj.roi_count() + 2 : 3*obj.roi_count() + 1) = isInt;
            end
        end
    end
end