classdef RawFile < ROIFile
%% ----------------------------------------------------------------------------------------------------------------
% 'RawFile' implementation of ROIFile
%
% Class representing a file containing 'raw', unedited ROi data
%
% (FIELD) "filepaths": A cell of strings describing which files data is sourced from
% (FIELD) "filedata": A struct array containing data from each file
%
    properties
        filepaths cell
        filedata struct
    end
    
    methods
        function [this] = RawFile(filepaths)
        %% --------------------------------------------------------------------------------------------------------
        % 'RawFile' Constructor
        %
        % (IN) "filepaths": A cell of strings describing which files to load
        %
        % (OUT) "this": the constructed RawFile
        %
        % Assumes that the filepaths point to files with the following format:
        % [file struct]: {
        %   'roiData': {
        %       'time': row vector
        %       'tau_m': row vector
        %       'mean_int': row vector
        %       'red_mean': row vector
        %   }
        % }
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
        
        function [fileType] = type(~)
        %% --------------------------------------------------------------------------------------------------------
        % 'type' Accessor
        %
        % Returns an enum describing the file format
        %
        % (OUT) "fileType": An ROIFileType with enumeration 'Raw'
        %
            fileType = ROIFileType.Raw;
        end
        
        function [filepaths] = source_files(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'source_files' Accessor
        %
        % Returns a list of files that data was sourced from
        %
        % (OUT) "filepaths": A cell array of strings describing each source filepath
        %
            filepaths = obj.filepaths;
        end
        
        function [names] = experiment_names(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'experiment_names' Accessor
        %
        % Returns the names of the experiments that produced the data
        %
        % (OUT) "names": A cell array of strings describing each experiment name
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
        % Returns how many files data was sourced from
        %
        % (OUT) "count": the number of files that were loaded
        %
            count = numel(obj.filedata);
        end
        
        function [counts] = file_roi_counts(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'file_roi_counts' Accessor
        %
        % Returns the the number of ROIs for each loaded file
        %
        % (OUT) "counts": A vector containing the number of ROIs in each file
        %
            counts = zeros(1, numel(obj.filedata));
            for i = 1:numel(obj.filedata)
                counts(i) = numel(obj.filedata(i).('roiData'));
            end
        end
        
        function [count] = roi_count(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'roi_count' Accessor
        % 
        % Returns the total number of ROIs loaded
        %
        % (OUT) "count": the sum of the number of ROIs in each file
        %
            count = sum(obj.file_roi_counts());
        end
        
        function [counts] = point_counts(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'point_counts' Accessor
        %
        % Returns the number of data points in each file
        %
        % (OUT) "counts": A vector containing the number of data points for each file.
        %                 If a single file has varying data points, the minimum is returned.
        %
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
        
        function [values] = time(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'time' Accessor
        %
        % Returns the list of time values for each data point
        %
        % (OUT) "values": A column vector containing the time values for each data point
        %
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
        
        function [adjVals] = adjusted_time(obj, nBaselinePts)
        %% --------------------------------------------------------------------------------------------------------
        % 'adjusted_time' Accessor
        %
        % Returns the time values adjusted so that the value at the baseline is 0
        % 
        % (IN) "nBaselinePts": number of the data point that represents the baseline
        %
        % (OUT) "adjVals": a column vector containg the adjusted time values for each data point
        %
            time = obj.time();
            adjVals = time * 60 * 24;
            adjVals = adjVals - adjVals(nBaselinePts);
        end
        
        function [tf] = has_exp_info(~)
        %% --------------------------------------------------------------------------------------------------------
        % 'has_exp_info' Accessor
        %
        % Checks if the loaded files contain any experiment info
        %
        % (OUT) "tf": Always false
        %
            tf = false;
        end
        
        function [labels] = roi_labels(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'roi_labels' Accessor
        %
        % Returns the labels for each piece of ROI data
        %
        % (OUT) "labels": A cell array of strings describing the label for each ROI's data. 
        %                 The first label is 'Time' and is followed by 'Tau #_', 'Int #_', 'Red #_', and so on.
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
        
        function [dnaTypes] = dna_types(~)
        %% --------------------------------------------------------------------------------------------------------
        % 'dna_types' Accessor
        %
        % Returns the list of DNA types used in each experiment
        %
        % (OUT) "dnaTypes": An emtpy cell
        %
            dnaTypes = {};
        end
        
        function [solutions] = solution_info(~)
        %% --------------------------------------------------------------------------------------------------------
        % 'solution_info' Accessor
        %
        % Returns a list of solutions used in each experiment
        %
        % (OUT) "solutions": an empty cell
        %
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
        
        function [values] = lifetime(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'lifetime' Accessor
        %
        % Returns the lifetime values for each data point, where lifetime is equal to mean tau
        %
        % (OUT) "values": A column vector containing lifetime values for each data point
        %
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
        
        function [normVals] = normalized_lifetime(obj, nBaselinePts)
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_lifetime' Accessor
        %
        % Returns the normalized lifetime values for each data point.
        % Normalized values have an average of 1 over points up to the
        % baseline.
        %
        % (IN) "nBaselinePts": The number of the data point that is at baseline
        %
        % (OUT) "normVals": A column vector containing the normalized lifetime values for each data point
        %
            normVals = ROIUtils.normalize(obj.lifetime(), nBaselinePts);
        end
        
        function [values] = green(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'green' Accessor
        %
        % Returns the green intensity values for each data point, where green intensity is equal to mean intensity
        %
        % (OUT) "values": A column vector containing green intensity values for each data point
        %
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
        
        function [normVals] = normalized_green(obj, nBaselinePts)
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_green' Accessor
        %
        % Returns the normalized green intensity values for each data point.
        % Normalized values have an average of 1 over points up to the
        % baseline.
        %
        % (IN) "nBaselinePts": The number of the data point that is at baseline
        %
        % (OUT) "normVals": A column vector containing the normalized green intensity values for each data point
        %
            normVals = ROIUtils.normalize(obj.green(), nBaselinePts);
        end
        
        function [values] = red(obj)
        %% --------------------------------------------------------------------------------------------------------
        % 'red' Accessor
        %
        % Returns the red intensity values for each data point, where red intensity is equal to mean red intensity
        %
        % (OUT) "values": A column vector containing red intensity values for each data point
        %
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
        
        function [normVals] = normalized_red(obj, nBaselinePts)
        %% --------------------------------------------------------------------------------------------------------
        % 'normalized_red' Accessor
        %
        % Returns the normalized red intensity values for each data point.
        % Normalized values have an average of 1 over points up to the
        % baseline.
        %
        % (IN) "nBaselinePts": The number of the data point that is at baseline
        %
        % (OUT) "normVals": A column vector containing the normalized red intensity values for each data point
        %
            normVals = ROIUtils.normalize(obj.red(), nBaselinePts);
        end
    end
    
    methods (Static)
        function [tf] = follows_format(filepaths)
        %% --------------------------------------------------------------------------------------------------------
        % 'follows_format' Method
        %
        % Checks if data in the given files follows the format for a raw ROI file
        %
        % (IN) "filepaths": A cell array of strings representing the paths to possible ROI files
        %
        % (OUT) "tf": An vector of logical values, where true means that a file does follow the format, and false otherwise
        %
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
        
        function save(filepath, roiData, ~, ~)
        %% --------------------------------------------------------------------------------------------------------
        % 'save' Method
        %
        % Saves given ROI data in a raw ROI file
        %
        % (IN) "filepath": String representing the path to the saved file
        % (IN) "roiData": An ROIData containing the data to be saved
        %
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