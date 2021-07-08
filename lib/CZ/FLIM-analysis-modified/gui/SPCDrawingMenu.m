classdef SPCDrawingMenu
    methods (Static)
        function RedrawLifetime()
        %% DRAWING -> REDRAW LIFETIME -----------------------------------------------------------------------------
        %
            spc_redrawSetting(1);
        end
        
        function Logscale()
        %% DRAWING -> LOGSCALE ------------------------------------------------------------------------------------
        %
            spc_logscale();
        end
        
        function LifetimeRange()
        %% DRAWING -> LIFETIME RANGE ------------------------------------------------------------------------------
        %
            twodialog();
        end
        
        function ShowAll()
        %% DRAWING -> SHOW ALL ------------------------------------------------------------------------------------
        %
            global gui;
            figure(gui.spc.figure.project);
            figure(gui.spc.figure.lifetime);
            figure(gui.spc.figure.lifetimeMap);
            figure(gui.spc.figure.scanImgF);
        end
        
        function RedrawAll()
        %% DRAWING -> REDRAW ALL ----------------------------------------------------------------------------------
        %
            spc_redrawSetting(1);
        end
    end
end