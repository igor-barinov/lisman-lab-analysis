classdef RawFile < ROIFile
    properties
        filepaths cell
        filedata struct
    end
    
    methods
        %% --------------------------------------------------------------------------------------------------------
        % 'RawFile' Constructor
        %
        function [this] = RawFile(filepaths)
            if nargin == 0
                % Empty by default
                this.filepaths = {};
                this.filedata = [];
            else
                this.filepaths = filepaths;
                this.filedata = [];
                for i = 1:numel(filepaths)
                    fileStruct = load(filepaths{i});
                    fileFields = fieldnames(fileStruct);

                    for j = 1:numel(fileFields)
                        rawData = fileStruct.(fileFields{j});
                        if isfield(rawData, 'roiData')
                            dataStruct = struct;
                            dataStruct.('roiData') = rawData.('roiData');
                            this.filedata = [this.filedata, dataStruct];
                        end
                    end
                end
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'type' Accessor
        %
        function [fileType] = type(~)
            fileType = ROIFileType.Raw;
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
                counts(i) = numel(obj.filedata(i).('roiData'));
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
            counts = [];
            for i = 1:numel(obj.filedata)
                ROIs = obj.filedata(i).('roiData');
                for j = 1:numel(ROIs)
                    roiPointCounts = [numel(ROIs(j).('time')), ...
                                      numel(ROIs(j).('tau_m')), ...
                                      numel(ROIs(j).('mean_int')), ...
                                      numel(ROIs(j).('red_mean'))];
                    
                    counts = [counts, min(roiPointCounts)];
                end
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'time' Accessor
        %
        function [values] = time(obj)
            pointCounts = obj.point_counts();
            [maxPointCount, targetROI] = max(pointCounts);
            
            roiIdx = 1;
            for i = 1:numel(obj.filedata)
                ROIs = obj.filedata(i).('roiData');
                for j = 1:numel(ROIs)
                    if roiIdx == targetROI
                        values = ROIs(j).('time')';
                        values = values(1:maxPointCount);
                        return;
                    end
                    
                    roiIdx = roiIdx + 1;
                end
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'adjusted_time' Accessor
        %
        function [adjVals] = adjusted_time(obj, nBaselinePts)
            time = obj.time();
            adjVals = time * 60 * 24;
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
        function [dnaTypes] = dna_types(~)
            dnaTypes = {};
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'solution_info' Accessor
        %
        function [solutions] = solution_info(~)
            solutions = {};
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'lifetime' Accessor
        %
        function [values] = lifetime(obj)
            pointCounts = obj.point_counts();
            maxPointCount = max(pointCounts);
            roiCount = obj.roi_count();
            
            values = NaN(maxPointCount, roiCount);
            roiIdx = 1;
            for i = 1:numel(obj.filedata)
                ROIs = obj.filedata(i).('roiData');
                for j = 1:numel(ROIs)
                    nPoints = pointCounts(roiIdx);
                    roiValues = ROIs(j).('tau_m')';
                    values(1:nPoints, roiIdx) = roiValues(1:nPoints);
                    roiIdx = roiIdx + 1;
                end
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
            pointCounts = obj.point_counts();
            maxPointCount = max(pointCounts);
            roiCount = obj.roi_count();
            
            values = NaN(maxPointCount, roiCount);
            roiIdx = 1;
            for i = 1:numel(obj.filedata)
                ROIs = obj.filedata(i).('roiData');
                for j = 1:numel(ROIs)
                    nPoints = pointCounts(roiIdx);
                    roiValues = ROIs(j).('mean_int')';
                    values(1:nPoints, roiIdx) = roiValues(1:nPoints);
                    roiIdx = roiIdx + 1;
                end
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
            pointCounts = obj.point_counts();
            maxPointCount = max(pointCounts);
            roiCount = obj.roi_count();
            
            values = NaN(maxPointCount, roiCount);
            roiIdx = 1;
            for i = 1:numel(obj.filedata)
                ROIs = obj.filedata(i).('roiData');
                for j = 1:numel(ROIs)
                    nPoints = pointCounts(roiIdx);
                    roiValues = ROIs(j).('red_mean')';
                    values(1:nPoints, roiIdx) = roiValues(1:nPoints);
                    roiIdx = roiIdx + 1;
                end
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
                    fileFields = fieldnames(fileStruct);
                    for j = 1:numel(fileFields)
                        dataStruct = fileStruct.(fileFields{j});
                        if isfield(dataStruct, 'roiData')
                            ROIs = dataStruct.('roiData');
                            if all(isfield(ROIs, {'time', 'tau_m', 'mean_int', 'red_mean'}))
                                tf(i) = true;
                            end
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
        function save(filepath, roiData, ~, ~)
            roiCount = roiData.roi_count();
            time = roiData.time();
            lifetime = roiData.lifetime();
            green = roiData.green();
            red = roiData.red();
            
            rawData = struct;
            rawData.('roiData') = [];
            for i = 1:roiCount
                roi = struct;
                roi.('time') = time';
                roi.('tau_m') = lifetime(:, i)';
                roi.('mean_int') = green(:, i)';
                roi.('red_mean') = red(:, i)';
                
                rawData.('roiData') = [rawData.('roiData'), roi];
            end
            
            save(filepath, 'rawData');
        end
        
    end
end