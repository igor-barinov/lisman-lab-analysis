classdef SPCMainPanel
    methods (Static)
        function Initialize(handles)
        %% "spc_main" FIGURE --------------------------------------------------------------------------------------
        %
            global gui spc;
            range = round(spc.fit(gui.spc.proChannel).range.*spc.datainfo.psPerUnit/100)/10;
            set(handles.spc_fitstart, 'String', num2str(range(1)));
            set(handles.spc_fitend, 'String', num2str(range(2)));
            
            % set(handles.back_value, 'String', num2str(spc.fit(gui.spc.proChannel).background));
            %               ^^^^^ Doesnt exist
            
            % set(handles.filename, 'String', spc.filename);
            %               ^^^^^ Doesnt exist
            
            %set(handles.spc_page, 'String', num2str(spc.switches.currentPage));
            %                                         Doesnt exist ^^^^^^^^^
            
            %set(handles.slider1, 'Value', (spc.switches.currentPage-1)/100);
            %                                Doesnt exist ^^^^^^^^^
            
            spc_dispbeta();


            set(handles.fracCheck, 'Value', 0);
            set(handles.tauCheck, 'Value', 1);
            set(handles.greenCheck, 'Value', 1);
            set(handles.redCheck, 'Value', 1);
            set(handles.RatioCheck, 'Value', 0);
            set(handles.RecoverROI, 'Value', 1);
        end
        
        function ImageNumber(handles)
        %% "Image #" TEXTBOX --------------------------------------------------------------------------------------
        %
            global spc;
            [filepath, basename, ~, max] = spc_AnalyzeFilename(spc.filename);
            fileN = get(handles.File_N, 'String');
            next_filenumber_str = '000';
            next_filenumber_str ((end+1-length(fileN)):end) = num2str(fileN);
            if max == 0
                next_filename = [filepath, basename, next_filenumber_str, '.tif'];
            else
                next_filename = [filepath, basename, next_filenumber_str, '_max.tif'];
            end
            if exist(next_filename, 'file')
                spc_openCurves(next_filename);
            else
                disp([next_filename, ' not exist!']);
            end
            spc_updateMainStrings();
        end
        
        function OpenPrevImage()
        %% "Image <" BUTTON ---------------------------------------------------------------------------------------
        %
            spc_openprevious();
        end
        
        function OpenNextImage()
        %% "Image >" BUTTON ---------------------------------------------------------------------------------------
        %
            spc_opennext();
        end
        
        function CalcRois()
        %% "calcRois" BUTTON --------------------------------------------------------------------------------------
        %
            spc_calcRoi();
        end
        
        function CalcRoisBatch(handles)
        %% "calcRois Batch" BUTTON --------------------------------------------------------------------------------
        %
            global spc gui;
            spc.fit_eachtime = 1;%nicko
            spc.badFits = [];
            fromVal = str2double(get(handles.calcRoiFrom, 'String'));
            toVal = str2double(get(handles.calcRoiTo, 'String'));
            for i = fromVal : toVal
                RecoverROI=get(gui.spc.spc_main.RecoverROI, 'Value');
                spc_openCurves(i);
                if ~isempty(findobj('Tag', 'RoiA0'))
                    spc_calcRoi();
                end
                spc_auto(1);
            end
            
            if ~isempty(spc.badFits)
                errMsg = sprintf('The following images produced high residuals (>10) or failed:\n');
                for n = spc.badFits
                    errMsg = [errMsg, sprintf('\tImage %d\n', n)];
                end
                warndlg(errMsg, 'High Residuals', 'replace');
            end
            spc.fit_eachtime = 0;%nicko
        end
        
        function Channel1()
        %% "Ch1" RADIOBUTTON --------------------------------------------------------------------------------------
        %
            global gui
            gui.spc.proChannel = 1;
            spc_switchChannel();
        end
        
        function Channel2()
        %% "Ch2" RADIOBUTTON --------------------------------------------------------------------------------------
        %
            global gui;
            gui.spc.proChannel = 2;
            spc_switchChannel();
        end
        
        function Channel3()
        %% "Ch3" RADIOBUTTON --------------------------------------------------------------------------------------
        %
            global gui;
            gui.spc.proChannel = 3;
            spc_switchChannel;
        end
        
        function Slices()
        %% "Slices" TEXTBOX ---------------------------------------------------------------------------------------
        %
            global spc gui;

            current = spc.page;
            spc.page = str2num(get(gui.spc.spc_main.spc_page, 'String'));

            if any(spc.page > length(spc.stack.image1))
                spc.page = current;
            end
            if any(spc.page < 1)
                spc.page = current;
            end
            spc.switches.currentPage = spc.page;

            spc_redrawSetting(1);
            set(gui.spc.spc_main.spc_page, 'String', num2str(spc.page));
            spc_updateMainStrings();
        end
        
        function SlicesFrom(handles)
        %% "From" SLIDER ------------------------------------------------------------------------------------------
        %
            global spc gui;
            current = spc.page;
            slider_value = get(handles.minSlider, 'Value');
            page = round(slider_value);


            if page > spc.stack.nStack
                page = spc.stack.nStack;
            end
            if page > max(spc.page)
                page = max(spc.page);
            end
            if page < 1
                page = 1;
            end
            spc.page = page:max(current);
            spc.switches.currentPage = spc.page;
            set(gui.spc.spc_main.spc_page, 'String', num2str(spc.page));
            spc_redrawSetting(1);


            spc_updateMainStrings();
        end
        
        function SlicesTo(handles)
        %% "To" SLIDER --------------------------------------------------------------------------------------------
        %
            global spc gui;

            current = spc.page;
            slider_value = get(handles.slider1, 'Value');
            page = round(slider_value);


            if page > spc.stack.nStack
                page = spc.stack.nStack;
            end
            if page < 1
                page = 1;
            end
            if page < min(spc.page)
                page = min(spc.page);
            end
            spc.page = min(current):page;
            spc.switches.currentPage = spc.page;
            set(gui.spc.spc_main.spc_page, 'String', num2str(spc.page));
            spc_redrawSetting(1);

            spc_updateMainStrings();
        end
        
        function AverageProjection(hObject)
        %% "Average projection" RADIOBUTTON -----------------------------------------------------------------------
        %
            global spc gui;

            spc.switches.maxAve = get(hObject, 'value');
            set(gui.spc.figure.redAuto, 'Value', 1);
            spc_redrawSetting(1);
        end
        
        function OnePageLeft()
        %% "Slice <" BUTTON ---------------------------------------------------------------------------------------
        %
            global spc gui;

            if length(spc.page) == spc.stack.nStack
                spc.page = 1;
            else
                spc.page = sort(spc.page-1);
            end

            if spc.page(1) < 1
                if length(spc.page) > 1
                    for i=1:length(spc.page)-1
                        spc.page(i) = spc.page(i+1);
                    end

                    spc.page = spc.page(1:end-1);
                else
                    spc.page = 1;
                end
            end


            set(gui.spc.spc_main.spc_page, 'String', num2str(spc.page));
            spc_redrawSetting(1);

            spc_updateMainStrings();
        end
        
        function TenPagesLeft()
        %% "Slice <<" BUTTON --------------------------------------------------------------------------------------
        %
            global spc gui;

            if length(spc.page) == spc.stack.nStack
                spc.page = 1;
            else
                spc.page = sort(spc.page-10);
            end

            if spc.page(1) < 1
                if length(spc.page) > 1
                    for i=1:length(spc.page)-1
                        spc.page(i) = spc.page(i+1);
                    end

                    spc.page = spc.page(1:end-1);
                else
                    spc.page = 1;
                end
            end


            set(gui.spc.spc_main.spc_page, 'String', num2str(spc.page));
            spc_redrawSetting(1);

            spc_updateMainStrings();
        end
        
        function OnePageRight()
        %% "Slice >" BUTTON ---------------------------------------------------------------------------------------
        %
            global spc gui;

            if length(spc.page) == spc.stack.nStack
                spc.page = 1;
            else
                spc.page = sort(spc.page+1);
            end

            if spc.page(end) > spc.stack.nStack
                if length(spc.page) > 1
                    spc.page = spc.page(1:end-1);
                else
                    spc.page =spc.stack.nStack;
                end
            end

            set(gui.spc.spc_main.spc_page, 'String', num2str(spc.page));
            spc_redrawSetting(1);

            spc_updateMainStrings();
        end
        
        function TenPagesRight()
        %% "Slice >>" BUTTON --------------------------------------------------------------------------------------
        %
            global spc gui;

            if length(spc.page) == spc.stack.nStack
                spc.page = 1;
            else
                spc.page = sort(spc.page+10);
            end


            if spc.page(end) > spc.stack.nStack
                if length(spc.page) > 1
                    spc.page = spc.page(1:end-1);
                else
                    spc.page =spc.stack.nStack;
                end
            end

            set(gui.spc.spc_main.spc_page, 'String', num2str(spc.page));
            spc_redrawSetting(1);

            spc_updateMainStrings();
        end
    end
end