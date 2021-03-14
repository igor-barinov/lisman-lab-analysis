function [fileWasSaved, fileData] = save_roi_file_dlg(rawData, prepData, expInfo, avgData)
    fileData = struct;
    
    [file, path, typeIndex] = uiputfile({'*.mat', 'Prepared ROI Files (*.mat)'; '*.mat', 'Averaged ROI Files (*.mat)'});
    if isequal(file, 0)
        fileWasSaved = false;
        return;
    end
    
    if typeIndex == 1
        try
            [fileData] = make_roi_file('PREP', rawData, prepData, expInfo);
        catch
            warndlg('Could not save data as a prepared ROI file');
            fileWasSaved = false;
            return;
        end
    elseif typeIndex == 2
        try
            [fileData] = make_roi_file('AVG', [], [], expInfo, avgData);
        catch
            warndlg('Could not save data as an averaged ROI file');
            fileWasSaved = false;
            return;
        end
    end
    
    save(fullfile(path, file), '-struct', 'fileData');
    fileWasSaved = true;
end