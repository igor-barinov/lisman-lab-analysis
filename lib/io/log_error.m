function log_error(exception, logFile)
    dateStr = datestr(datetime());
    errReport = getReport(exception, 'extended', 'hyperlinks', 'off');
    
    fileID = fopen(logFile, 'a');
    fprintf(fileID, '[%s]: %s\n\n\n', dateStr, errReport);
    fclose(fileID);
end