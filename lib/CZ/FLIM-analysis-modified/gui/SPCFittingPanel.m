classdef SPCFittingPanel
    methods (Static)
        function FitWithSingle()
        %% "Fit with Single" BUTTON -------------------------------------------------------------------------------
        %
            spc_fitexpgauss();
            spc_redrawSetting(1);
        end
        
        function FitWithDouble()
        %% "Fit with Double" BUTTON -------------------------------------------------------------------------------
        %
            spc_fitexp2gauss();
            spc_redrawSetting(1);
        end
        
        function PlotCurrent()
        %% "plot current" BUTTON ----------------------------------------------------------------------------------
        %
            global spc gui;
            range = spc.fit(gui.spc.proChannel).range;
            lifetime = spc.lifetime(range(1):1:range(2));
            x = 1:1:length(lifetime);
            beta0 = spc_initialValue_double();

            %Drawing
            fit = exp2gauss(beta0, x);
            t = range(1):1:range(2);
            t = t*spc.datainfo.psPerUnit/1000;

            %Drawing
            spc_drawfit(t, fit, lifetime, gui.spc.proChannel);
            figure(gui.spc.figure.project);
            figure(gui.spc.figure.lifetime);
            figure(gui.spc.figure.lifetimeMap);
            figure(gui.spc.figure.scanImgF);
            spc_dispbeta();
        end
        
        function Timecourse()
        %% "Timecourse" BUTTON ------------------------------------------------------------------------------------
        %
            spc_auto(1);
        end
        
        function RedrawLifetime()
        %% "Redraw lifetime" BUTTON -------------------------------------------------------------------------------
        %
            global gui;

            spc_redrawSetting(1);
            figure(gui.spc.figure.project);
            figure(gui.spc.figure.lifetime);
            figure(gui.spc.figure.lifetimeMap);
            figure(gui.spc.figure.scanImgF);
            set(gui.spc.spc_main.spc_main, 'color',  [1, 1, 0.75]);
        end
        
        function Population1(hObject)
        %% "Population 1" TEXTBOX ---------------------------------------------------------------------------------
        %
            global spc gui;
            val1 = str2double(get(hObject, 'String'));
            spc.fit(gui.spc.proChannel).beta0(1) = val1;
            spc_dispbeta();
        end
        
        function Population2(hObject)
        %% "Population 2" TEXTBOX ---------------------------------------------------------------------------------
        %
            global spc gui;
            val1 = str2double(get(hObject, 'String'));
            spc.fit(gui.spc.proChannel).beta0(3) = val1;
            spc_dispbeta();
        end
        
        function Tau1(hObject)
        %% "tau1" TEXTBOX -----------------------------------------------------------------------------------------
        %
            global spc gui;
            val1 = str2double(get(hObject, 'String'));
            spc.fit(gui.spc.proChannel).beta0(2) = val1;
            spc_dispbeta();
        end
        
        function FixTau1(hObject)
        %% "Fix" (tau1) CHECKBOX ----------------------------------------------------------------------------------
        %
            global spc gui;
            spc.fit(gui.spc.proChannel).fixtau(2) = get(hObject, 'Value');
        end
        
        function Tau2(hObject)
        %% "tau2" TEXTBOX -----------------------------------------------------------------------------------------
        %
            global spc gui;
            val1 = str2double(get(hObject, 'String'));
            spc.fit(gui.spc.proChannel).beta0(4) = val1;
            spc_dispbeta();
        end
        
        function FixTau2(hObject)
        %% "Fix" (tau2) CHECKBOX ----------------------------------------------------------------------------------
        %
            global spc gui;
            spc.fit(gui.spc.proChannel).fixtau(4) = get(hObject, 'Value');
        end
        
        function DeltaPeakTime(hObject)
        %% "Delta peak time" TEXTBOX ------------------------------------------------------------------------------
        %
            global spc gui;
            val1 = str2double(get(hObject, 'String'));
            spc.fit(gui.spc.proChannel).beta0(5) = val1;
            spc_dispbeta();
        end
        
        function FixDeltaPeakTime(hObject)
        %% "Fix" (Delta peak time) CHECKBOX -----------------------------------------------------------------------
        %
            global spc gui;
            spc.fit(gui.spc.proChannel).fixtau(5) = get(hObject, 'Value');
        end
        
        function GaussianWidth(hObject)
        %% "Gaussian width" TEXTBOX -------------------------------------------------------------------------------
        %
            global spc gui;
            val1 = str2double(get(hObject, 'String'));
            spc.fit(gui.spc.proChannel).beta0(6) = val1;
            spc_dispbeta();
        end
        
        function FixGaussianWidth(hObject)
        %% "Fix" (Gaussian width) CHECKBOX ------------------------------------------------------------------------
        %
            global spc gui;
            spc.fit(gui.spc.proChannel).fixtau(6) = get(hObject, 'Value');
        end
        
        function EstimateBackground()
        %% "estimate" BUTTON --------------------------------------------------------------------------------------
        %
            spc_estimate_bg();
        end
        
        function FitStart()
        %% "Fit start (ns)" TEXTBOX -------------------------------------------------------------------------------
        %
            spc_redrawSetting(1);
        end
        
        function FitEnd()
        %% "Fit end (ns)" TEXTBOX ---------------------------------------------------------------------------------
        %
            spc_redrawSetting(1);
        end
        
        function FigureOffset()
        %% "Figure offset (ns)" TEXTBOX ---------------------------------------------------------------------------
        %
            spc_redrawSetting(1);
        end
        
        function AutoFigureOffset()
        %% "Auto" (Figure offset) BUTTON --------------------------------------------------------------------------
        %
            spc_adjustTauOffset();
        end
        
    end
end