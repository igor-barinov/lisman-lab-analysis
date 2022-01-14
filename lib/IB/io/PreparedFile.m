classdef PreparedFile < ROIFile
    properties
        filepaths cell
        filedata struct
    end
    
    methods
        function [this] = PreparedFile(filepaths)
        %% --------------------------------------------------------------------------------------------------------
        % 'PreparedFile' Constructor
        %
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
                    
                    % Mandatory fields
                    dataStruct.('alladj') = prepData.('alladj');
                    dataStruct.('numROI') = prepData.('numROI');
                    dataStruct.('dnaType') = prepData.('dnaType');
                    dataStruct.('solutions') = prepData.('solutions');
                    
                    % Append user pref if exists
                    if isfield(prepData, 'userPref')
                        dataStruct.('userPref') = prepData.('userPref');
                    else
                        dataStruct.('userPref') = [];
                    end
                    
                    % Append integral specification if exists, otherwise indicate as no integral data
                    if isfield(prepData, 'isIntegral')
                        isInt = prepData.('isIntegral');
                        dataStruct.('isIntegral') = isInt(2:end); % exclude column for time series
                    else
                        dataStruct.('isIntegral') = false(1, dataStruct.('numROI'));
                    end
                    
                    this.filedata = [this.filedata, dataStruct];
                end
            end
        end
        
        
        function [fileType] = type(~)
        %% --------------------------------------------------------------------------------------------------------
        % 'type' Accessor
        %
            fileType = ROIFileType.Prepared;
        end
        
        
        function [filepaths] = source_files(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'source_files' Accessor
        %
            filepaths = obj.filepaths;
        end
        
        
        function [names] = experiment_names(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'experiment_names' Accessor
        %
            names = cell(numel(obj.filepaths), 1);
            for i = 1:numel(names)
                [~, names{i}, ~] = fileparts(obj.filepaths{i});
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
            for i = 1:numel(obj.filedata)
                counts(i) = obj.filedata(i).('numROI');
            end
        end
        
        function [tf] = is_integral(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'is_integral' Accessor
        %
            tf = [obj.filedata.('isIntegral')];
            tf = [false, tf];
        end
        
        function [count] = roi_count(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'roi_count' Accessor
        %
            count = sum(obj.file_roi_counts());
        end
        
        
        function [counts] = point_counts(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'point_counts' Accessor
        %
            counts = zeros(1, numel(obj.filedata));
            for i = 1:numel(obj.filedata)
                ROIs = obj.filedata(i).('alladj');
                counts(i) = size(ROIs, 1);
            end
        end
        
        
        function [values] = time(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'time' Accessor
        %
            pointCounts = obj.point_counts();
            [~, targetFile] = max(pointCounts);
            ROIs = obj.filedata(targetFile).('alladj');
            values = ROIs(:, 1);
            %values = values / 60 / 24;
        end
        
        
        function [adjVals] = adjusted_time(obj, nBaselinePts)
        %% --------------------------------------------------------------------------------------------------------
        % 'adjusted_time' Accessor
        %
            time = obj.time() * 60 * 24;
            adjVals = time - time(nBaselinePts);
        end
        
        
        function [tf] = has_exp_info(~)
        %% --------------------------------------------------------------------------------------------------------
        % 'has_exp_info' Accessor
        %
            tf = true;
        end
        
        
        function [labels] = roi_labels(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'roi_labels' Accessor
        %
            roiCount = obj.roi_count();
            isInt = obj.is_integral();
            labels = cell(roiCount * 3 + 1, 1);
            labels{1} = 'Time';
            for i = 1:roiCount                
                if isInt(i+1)
                    labels{i+1}             = ['Tau (Integral) #', num2str(i)];
                else
                    labels{i+1}             = ['Tau (Mean) #', num2str(i)];
                end
                
                if isInt(i+roiCount+1)
                    labels{i+roiCount+1}    = ['Int (Integral) #', num2str(i)];
                else
                    labels{i+roiCount+1}    = ['Int (Mean) #', num2str(i)];
                end
                
                if isInt(i+2*roiCount+1)
                    labels{i+2*roiCount+1}  = ['Red (Integral) #', num2str(i)];
                else
                    labels{i+2*roiCount+1}  = ['Red (Mean) #', num2str(i)];
                end
            end
        end
        
        
        function [dnaTypes] = dna_types(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'dna_types' Accessor
        %
            dnaTypes = cell(1, numel(obj.filedata));
            for i = 1:numel(dnaTypes)
                dnaTypes{i} = obj.filedata(i).('dnaType');
            end
        end
        
        
        function [solutions] = solution_info(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'solution_info' Accessor
        %
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
            tf = false;
            for i = 1:numel(obj.filedata)
                if ~isempty(obj.filedata(i).('userPref'))
                    tf = true;
                    return;
                end
            end
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
            if isfield(allPrefs, {'showLifetime', 'showGreenInt', 'showRedInt', 'showAnnots'})
                lifetimeDefaults = {allPrefs.('showLifetime')};
                greenIntDefaults = {allPrefs.('showGreenInt')};
                redIntDefaults = {allPrefs.('showRedInt')};
                annotationDefaults = {allPrefs.('showAnnots')};

                defaults = struct;
                defaults.('showLifetime') = lifetimeDefaults{1};
                defaults.('showGreenInt') = greenIntDefaults{1};
                defaults.('showRedInt') = redIntDefaults{1};
                defaults.('showAnnots') = annotationDefaults{1};
            else
                defaults = [];
            end
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
        %% NOT IMPLEMENTED --------------------------------------------------------------------------------------------------------
        %
        % 'annotation_positions' Accessor
        %
        % Returns the saved annotation positions
        %
        % (OUT) "positions": cell array containing positional data for each annotation
        %
            positions = {};
        end
        
        
        function [values] = lifetime(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'lifetime' Accessor
        %
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
        
        
        function [normVals] = normalized_lifetime(obj, nBaselinePts)
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_lifetime' Accessor
        %
            normVals = ROIUtils.normalize(obj.lifetime(), nBaselinePts);
        end
        
        
        function [values] = green(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'green' Accessor
        %
        % 
        % Any integral values are replaced with NaNs
        %
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
                
                isIntegral = [false, obj.filedata(i).('isIntegral')];
                ROIs(:, isIntegral) = NaN;
                
                greenVals = ROIs(:, 2+roiCount:2*roiCount+1);
                values(1:nPoints, roiIdx:roiIdx+roiCount-1) = greenVals;
                roiIdx = roiIdx + roiCount;
            end
        end
        
        function [values] = green_integral(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'green_integral' Accessor
        %
        % Any mean values are replaced with NaNs
        %
        
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
                
                isIntegral = [false, obj.filedata(i).('isIntegral')];
                ROIs(:, ~isIntegral) = NaN;
                
                greenVals = ROIs(:, 2+roiCount:2*roiCount+1);
                values(1:nPoints, roiIdx:roiIdx+roiCount-1) = greenVals;
                roiIdx = roiIdx + roiCount;
            end
        end
        
        function [tf] = green_is_integral(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'green_is_integral' Accessor
        %
        % Checks if all green values are integral
        %
        % (OUT) "tf": True if all green values are integral, false otherwise
        %
            tf = all(isnan(obj.green()));
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
        
        
        function [values] = red(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'red' Accessor
        %
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
                
                isIntegral = [false, obj.filedata(i).('isIntegral')];
                ROIs(:, isIntegral) = NaN;
                
                redVals = ROIs(:, 2+2*roiCount:3*roiCount+1);
                values(1:nPoints, roiIdx:roiIdx+roiCount-1) = redVals;
                roiIdx = roiIdx + roiCount;
            end
        end
        
        function [values] = red_integral(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'red_integral' Accessor
        %
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
                
                isIntegral = [false, obj.filedata(i).('isIntegral')];
                ROIs(:, ~isIntegral) = NaN;
                
                redVals = ROIs(:, 2+2*roiCount:3*roiCount+1);
                values(1:nPoints, roiIdx:roiIdx+roiCount-1) = redVals;
                roiIdx = roiIdx + roiCount;
            end
        end
        
        function [tf] = red_is_integral(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'red_is_integral' Accessor
        %
        % Checks if all red values are integral
        %
        % (OUT) "tf": True if all red values are integral, false otherwise
        %
            tf = all(isnan(obj.red()));
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
    end
    
    methods (Static)
        function [tf] = follows_format(filepaths)
        %% --------------------------------------------------------------------------------------------------------
        % 'follows_format' Method
        %
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
        
        
        function save(filepath, roiData, dnaType, solutionInfo, varargin)
        %% --------------------------------------------------------------------------------------------------------
        % 'save' Method
        %
        % Saves given ROI data to the specified filepath, with options for saving user preferences
        %
        % (IN) "filepath": String specifying path where file will be saved
        % (IN) "roiData": A ROIData object containing the data to be saved
        % (IN) "dnaType": String labeling which DNA the ROI data corresponds to
        % (IN) "solutionInfo": A n x 2 cell table containing the timings of solution applications, where each row is (data pt #, solution name)
        % (OPT. IN) "userPref": A struct containing user preference data
        % (OPT. IN) "isIntegral": A logical array specifying which timeseries data is integral. 
        %                         True values indicate integral, and false indicate otherwise
        %
            time = roiData.time();
            %adjTime = roiData.adjusted_time(ROIUtils.number_of_baseline_pts(solutionInfo));
            lifetime = roiData.lifetime();
            green = roiData.green();
            red = roiData.red();
            prepData = struct;
            
            % Save mandatory fields
            prepData.('alladj') = [time, lifetime, green, red];
            prepData.('numROI') = roiData.roi_count();
            prepData.('dnaType') = dnaType;
            prepData.('solutions') = solutionInfo;
            
            
            
            if nargin > 5 % Save integral data if necessary
                isIntegral = varargin{2};
                greenInt = roiData.green_integral();
                redInt = roiData.red_integral();
                meanData = [time, lifetime, green, red];
                intData = [time, lifetime, greenInt, redInt];
                
                allData = NaN(size(prepData.('alladj')));
                allData(:, isIntegral) = intData(:, isIntegral);
                allData(:, ~isIntegral) = meanData(:, ~isIntegral);
                
                prepData.('isIntegral') = isIntegral;
                prepData.('alladj') = allData;
                
            elseif nargin > 4 % Save user pref if necessary
                prepData.('userPref') = varargin{1};
            end
            
            if exist(filepath, 'file') == 2
                save(filepath, 'prepData', '-append');
            else
                save(filepath, 'prepData');
            end
            
            
        end
    end
end