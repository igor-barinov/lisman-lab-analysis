classdef AveragedFile < ROIFile
    properties
        filepaths cell
        filedata struct
    end
    
    methods
        
        function [this] = AveragedFile(filepaths)
        %% --------------------------------------------------------------------------------------------------------
        % 'AveragedFile' Constructor
        %
            if nargin == 0
                this.filepaths = {};
                this.filedata = [];
            else
                this.filepaths = filepaths;
                this.filedata = [];
                for i = 1:numel(filepaths)
                    fileStruct = load(filepaths{i});
                    dataStruct = struct;
                    
                    % Load mandatory fields
                    dataStruct.('filePath') = fileStruct.('filePath');
                    dataStruct.('numROI') = fileStruct.('numROI');
                    dataStruct.('time') = fileStruct.('time');
                    dataStruct.('dnaType') = fileStruct.('dnaType');
                    dataStruct.('solutions') = fileStruct.('solutions');
                    dataStruct.('averages') = fileStruct.('averages');
                    
                    % Load possible fields
                    if isfield(fileStruct, 'userPref') && isfield(this.filedata, 'userPref')
                        dataStruct.('userPref') = fileStruct.('userPref');
                    end
                    
                    this.filedata = [this.filedata, dataStruct];
                end
            end
        end
        
        
        function [fileType] = type(~)
        %% --------------------------------------------------------------------------------------------------------
        % 'type' Accessor
        %
            fileType = ROIFileType.Averaged;
        end
        
        
        function [filepaths] = source_files(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'source_files' Accessor
        %
            filepaths = {};
            for i = 1:numel(obj.filedata)
                filepaths = [filepaths, obj.filedata(i).('filePath')];
            end
        end
        
        
        function [names] = experiment_names(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'experiment_names' Accessor
        %
            srcFiles = obj.source_files();
            names = cell(numel(srcFiles), 1);
            for i = 1:numel(names)
                [~, names{i}, ~] = fileparts(srcFiles{i});
            end
        end
        
        
        function [count] = file_count(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'file_count' Accessor
        %
            count = numel(obj.filedata);
        end
        
        
        function [counts] = file_roi_counts(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'file_roi_counts' Accessor
        %
            counts = zeros(1, numel(obj.filedata));
            for i = 1:numel(counts)
                counts(i) = obj.filedata(i).('numROI');
            end
        end
        
        function [tf] = is_integral(~)
            tf = [];
        end
        
        
        function [count] = roi_count(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'roi_count' Accessor
        %
            count = numel(obj.filedata);
        end
        
        
        function [counts] = point_counts(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'point_counts' Accessor
        %
            counts = zeros(1, numel(obj.filedata));
            for i = 1:numel(counts)
                counts(i) = numel(obj.filedata(i).('time'));
            end
        end
        
        
        function [values] = time(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'time' Accessor
        %
            pointCounts = obj.point_counts();
            [~, targetFile] = max(pointCounts);
            values = obj.filedata(targetFile).('time');
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'adjusted_time' Accessor
        %
        function [adjVals] = adjusted_time(obj, nBaselinePts)
            time = obj.time();
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
            labels = cell(roiCount * 2 * 3 + 1, 1);
            labels{1} = 'Time';
            
            % N = 3
            % 1 -> 1 2 |  7  8 | 13 14
            % 2 -> 3 4 |  9 10 | 15 16
            % 3 -> 5 6 | 11 12 | 17 18
            % R -> 2R-1  2R | 2(R+N-1)+1  2(R+N)| 2(R+2N-1)+1 2(R+2N) 
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
        
        function [tf] = has_preferences(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'has_preferences' Accessor
        %
        % Checks if the file stored data regarding user preferences
        %
        % (OUT) "tf": True if any user preferences data is found, false otherwise
        %
            tf = isfield(obj.filedata, 'userPref');
        end
        
        function [defaults] = plotting_defaults(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'plotting_defaults' Accessor
        %
        % Returns which plots will be active by default
        %
        % (OUT) "defaults": a struct with describing which plots are active. 
        % Each field will be a logical value where '1' indicates the plot is active, and '0' otherwise
        %
            allPrefs = [obj.filedata.('userPref')];
            lifetimeDefaults = {allPrefs.('showLifetime')};
            greenIntDefaults = {allPrefs.('showGreenInt')};
            redIntDefaults = {allPrefs.('showRedInt')};
            annotationDefaults = {allPrefs.('showAnnots')};
            
            defaults = struct;
            defaults.('showLifetime') = lifetimeDefaults{1};
            defaults.('showGreenInt') = greenIntDefaults{1};
            defaults.('showRedInt') = redIntDefaults{1};
            defaults.('showAnnots') = annotationDefaults{1};
        end
        
        function [profile] = figure_defaults_profile(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'figure_defaults_profile' Accessor
        %
        % Returns the name of the preferred profile for figure defaults
        %
        % (OUT) "profile": String representing the name of a figure defaults profile
        %
            allPrefs = [obj.filedata.('userPref')];
            allProfiles = {allPrefs.('figProfile')};
            profile = allProfiles{1};
        end
        
        function [positions] = annotation_positions(~)
            positions = {};
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'lifetime' Accessor
        %
        function [values] = lifetime(obj)
            roiCount = obj.roi_count();
            pointCounts = obj.point_counts();
            maxPointCount = max(pointCounts);
            
            values = NaN(maxPointCount, roiCount * 2);
            for i = 1:roiCount
                nPoints = pointCounts(i);
                averages = obj.filedata(i).('averages').('tauAvg');
                errors = obj.filedata(i).('averages').('tauSte');
                values(1:nPoints, 2*i - 1) = averages(1:nPoints);
                values(1:nPoints, 2*i) = errors(1:nPoints);
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_lifetime' Accessor
        %
        function [normVals] = normalized_lifetime(obj, ~)
            pointCounts = obj.point_counts();
            maxPointCount = max(pointCounts);
            roiCount = obj.roi_count();
            
            normVals = NaN(maxPointCount, roiCount * 2);
            for i = 1:roiCount
                nPoints = pointCounts(i);
                averages = obj.filedata(i).('averages').('tauNormAvg');
                errors = obj.filedata(i).('averages').('tauNormSte');
                normVals(1:nPoints, 2*i - 1) = averages(1:nPoints);
                normVals(1:nPoints, 2*i) = errors(1:nPoints);
            end
        end
        
        function [tf] = green_is_integral(~)
            tf = [];
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'green' Accessor
        %
        function [values] = green(obj)
            pointCounts = obj.point_counts();
            maxPointCount = max(pointCounts);
            roiCount = obj.roi_count();
            
            values = NaN(maxPointCount, roiCount * 2);
            for i = 1:roiCount
                nPoints = pointCounts(i);
                averages = obj.filedata(i).('averages').('intAvg');
                errors = obj.filedata(i).('averages').('intSte');
                values(1:nPoints, 2*i - 1) = averages(1:nPoints);
                values(1:nPoints, 2*i) = errors(1:nPoints);
            end
        end
        
        function [values] = green_integral(obj)
            values = obj.green();
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_green' Accessor
        %
        function [normVals] = normalized_green(obj, ~)
            pointCounts = obj.point_counts();
            maxPointCount = max(pointCounts);
            roiCount = obj.roi_count();
            
            normVals = NaN(maxPointCount, roiCount * 2);
            for i = 1:roiCount
                nPoints = pointCounts(i);
                averages = obj.filedata(i).('averages').('intNormAvg');
                errors = obj.filedata(i).('averages').('intNormSte');
                normVals(1:nPoints, 2*i - 1) = averages(1:nPoints);
                normVals(1:nPoints, 2*i) = errors(1:nPoints);
            end
        end
        
        function [normVals] = norm_green_integral(obj)
            normVals = obj.normalized_green();
        end
        
        function [tf] = red_is_integral(~)
            tf = [];
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'red' Accessor
        %
        function [values] = red(obj)
            pointCounts = obj.point_counts();
            maxPointCount = max(pointCounts);
            roiCount = obj.roi_count();
            
            values = NaN(maxPointCount, roiCount * 2);
            for i = 1:roiCount
                nPoints = pointCounts(i);
                averages = obj.filedata(i).('averages').('redAvg');
                errors = obj.filedata(i).('averages').('redSte');
                values(1:nPoints, 2*i - 1) = averages(1:nPoints);
                values(1:nPoints, 2*i) = errors(1:nPoints);
            end
        end
        
        function [values] = red_integral(obj)
            values = obj.red();
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_red' Accessor
        %
        function [normVals] = normalized_red(obj, ~)
            pointCounts = obj.point_counts();
            maxPointCount = max(pointCounts);
            roiCount = obj.roi_count();
            
            normVals = NaN(maxPointCount, roiCount * 2);
            for i = 1:roiCount
                nPoints = pointCounts(i);
                averages = obj.filedata(i).('averages').('redNormAvg');
                errors = obj.filedata(i).('averages').('redNormSte');
                normVals(1:nPoints, 2*i - 1) = averages(1:nPoints);
                normVals(1:nPoints, 2*i) = errors(1:nPoints);
            end
        end
        
        function [normVals] = norm_red_integral(obj, ~)
            normVals = obj.normalized_red();
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
                    reqFields = {'filePath', 'time', 'averages', 'numROI', 'dnaType', 'solutions'};
                    if all(isfield(fileStruct, reqFields))
                        avgStruct = fileStruct.('averages');
                        reqFields = {'tauAvg', 'tauSte', 'intAvg', 'intSte', 'redAvg', 'redSte', ...
                                     'tauNormAvg', 'tauNormSte', 'intNormAvg', 'intNormSte', 'redNormAvg', 'redNormSte'};
                        if all(isfield(avgStruct, reqFields))
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
        % <filepath> = {dest, src1, src2, ...}
        %
        function save(filepath, roiData, dnaType, solutionInfo, varargin)
            optionIndices = find(strcmp(varargin, 'IsAveraged'));
            isAveraged = false;
            
            if ~isempty(optionIndices)
                nameIdx = optionIndices(1);
                valueIdx = nameIdx + 1;
                if strcmp(varargin{valueIdx}, 'true')
                    isAveraged = true;
                end
            end
            
            roiCount = roiData.roi_count();
            nBaselinePts = ROIUtils.number_of_baseline_pts(solutionInfo);
            adjTime = roiData.adjusted_time(nBaselinePts);
            lifetime = roiData.lifetime();
            normLifetime = roiData.normalized_lifetime(nBaselinePts);
            
            if roiData.green_is_integral()
                green = roiData.green_integral();
                normGreen = roiData.norm_green_integral(nBaselinePts);
            else
                green = roiData.green();
                normGreen = roiData.normalized_green(nBaselinePts);
            end
            
            if roiData.red_is_integral()
                red = roiData.red_integral();
                normRed = roiData.norm_red_integral(nBaselinePts);
            else
                red = roiData.red();
                normRed = roiData.normalized_red(nBaselinePts);
            end            
            
            % Save mandatory data
            fileStruct = struct;
            fileStruct.('filePath') = filepath(2:end);
            fileStruct.('numROI') = roiCount;
            fileStruct.('time') = adjTime;
            fileStruct.('dnaType') = dnaType;
            fileStruct.('solutions') = solutionInfo;
            
            avgStruct = struct;            
            if isAveraged
                avgStruct.('tauAvg') = lifetime(:, 1);
                avgStruct.('tauSte') = lifetime(:, 2);
                avgStruct.('intAvg') = green(:, 1);
                avgStruct.('intSte') = green(:, 2);
                avgStruct.('redAvg') = red(:, 1);
                avgStruct.('redSte') = red(:, 2);
                
                avgStruct.('tauNormAvg') = normLifetime(:, 1);
                avgStruct.('tauNormSte') = normLifetime(:, 2);
                avgStruct.('intNormAvg') = normGreen(:, 1);
                avgStruct.('intNormSte') = normGreen(:, 2);
                avgStruct.('redNormAvg') = normRed(:, 1);
                avgStruct.('redNormSte') = normRed(:, 2);
            else
                [avgStruct.('tauAvg'), avgStruct.('tauSte')] = ROIUtils.average(lifetime);
                [avgStruct.('intAvg'), avgStruct.('intSte')] = ROIUtils.average(green);
                [avgStruct.('redAvg'), avgStruct.('redSte')] = ROIUtils.average(red);

                [avgStruct.('tauNormAvg'), avgStruct.('tauNormSte')] = ROIUtils.average(normLifetime);
                [avgStruct.('intNormAvg'), avgStruct.('intNormSte')] = ROIUtils.average(normGreen);
                [avgStruct.('redNormAvg'), avgStruct.('redNormSte')] = ROIUtils.average(normRed);
            end
            
            
            
            fileStruct.('averages') = avgStruct;
            
            % Save optional data
            if nargin > 4
                fileStruct.('userPref') = varargin{1};
            end
            
            save(filepath, '-struct', 'fileStruct');
        end
    end
end