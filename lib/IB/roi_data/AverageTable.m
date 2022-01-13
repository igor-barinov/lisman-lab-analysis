classdef AverageTable < ROIData
    properties
        roiData double
        normROIData double
        isIntegral logical
    end
    
    methods
        
        function [this] = AverageTable(adjTime, lifetime, normLifetime, green, normGreen, red, normRed, isIntegral)
        %% --------------------------------------------------------------------------------------------------------
        % 'AverageTable' Constructor
        %
            if nargin == 0
                this.roiData = [];
                this.normROIData = [];
                this.isIntegral = [];
            else
                this.roiData = [adjTime, lifetime, green, red];
                this.normROIData = [adjTime, normLifetime, normGreen, normRed];
                this.isIntegral = isIntegral;
            end
        end
        
        
        function [count] = roi_count(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'roi_count' Accessor
        %
            count = (size(obj.roiData, 2) - 1) / 6;
        end
        
        
        function [counts] = point_counts(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'point_counts' Accessor
        %
            counts = zeros(1, obj.roi_count());
            for i = 1:numel(counts)
                roi = obj.roiData(:, 2*i : 2*i + 1);
                counts(i) = numel(find(~isnan(roi)));
            end
        end
        
        
        function [labels] = roi_labels(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'roi_labels' Accessor
        %
            roiCount = obj.roi_count();
            labels = cell(roiCount * 2 * 3 + 1, 1);
            labels{1} = 'Time';
            for i = 1:roiCount
                labels{2*i}                 = ['Tau Avg #', num2str(i)];
                labels{2*i+1}               = ['Tau Ste #', num2str(i)];
                labels{2*(i+roiCount)}      = ['Int Avg #', num2str(i)];
                labels{2*(i+roiCount)+1}    = ['Int Ste #', num2str(i)];
                labels{2*(i+2*roiCount)}    = ['Red Avg #', num2str(i)];
                labels{2*(i+2*roiCount)+1}  = ['Red Ste #', num2str(i)];
            end
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
            adjVals = obj.time();
            adjVals = adjVals - adjVals(nBaselinePts);
        end

        
        function [values] = lifetime(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'lifetime' Accessor
        %
            values = obj.roiData(:, 2 : 2*obj.roi_count() + 1);
        end
        
        
        function [normVals] = normalized_lifetime(obj, ~)
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_lifetime' Accessor
        %
            normVals = obj.normROIData(:, 2 : 2*obj.roi_count() + 1);
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
            allROIs = obj.roiData;
            allROIs(:, obj.isIntegral) = NaN;
            values = allROIs(:, 2*obj.roi_count() + 2 : 2*2*obj.roi_count() + 1);
        end
        
        function [values] = green_integral(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'green_integral' Accessor
        %
            allROIs = obj.roiData;
            allROIs(:, ~obj.isIntegral) = NaN;
            values = allROIs(:, 2*obj.roi_count() + 2 : 2*2*obj.roi_count() + 1);
        end
        
        
        function [normVals] = normalized_green(obj, ~)
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_green' Accessor
        %
            allROIs = obj.normROIData;
            allROIs(:, obj.isIntegral) = NaN;
            normVals = allROIs(:, 2*obj.roi_count() + 2 : 2*2*obj.roi_count() + 1);
        end
        
        function [normVals] = norm_green_integral(obj, ~)
        %% --------------------------------------------------------------------------------------------------------
        % 'norm_green_integral' Accessor
        %
            allROIs = obj.normROIData;
            allROIs(:, ~obj.isIntegral) = NaN;
            normVals = allROIs(:, 2*obj.roi_count() + 2 : 2*2*obj.roi_count() + 1);
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
            allROIs = obj.roiData;
            allROIs(:, obj.isIntegral) = NaN;
            values = allROIs(:, 2*2*obj.roi_count() + 2 : 3*2*obj.roi_count() + 1);
        end
        
        function [values] = red_integral(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'red_integral' Accessor
        %
            allROIs = obj.roiData;
            allROIs(:, ~obj.isIntegral) = NaN;
            values = allROIs(:, 2*2*obj.roi_count() + 2 : 3*2*obj.roi_count() + 1);
        end
        
        
        function [normVals] = normalized_red(obj, ~)
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_red' Accessor
        %
            allROIs = obj.normROIData;
            allROIs(:, obj.isIntegral) = NaN;
            normVals = allROIs(:, 2*2*obj.roi_count() + 2 : 3*2*obj.roi_count() + 1);
        end
        
        function [normVals] = norm_red_integral(obj, ~)
        %% --------------------------------------------------------------------------------------------------------
        % 'norm_red_integral' Accessor
        %
            allROIs = obj.normROIData;
            allROIs(:, ~obj.isIntegral) = NaN;
            normVals = allROIs(:, 2*2*obj.roi_count() + 2 : 3*2*obj.roi_count() + 1);
        end
        
        
        function [selectedROIs] = select_rois(obj, selection)
        %% --------------------------------------------------------------------------------------------------------
        % 'select_rois' Accessor
        %
            uniqueCols = unique(selection(:, 2));
            
            roiCount = obj.roi_count();
            lifetimeCols = 2 : 2*roiCount + 1;
            greenCols = 2*roiCount + 2 : 2*2*roiCount + 1;
            redCols = 2*2*roiCount + 2 : 3*2*roiCount + 1;
            
            isLifetime = ismember(lifetimeCols, uniqueCols);
            isGreen = ismember(greenCols, uniqueCols);
            isRed = ismember(redCols, uniqueCols);
            
            selectedROIs = isLifetime | isGreen | isRed;
        end
        
        
    end
end