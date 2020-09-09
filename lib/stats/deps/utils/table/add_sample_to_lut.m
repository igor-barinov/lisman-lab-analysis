function [newSampleLUT] = add_sample_to_lut(sampleLUT, sampleSz, startPt, endPt, sourceColumns, sourceFiles)
    %% Check if all inputs were given
    if nargin ~= 6
        throw(missing_inputs_error(nargin, 6));
    end
    
    %% Try adding sample info to LUT
    try
        lutData = [{sampleSz, startPt, endPt}, sourceColumns, sourceFiles];
        [newSampleLUT] = add_row_to_table(sampleLUT, lutData);
    catch err
        rethrow(err);
    end
end