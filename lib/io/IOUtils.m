classdef IOUtils
    methods (Static)
        %% --------------------------------------------------------------------------------------------------------
        % 'create_ini_file' Method
        %
        function create_ini_file(filepath, settings, values)
            fileID = fopen(filepath, 'w');
            for i = 1:numel(settings)
                fprintf(fileID, '%s=%s\n', settings{i}, values{i});
            end
            fclose(fileID);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'read_ini_file' Method
        %
        function [settings, values] = read_ini_file(filepath)
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
        
        %% --------------------------------------------------------------------------------------------------------
        % 'path_to_log' Method
        %        
        function [filepath] = path_to_log(script)
            scriptFile = which(script);
            [path, ~, ~] = fileparts(scriptFile);
            logName = [script, '_LOG.txt'];
            filepath = fullfile(path, logName);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'clear_log' Method
        %        
        function clear_log(filepath)
            fileID = fopen(filepath, 'w');
            fprintf(fileID, '\0');
            fclose(fileID);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'log_error' Method
        %           
        function log_error(exception, filepath)
            dateStr = datestr(datetime());
            errReport = getReport(exception, 'extended', 'hyperlinks', 'off');

            fileID = fopen(filepath, 'a');
            fprintf(fileID, '[%s]: %s\n\n\n', dateStr, errReport);
            fclose(fileID);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'read_log' Method
        % 
        function [logs] = read_log(filepath)
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
            fclose(fileID);
        end
        
        %% --------------------------------------------------------------------------------------------------------
        % 'read_word_file' Method
        %        
        function [text] = read_word_file(filepath)
            wordClient = actxserver('Word.Application');
            wordDoc = wordClient.Documents.Open(filepath);
            text = wordDoc.Content.Text;
            wordDoc.Close();
            wordClient.Quit();
        end
    end
end