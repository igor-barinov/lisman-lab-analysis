classdef AverageTable < ROIData
    properties
        roiData double
        normROIData double
    end
    
    methods
        %% --------------------------------------------------------------------------------------------------------
        % 'AverageTable' Constructor
        %
        function [this] = AverageTable(adjTime, lifetime, normLifetime, green, normGreen, red, normRed)
            if nargin == 0
                this.roiData = [];
                this.normROIData = [];
            else
                this.roiData = [adjTime, lifetime, green, red];
                this.normROIData = [adjTime, normLifetime, normGreen, normRed];
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'roi_count' Accessor
        %
        function [count] = roi_count(obj)
            count = (size(obj.roiData, 2) - 1) / 6;
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'point_counts' Accessor
        %
        function [counts] = point_counts(obj)
            counts = zeros(1, obj.roi_count());
            for i = 1:numel(counts)
                roi = obj.roiData(:, 2*i : 2*i + 1);
                counts(i) = numel(find(~isnan(roi)));
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'roi_labels' Accessor
        %
        function [labels] = roi_labels(obj)
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
            adjVals = obj.time();
            adjVals = adjVals - adjVals(nBaselinePts);
        end

        %% --------------------------------------------------------------------------------------------------------
        % 'lifetime' Accessor
        %
        function [values] = lifetime(obj)
            values = obj.roiData(:, 2 : 2*obj.roi_count() + 1);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_lifetime' Accessor
        %
        function [normVals] = normalized_lifetime(obj, ~)
            normVals = obj.normROIData(:, 2 : 2*obj.roi_count() + 1);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'green' Accessor
        %
        function [values] = green(obj)
            values = obj.roiData(:, 2*obj.roi_count() + 2 : 2*2*obj.roi_count() + 1);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_green' Accessor
        %
        function [normVals] = normalized_green(obj, ~)
            normVals = obj.normROIData(:, 2*obj.roi_count() + 2 : 2*2*obj.roi_count() + 1);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'red' Accessor
        %
        function [values] = red(obj)
            values = obj.roiData(:, 2*2*obj.roi_count() + 2 : 3*2*obj.roi_count() + 1);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_green' Accessor
        %
        function [normVals] = normalized_red(obj, ~)
            normVals = obj.normROIData(:, 2*2*obj.roi_count() + 2 : 3*2*obj.roi_count() + 1);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'select_rois' Accessor
        %
        function [selectedROIs] = select_rois(obj, selection)
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