classdef PreparedFile < ROIFile
    properties
        filepaths cell
        filedata struct
    end
    
    methods
        %% --------------------------------------------------------------------------------------------------------
        % 'PreparedFile' Constructor
        %
        function [this] = PreparedFile(filepaths)
            if nargin == 0
                this.filepaths = {};
                this.filedata = [];
            else
                this.filepaths = filepaths;
                this.filedata = [];
                for i = 1:numel(filepaths)
                    fileStruct = load(filepaths{i});
                    prepData = fileStruct.('prepData');
                    dataStruct = struct;
                    dataStruct.('alladj') = prepData.('alladj');
                    dataStruct.('numROI') = prepData.('numROI');
                    dataStruct.('dnaType') = prepData.('dnaType');
                    dataStruct.('solutions') = prepData.('solutions');
                    this.filedata = [this.filedata, dataStruct];
                end
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'type' Accessor
        %
        function [fileType] = type(~)
            fileType = ROIFileType.Prepared;
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
            counts = zeros(1, numel(obj.filedata));
            for i = 1:numel(obj.filedata)
                counts(i) = obj.filedata(i).('numROI');
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'roi_count' Accessor
        %
        function [count] = roi_count(obj)
            count = sum(obj.file_roi_counts());
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'point_counts' Accessor
        %
        function [counts] = point_counts(obj)
            counts = zeros(1, numel(obj.filedata));
            for i = 1:numel(obj.filedata)
                ROIs = obj.filedata(i).('alladj');
                counts(i) = size(ROIs, 1);
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'time' Accessor
        %
        function [values] = time(obj)
            pointCounts = obj.point_counts();
            [~, targetFile] = max(pointCounts);
            ROIs = obj.filedata(targetFile).('alladj');
            values = ROIs(:, 1);
            values = values / 60 / 24;
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'adjusted_time' Accessor
        %
        function [adjVals] = adjusted_time(obj, nBaselinePts)
            time = obj.time() * 60 * 24;
            adjVals = time - time(nBaselinePts);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'has_exp_info' Accessor
        %
        function [tf] = has_exp_info(~)
            tf = true;
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
        % 'dna_types' Accessor
        %
        function [dnaTypes] = dna_types(obj)
            dnaTypes = cell(1, numel(obj.filedata));
            for i = 1:numel(dnaTypes)
                dnaTypes{i} = obj.filedata(i).('dnaType');
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'solution_info' Accessor
        %
        function [solutions] = solution_info(obj)
            solutions = cell(1, numel(obj.filedata));
            for i = 1:numel(solutions)
                solutions{i} = obj.filedata(i).('solutions');
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'lifetime' Accessor
        %
        function [values] = lifetime(obj)
            roiCounts = obj.file_roi_counts();
            pointCounts = obj.point_counts();
            maxPointCount = max(pointCounts);
            totalROICount = obj.roi_count();
            
            values = NaN(maxPointCount, totalROICount);
            roiIdx = 1;
            for i = 1:numel(obj.filedata)
                ROIs = obj.filedata(i).('alladj');
                roiCount = roiCounts(i);
                nPoints = pointCounts(i);
                tauVals = ROIs(:, 2:roiCount+1);
                values(1:nPoints, roiIdx:roiIdx+roiCount-1) = tauVals;
                roiIdx = roiIdx + roiCount;
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
            pointCounts = obj.point_counts();
            maxPointCount = max(pointCounts);
            totalROICount = obj.roi_count();
            
            values = NaN(maxPointCount, totalROICount);
            roiIdx = 1;
            for i = 1:numel(obj.filedata)
                ROIs = obj.filedata(i).('alladj');
                roiCount = roiCounts(i);
                nPoints = pointCounts(i);
                intVals = ROIs(:, 2+roiCount:2*roiCount+1);
                values(1:nPoints, roiIdx:roiIdx+roiCount-1) = intVals;
                roiIdx = roiIdx + roiCount;
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
            roiCounts = obj.file_roi_counts();
            pointCounts = obj.point_counts();
            maxPointCount = max(pointCounts);
            totalROICount = obj.roi_count();
            
            values = NaN(maxPointCount, totalROICount);
            roiIdx = 1;
            for i = 1:numel(obj.filedata)
                ROIs = obj.filedata(i).('alladj');
                roiCount = roiCounts(i);
                nPoints = pointCounts(i);
                redVals = ROIs(:, 2+2*roiCount:3*roiCount+1);
                values(1:nPoints, roiIdx:roiIdx+roiCount-1) = redVals;
                roiIdx = roiIdx + roiCount;
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_red' Accessor
        %
        function [normVals] = normalized_red(obj, nBaselinePts)
            normVals = ROIUtils.normalize(obj.red(), nBaselinePts);
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
                    fileStruct = load(filepaths{i});
                    if isfield(fileStruct, 'prepData')
                        prepData = fileStruct.('prepData');
                        reqFields = {'alladj', 'numROI', 'dnaType', 'solutions'};
                        if all(isfield(prepData, reqFields))
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
        function save(filepath, roiData, dnaType, solutionInfo)
            adjTime = roiData.adjusted_time(ROIUtils.number_of_baseline_pts(solutionInfo));
            lifetime = roiData.lifetime();
            green = roiData.green();
            red = roiData.red();
            
            prepData = struct;
            prepData.('alladj') = [adjTime, lifetime, green, red];
            prepData.('numROI') = roiData.roi_count();
            prepData.('dnaType') = dnaType;
            prepData.('solutions') = solutionInfo;
            
            save(filepath, 'prepData');
        end
    end
end