classdef IOUtils
    methods (Static)
        function create_ini_file(filepath, settings, values)
        %% --------------------------------------------------------------------------------------------------------
        % 'create_ini_file' Method
        %
        % Creates a .ini file at the given filepath with the given settings
        % and values.
        %
        % (IN) "filepath": string describing where the .ini file will be
        % created
        % (IN) "settings": cell of strings describing available settings
        % (IN) "values": cell of strings describing default values to given
        % settings at corresponding indices
        %
            fileID = fopen(filepath, 'w');
            for i = 1:numel(settings)
                fprintf(fileID, '%s=%s\n', settings{i}, values{i});
            end
            fclose(fileID);
        end
        
        function [settings, values] = read_ini_file(filepath)
        %% --------------------------------------------------------------------------------------------------------
        % 'read_ini_file' Method
        %
        % Gets list of settings and values from .ini file
        %
        % (IN) "filepath": string describing path to .ini file
        %
        % (OUT) "settings": cell of strings describing available settings
        % in .ini file
        % (OUT) "values": cell of strings describing values to settings at
        % corresponding indices
        %
            fileID = fopen(filepath);            
            currentLine = fgetl(fileID);
            settings = {};
            values = {};
            while ~isequal(currentLine, -1)
                lineEntries = strsplit(currentLine, '=');
                settings{end+1} = lineEntries{1};
                values{end+1} = lineEntries{2};
                currentLine = fgetl(fileID);
            end
            fclose(fileID);
        end
        
        function [filepath] = path_to_log(script)
        %% --------------------------------------------------------------------------------------------------------
        % 'path_to_log' Method
        %
        % Returns the path to an 'analysis_1_2's log file
        %
        % (IN) "script": string describing 'analysis_1_2' version
        % 
        % (OUT) "filepath": string describing path to log file
        %
            scriptFile = which(script);
            [path, ~, ~] = fileparts(scriptFile);
            logName = [script, '_LOG.txt'];
            filepath = fullfile(path, logName);
        end
        
        function clear_log(filepath)
        %% --------------------------------------------------------------------------------------------------------
        % 'clear_log' Method
        %        
        % Clears all entries in a given log file
        %
        % (IN) "filepath": string describing path to log file
        %
            fileID = fopen(filepath, 'w');
            fprintf(fileID, '\0');
            fclose(fileID);
        end
        
        function log_error(exception, filepath)
        %% --------------------------------------------------------------------------------------------------------
        % 'log_error' Method
        %           
        % Logs error details in a given log file. Errors are logged in the
        % format: "<date>: <error message>"
        %
        % (IN) "exception": MException containing error details
        % (IN) "filepath": string describing path to log file
        %
            dateStr = datestr(datetime());
            errReport = getReport(exception, 'extended', 'hyperlinks', 'off');

            fileID = fopen(filepath, 'a');
            fprintf(fileID, '[%s]: %s\n\n\n', dateStr, errReport);
            fclose(fileID);
        end
        
        function [logs] = read_log(filepath)
        %% --------------------------------------------------------------------------------------------------------
        % 'read_log' Method
        % 
        % Gets a list of logs in a given log file
        %
        % (IN) "filepath": string describing path to log file
        %
        % (OUT) "logs": cell of string pairs containing each log. Each pair
        % is in the form { <date>, <error message> }.
        %
            fileID = fopen(filepath, 'r');
            currentLine = fgetl(fileID);
            currentTimestamp = [];
            currentErr = [];
            logs = {};
            while ~isequal(currentLine, -1)
                if ~isempty(currentLine) && currentLine(1) == '['
                    if ~isempty(currentTimestamp)
                        logs = [logs; {currentTimestamp, currentErr}];
                        currentTimestamp = [];
                        currentErr = [];
                    end
                    
                    startIdx = 2;
                    endIdx = strfind(currentLine, ']') - 1;
                    currentTimestamp = currentLine(startIdx:endIdx);
                    currentLine = currentLine(endIdx+3:end);
                end
                
                currentErr = sprintf('%s\n%s', currentErr, currentLine);
                currentLine = fgetl(fileID);
            end
            
            logs = [logs; {currentTimestamp, currentErr}];
            fclose(fileID);
        end
        
        function [text] = read_word_file(filepath)
        %% --------------------------------------------------------------------------------------------------------
        % 'read_word_file' Method
        %
        % Returns all text from a Microsoft Word file
        %
        % (IN) "filepath": string describing path to Word file
        % 
        % (OUT) "text": string containing all text in given Word file
        %
            wordClient = actxserver('Word.Application');
            wordDoc = wordClient.Documents.Open(filepath);
            text = wordDoc.Content.Text;
            wordDoc.Close();
            wordClient.Quit();
        end
    end
end