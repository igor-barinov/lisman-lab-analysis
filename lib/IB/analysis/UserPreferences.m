classdef UserPreferences
    enumeration
        TrueFalse,
        Number,
        String
    end
    
    properties
        indexMap        containers.Map
        settingNames    cell
        settingValues   cell
    end
    
    methods
        function [this] = UserPreferences(varargin)
            this.indexMap = containers.Map;
            this.settingNames = {};
            this.settingValues = {};
            
            if nargin == 1 % Load from .ini
                filepath = varargin{1};
                [names, values] = IOUtils.read_ini_file(filepath);
                
                for i = 1:numel(names)
                    name = names{i};
                    value = values{i};
                    
                    this.indexMap(name) = i;
                    this.settingNames{end+1} = name;
                    
                    if strcmp(value, 'true') || strcmp(value, 'false')
                        type = UserPreferences.TrueFalse;
                    elseif isnan(str2double(value))
                        type = UserPreferences.String;
                    else
                        type = UserPreferences.Number;
                    end
                    
                    this.settingValues = [this.settingValues; { type, value }];
                end
                
            elseif nargin == 2 % Load from params
                settings = varargin{1};
                defaultValues = varargin{2};
                
                % settings = {name, type}
                % defaultValues = {value}
                
                for i = 1:size(settings, 1)
                    name = settings{i, 1};
                    type = settings{i, 2};
                    value = defaultValues{i};
                    
                    this.indexMap(name) = i;
                    this.settingNames{end+1} = name;
                    this.settingValues = [this.settingValues; {type, value}];
                end
            end
        end
        
        function [newObj] = change_settings(obj, settings, newValues)
            newObj = obj;
            for i = 1:numel(settings)
                index = newObj.indexMap(settings{i});
                newObj.settingValues{index, 2} = newValues{i};
            end
        end
        
        function save_to_ini(obj, filepath)
        end
    end
    
    methods (Static)
        function [castedVal, success] = cast_value(type, value)
            switch type
                case UserPreferences.TrueFalse
                    if strcmp(value, 'true')
                        castedVal = true;
                    elseif strcmp(value, 'false')
                        castedVal = false;
                    end
                    success = islogical(castedVal);
                    
                case UserPreferences.Number
                    castedVal = str2double(value);
                    success = ~isnan(castedVal);
                    
                case UserPreferences.String
                    castedVal = value;
                    success = ischar(castedVal);
                    
                otherwise
                    success = false;
            end
        end
    end
end