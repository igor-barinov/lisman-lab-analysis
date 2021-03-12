classdef AppState
    methods (Static)
        %% --------------------------------------------------------------------------------------------------------
        % 'logdlg' Method
        %
        % Raises error dialog while recording to the program's log. Assumes that the
        % program version is latest release. If error could not be logged,
        % an eror is printed to the console.
        function logdlg(lastErr)
            % Try making/adding to log
            try
                logFile = IOUtils.path_to_log(Analysis_1_2_Versions.release());
                errordlg(['An error occured. See log at ', logFile]);
                IOUtils.log_error(lastErr, logFile);
            catch
                errordlg('Could not log error. See console for details');
                error(getReport(lastErr));
            end
        end
    end
end