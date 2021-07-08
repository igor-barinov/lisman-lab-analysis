classdef SPCPolylineMenu
    methods (Static)
        function MakeSpatialProfile()
        %% POLYLINE -> MAKE SPATIAL PROFILE -----------------------------------------------------------------------
        %
            global gui;
            figure(gui.spc.figure.project);

            spc_makepolyLines();
        end
        
        function Polylines()
        %% POLYLINE -> POLYLINES ----------------------------------------------------------------------------------
        %
            global spc;
            fn = spc.filename;
            fn = [fn, '_ROI2'];
            spc_DendriteAnalysis(fn);
        end
    end
end