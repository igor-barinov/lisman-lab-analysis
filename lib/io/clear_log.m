function clear_log(logFile)
    fileID = fopen(logFile, 'w');
    fprintf(fileID, '\0');
    fclose(fileID);
end