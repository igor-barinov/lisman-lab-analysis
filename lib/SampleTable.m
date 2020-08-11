classdef SampleTable
    properties
        samples double
        info cell
    end
    
    methods
        %% --------------------------------------------------------------------------------------------------------
        % 'SampleTable' Constructor
        %
        function [this] = SampleTable()
            this.samples = [];
            this.info = {};
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'is_empty' Accessor
        %
        function [tf] = is_empty(obj)
            tf = isempty(obj.samples);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'samples' Accessor
        %
        function [values] = all_samples(obj)
            values = obj.samples;
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'at' Accessor
        %
        function [sample] = at(obj, index)
            sample = obj.samples(:, index);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'count' Accessor
        %
        function [count] = sample_count(obj)
            count = size(obj.samples, 2);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'sample_sizes' Accessor
        %
        function [counts] = sample_sizes(obj)
            counts = zeros(1, obj.sample_count());
            for i = 1:numel(counts)
                sample = obj.samples(:, i);
                counts(i) = numel(find(~isnan(sample)));
            end
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'all_info' Accessor
        %
        function [table] = all_info(obj)
            table = obj.info(:, 2:end);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'sample_labels' Accessor
        %
        function [labels] = sample_labels(obj)
            labels = obj.info(:, 1);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'add_sample' Modifier
        %        
        function [newObj] = add_sample(obj, sample, srcLabel, startPt, endPt, sourceROIs, sourceFiles)
            newObj = obj;
            
            nOldSamples = obj.sample_count();
            oldSampleSzs = obj.sample_sizes();
            sampleSize = numel(sample);
            
            newObj.samples = NaN(max([sampleSize, oldSampleSzs]), nOldSamples+1);
            newObj.samples(1:max(oldSampleSzs), 1:nOldSamples) = obj.samples;
            newObj.samples(1:sampleSize, nOldSamples+1) = sample;
            
            sampleInfo = [ {['Sample ', num2str(nOldSamples+1), ' (', srcLabel, ')'], ...
                           numel(find(~isnan(sample))), ...
                           startPt, ...
                           endPt}, ...
                           num2cell(sourceROIs), ...
                           sourceFiles ];
            
            nOldInfoFields = size(obj.info,2);
            nInfoFields = numel(sampleInfo);
            
            newObj.info = cell(nOldSamples+1, max([nOldInfoFields, nInfoFields]));
            newObj.info(1:nOldSamples, 1:nOldInfoFields) = obj.info;
            newObj.info(nOldSamples+1, 1:nInfoFields) = sampleInfo;
        end
    end
end