classdef FLIMageFile < ROIFile
    properties
        filepaths cell
        filedata cell
    end
    
    methods
        %% --------------------------------------------------------------------------------------------------------
        % 'FLIMageFile' Constructor
        %
        function [this] = FLIMageFile(filepaths)
            if nargin == 0
                this.filepaths = {};
                this.filedata = {};
            else
                this.filepaths = filepaths;
                this.filedata = {};
                
                for i = 1:numel(filepaths)
                    csvMat = csvread(filepaths{i}, 1, 1);
                    this.filedata{end+1} = csvMat;
                end
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'type' Accessor
        %
        function [fileType] = type(~)
            fileType = ROIFileType.FLImage;
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'source_files' Accessor
        %
        function [filepaths] = source_files(obj)
            filepaths = obj.filepaths;
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'experiment_names' Accessor
        %
        function [names] = experiment_names(obj)
            names = cell(numel(obj.filepaths), 1);
            for i = 1:numel(names)
                [~, names{i}, ~] = fileparts(obj.filepaths{i});
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'file_count' Accessor
        %
        function [count] = file_count(obj)
            count = numel(obj.filedata);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'file_roi_counts' Accessor
        %
        function [counts] = file_roi_counts(obj)
            counts = zeros(1, obj.file_count());
            
            for i = 1:numel(counts)
                csv = obj.filedata{i};
                counts(i) = csv(1, 1);
            end
        end

        %% --------------------------------------------------------------------------------------------------------
        % 'roi_count' Accessor
        %
        function [count] = roi_count(obj)
            count = sum(obj.file_roi_counts());
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'source_files' Accessor
        %
        function [counts] = point_counts(obj)
            counts = zeros(1, obj.file_count());
            for i = 1:numel(counts)
                csv = obj.filedata{i};
                counts(i) = numel(csv(2, :));
            end
        end

        %% --------------------------------------------------------------------------------------------------------
        % 'time' Accessor
        %
        function [values] = time(obj)
            [~, targetFile] = max(obj.point_counts());
            
            % FLimage Time --> Raw ROI Time
            % Tf / (1000 * 60) = Tr * 60 * 24
            % Tr = Tf / (1000 * 60 * 60 * 24)
            
            for i = 1:numel(obj.filedata)
                if i == targetFile
                    csv = obj.filedata{i};
                    values = csv(2, :)';
                    values = values / (1000 * 60 * 60 * 24);
                    return;
                end
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'adjusted_time' Accessor
        %
        function [adjVals] = adjusted_time(obj, nBaselinePts)
            adjVals = obj.time() / (1000 * 60);
            adjVals = adjVals - adjVals(nBaselinePts);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'has_exp_info' Accessor
        %
        function [tf] = has_exp_info(~)
            tf = false;
        end

        %% --------------------------------------------------------------------------------------------------------
        % 'roi_labels' Accessor
        %
        function [labels] = roi_labels(obj)
            roiCount = obj.roi_count();
            labels = cell(roiCount * 3 + 1);
            
            % N=3
            % 1 -> 1 | 4 | 7 
            % 2 -> 2 | 5 | 8 
            % 3 -> 3 | 6 | 9
            % ...
            % R -> R | R+N | R+2N
            for i = 1:roiCount
                labels{i+1}             = ['Tau #', num2str(i)];
                labels{i+roiCount+1}    = ['Int #', num2str(i)];
                labels{i+2*roiCount+1}  = ['Red #', num2str(i)];
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'dna_types' Accessor
        %
        function [dnaTypes] = dna_types(~)
            dnaTypes = {};
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'solution_info' Accessor
        %
        function [solutions] = solution_info(~)
            solutions = {};
        end
        
        function [tf] = has_preferences(~)
        %% --------------------------------------------------------------------------------------------------------
        % 'has_preferences' Accessor
        %
        % Checks if the file stored data regarding user preferences
        %
        % (OUT) "tf": Always false
        %
            tf = false;
        end
        
        function [defaults] = plotting_defaults(~)
        %% --------------------------------------------------------------------------------------------------------
        % 'plotting_defaults' Accessor
        %
        % Returns which plots will be active by default
        %
        % (OUT) "defaults": an empty struct array
        %
            defaults = [];
        end
        
        function [profile] = figure_defaults_profile(~)
        %% --------------------------------------------------------------------------------------------------------
        % 'figure_defaults_profile' Accessor
        %
        % Returns the name of the preferred profile for figure defaults
        %
        % (OUT) "profile": an empty string
        %
            profile = '';
        end
        
        function [positions] = annotation_positions(~)
        %% --------------------------------------------------------------------------------------------------------
        % 'annotation_positions' Accessor
        %
        % Returns the saved annotation positions
        %
        % (OUT) "positions": an empty cell array
        %
            positions = {};
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'lifetime' Accessor
        %
        function [values] = lifetime(obj)
            roiCounts = obj.file_roi_counts();
            totalROICount = obj.roi_count();
            pointCounts = obj.point_counts();
            maxPointCount = max(pointCounts);
            
            values = NaN(maxPointCount, totalROICount);
            roiIdx = 1;
            for i = 1:numel(obj.filedata)
                csv = obj.filedata{i};
                nPoints = pointCounts(i);
                nROI = roiCounts(i);
                % LT = [3*roiCount + 5]...[4*roiCount + 4]
                values(1:nPoints, roiIdx:roiIdx+nROI-1) = csv(3*nROI + 5 : 4*nROI + 4, :)';
                roiIdx = roiIdx + nROI;
            end
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
            roiCounts = obj.file_roi_counts();
            totalROICount = obj.roi_count();
            pointCounts = obj.point_counts();
            maxPointCount = max(pointCounts);
            
            values = NaN(maxPointCount, totalROICount);
            roiIdx = 1;
            for i = 1:numel(obj.filedata)
                csv = obj.filedata{i};
                nPoints = pointCounts(i);
                nROI = roiCounts(i);
                % Green = [5]...[roiCount + 4]
                values(1:nPoints, roiIdx:roiIdx+nROI-1) = csv(5 : nROI + 4, :)';
                roiIdx = roiIdx + nROI;
            end
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
            roiCount = obj.roi_count();
            maxPointCount = max(obj.point_counts());
            
            values = NaN(maxPointCount, roiCount);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_red' Accessor
        %
        function [normVals] = normalized_red(obj, ~)
            normVals = obj.red();
        end
    end
    
    methods (Static)
        %% --------------------------------------------------------------------------------------------------------
        % 'follows_format' Method
        %
        function [tf] = follows_format(filepaths)
            tf = false(1, numel(filepaths));
            
            for i = 1:numel(filepaths)
                try
                    csvMat = csvread(filepaths{i}, 1, 1);
                    if size(csvMat, 1) > 4 && size(csvMat, 2) > 1
                        roiCount = csvMat(1, 1);
                        nReqFields = 5*roiCount + 4;
                        if size(csvMat, 1) >= nReqFields
                            tf(i) = true;
                        end
                    end
                catch
                    tf(i) = false;
                end
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'save' Method
        %
        function save(~, ~, ~, ~)
            % TODO
        end
    end
end