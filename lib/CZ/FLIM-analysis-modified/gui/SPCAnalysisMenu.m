classdef SPCAnalysisMenu
    methods (Static)
        function Smoothing()
        %% ANALYSIS -> SMOOTHING ----------------------------------------------------------------------------------
        %
            spc_smooth();
        end
        
        function Binning()
        %% ANALYSIS -> BINNING ------------------------------------------------------------------------------------
        %
            spc_binning();
        end
        
        function AverageMultipleImages()
        %% ANALYSIS -> AVERAGE MULTIPLE IMAGES --------------------------------------------------------------------
        %
            spc_averageMultipleImages();
        end
        
        function FrameCalcRois()
        %% ANALYSIS -> FRAMES -> FRAME CALCROIS -------------------------------------------------------------------
        %
            spc_calc_timeCourseFromStack();
        end
        
        function FrameCalcRoisCurrentFrame()
        %% ANALYSIS -> FRAMES -> FRAME CALCROIS (CURRENT FRAME) ---------------------------------------------------
        %
            global gui;

            slicesS = get(gui.spc.spc_main.spc_page, 'String');
            slices = str2num(slicesS);
            spc_calc_timeCourseFromStack(slices);
            set(gui.spc.spc_main.spc_page, 'String', slicesS);
            spc_redrawSetting(1);
            spc_updateMainStrings();
        end
        
        function AlignFrames()
        %% ANALYSIS -> FRAMES -> ALIGN FRAMES ---------------------------------------------------------------------
        %
            global gui;
            slicesS = get(gui.spc.spc_main.spc_page, 'String');
            spc_alignFrames();
            set(gui.spc.spc_main.spc_page, 'String', slicesS);
            spc_redrawSetting(1);
            spc_updateMainStrings;
        end
        
        function TemporalFilter()
        %% ANALYSIS -> FRAMES -> TEMPORAL FILTER ------------------------------------------------------------------
        %
            spc_filterFrames();
        end
        
        function UncagingTriggeredAverage()
        %% ANALYSIS -> FRAMES -> UNCAGING TRIGGERED AVERAGE -------------------------------------------------------
        %
            spc_frames_uncagingTAverage();
        end
    end
end