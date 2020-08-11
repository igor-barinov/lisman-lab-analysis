% 'select_roi_data_dlg' Dialog Function
%   Selects 'ROI' data from a struct with ROI file data, prompting the user if necessary
%
% INPUTS
% ------
% <fileData>, struct: Contains 'ROI' file data in the 'file_data' format
% 
% OUTPUTS
% -------
% <dataWasChosen>, logical: True if 'ROI' data was successfully selected. 
%                           False otherwise
% <roiData>, struct: Will contain the selected 'ROI' data in the 'roi_data' format
%
% EXCEPTIONS
% ----------
% Warning if <fileData> did not have 'ROI' data
%
% 'missing_inputs_error' if <fileData> was not given
%
% See also
%   'is_raw_file_data'
%   'is_prep_file_data'
%
function [dataWasChosen, roiData] = select_roi_data_dlg(fileData)
    dataWasChosen = false;
    roiData = struct;
    
    %% Check if an input was given
    if nargin ~= 1
        throw(missing_inputs_error(nargin, 1));
    end
    
    if is_raw_file_data(fileData)
        %% Select raw data from RAW file
        dataWasChosen = true;
        roiData = fileData.rawData;
    elseif is_prep_file_data(fileData)
        %% Give choice of either raw or prepared data
        choice = questdlg('This file has raw and prepared data. Which would you like to use?', 'Choose Data', 'Raw', 'Prepared', 'Cancel', 'Cancel');
        switch choice
            case 'Raw'
                roiData = fileData.rawData;
                dataWasChosen = true;
            case 'Prepared'
                roiData = fileData.prepData;
                dataWasChosen = true;
            case 'Cancel'
                dataWasChosen = false;
        end
    else
        %% Other stucts/file types are invalid
        warndlg('This file has no ROI data to load/select');
    end
end