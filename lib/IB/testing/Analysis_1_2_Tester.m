classdef Analysis_1_2_Tester
    
    properties
        gui matlab.ui.Figure
    end
    
    methods
        function [this] = Analysis_1_2_Tester(varargin)
            if nargin == 0
                version = Analysis_1_2_Versions.release();
            else
                version = varargin{1};
            end
            
            this.gui = eval(version);
        end
        
        function [handles] = get_handles(obj)
            handles = guidata(obj.gui);
        end
        
        function [hMainFig] = get_figure_handle(obj)
            allHandles = obj.get_handles();
            hMainFig = allHandles.(AppState.MainFigFieldName);
        end
        
        function [appVars] = get_app_vars(obj)
            appVars = getappdata(obj.get_figure_handle());
            metadataFields = {'GUIDEOptions', 'lastValidTag', 'SavedVisible', 'UsedByGUIData_m', 'GUIOnScreen'};
            appVars = rmfield(appVars, metadataFields);
        end
    end
end