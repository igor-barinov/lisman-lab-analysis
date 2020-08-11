function [newSampleTable, sampleLabels] = add_samples_to_table(sampleTable, intSample, redSample, lifetimeSample)    
    %% Check if all inputs were given
    if nargin ~= 4
        throw(missing_inputs_error(nargin, 4));
    end
    
    %% Try adding the samples
    try
        newSampleTable = sampleTable;
        [newSampleTable] = add_column_to_table(newSampleTable, intSample);
        [newSampleTable] = add_column_to_table(newSampleTable, redSample);
        [newSampleTable] = add_column_to_table(newSampleTable, lifetimeSample);
    catch err
        rethrow(err);
    end
    
    %% Get the sample labels
    sampleLabels = {};
    nSamples = size(sampleTable, 2);
    if ~isempty(intSample)
        nSamples = nSamples + 1;
        sampleLabels{end+1, 1} = ['Sample ', num2str(nSamples), ' (Int)'];
    end
    if ~isempty(redSample)
        nSamples = nSamples + 1;
        sampleLabels{end+1, 1} = ['Sample ', num2str(nSamples), ' (Red)'];
    end
    if ~isempty(lifetimeSample)
        nSamples = nSamples + 1;
        sampleLabels{end+1, 1} = ['Sample ', num2str(nSamples), ' (Tau)'];
    end
end
