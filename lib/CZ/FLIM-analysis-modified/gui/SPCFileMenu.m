classdef SPCFileMenu
    methods (Static)
        function Open()
        %% FILE -> OPEN -------------------------------------------------------------------------------------------
        %
            global fitsave;
            [fname,pname] = uigetfile('*.sdt;*.mat;*.tif','Select spc-file');
            if ~isequal(fname, 0) && ~isequal(pname, 0) % if not cancel
                cd (pname);
                filestr = [pname, fname];
                if exist(filestr, 'file') == 2
                        fitsave = []; % IB fix 11/15/20
                        spc_openCurves(filestr);
                end
                spc_updateMainStrings();
            end
        end
        
        function SaveTifMovieAs()
        %% FILE -> OPEN -------------------------------------------------------------------------------------------
        %
            spc_makeMovieFromFrames();
        end
    end
end