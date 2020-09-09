function [newRoiData] = add_to_roi_data(roiDataStruct, time, int, red, lifetime)
    newRoiData = struct;

    %% Deterimine if inputs were given
    if nargin == 5
        ltWasGiven = true;
    elseif nargin == 4
        ltWasGiven = false;
    else
        throw(missing_inputs_error(nargin, 4));
    end

    %% Check if the given struct has valid data
    try
        [hasLt, currentTimeVals, currentIntVals, currentRedVals, currentLtVals] = read_roi_data_struct(roiDataStruct);
    catch err
        rethrow(err);
    end
    
    %% Check if the given data has enough ROIs
    numROI = size(currentIntVals, 2);
    if size(int, 2) ~= numROI || size(red, 2) ~= numROI
        throw(general_error({'int', 'numROI'}, 'ROIs are missing'));
    end
    if ltWasGiven && (size(lifetime,2) ~= numROI)
        throw(general_error({'lifetime'}, 'ROIs are missing'));
    end
    
    %% Check if the given data has uniform length
    numInputPts = size(int, 1);
    if size(red, 1) ~= numInputPts
        throw(general_error({'int', 'red'}, 'Non-uniform # of data points'));
    end
    if ltWasGiven && (size(lifetime,1) ~= numInputPts)
        throw(general_error({'int', 'lifetime'}, 'Non-uniform # of data points'));
    end
    
    %% Generate additional time values if necessary
    if isempty(time)
        numCurrentPts = length(currentTimeVals);
        timeDelta = currentTimeVals(2) - currentTimeVals(1);
        pts = numCurrentPts+1:numCurrentPts+numInputPts;
        newTimeVals = timeDelta*(pts - 1) + currentTimeVals(1);
    else
        newTimeVals = time;
    end
    
    %% Append the new data
    newRoiData.time = [currentTimeVals; newTimeVals];
    newRoiData.int = [currentIntVals; int];
    newRoiData.red = [currentRedVals; red];
    
    if hasLt && ltWasGiven
        newRoiData.lifetime = [currentLtVals; lifetime];
    end
end