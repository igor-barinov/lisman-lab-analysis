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
    end
end