classdef SPCRoiMenu
    methods (Static)
        function RoiBackground()
        %% ROI -> ROI0 (BACKGROUND) -------------------------------------------------------------------------------
        %
            spc_makeRoiA(0);
        end
        
        function Roi1()
        %% ROI -> ROI1 --------------------------------------------------------------------------------------------
        %
            spc_makeRoiA(1);
        end
        
        function Roi2()
        %% ROI -> ROI2 --------------------------------------------------------------------------------------------
        %
            spc_makeRoiA(2);
        end
        
        function Roi3()
        %% ROI -> ROI3 --------------------------------------------------------------------------------------------
        %
            spc_makeRoiA(3);
        end
        
        function Roi4()
        %% ROI -> ROI4 --------------------------------------------------------------------------------------------
        %
            spc_makeRoiA(4);
        end
        
        function Roi5()
        %% ROI -> ROI5 --------------------------------------------------------------------------------------------
        %
            spc_makeRoiA(5);
        end
        
        function RoiMore()
        %% ROI -> ROIMORE -----------------------------------------------------------------------------------------
        %
            prompt = 'Roi Number:';
            dlg_title = 'Roi';
            num_lines= 1;
            def     = {'6'};
            answer  = inputdlg(prompt,dlg_title,num_lines,def);

            spc_makeRoiA(str2double(answer{1}));
        end
        
        function RecoverRoi()
        %% ROI -> RECOVER ROI -------------------------------------------------------------------------------------
        %
            spc_recoverRois();
        end
        
        function ArbitraryShapedRoi()
        %% ROI -> ARBITRARY SHAPED ROI ----------------------------------------------------------------------------
        %
            prompt = 'Roi Number:';
            dlg_title = 'Roi';
            num_lines= 1;
            def     = {'1'};
            answer  = inputdlg(prompt,dlg_title,num_lines,def);

            spc_makeRoiB(str2double(answer{1}));
        end
    end
end