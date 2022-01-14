function spc_selectAll()
    global spc
    global gui

    if isfield(spc, 'roipoly')
        spc.roipoly = spc.project*0 + 1;    
    end
    
    if isfield(gui.spc.figure, 'roiB')
        for i = 1:length(gui.spc.figure.roiB)
            hA = gui.spc.figure.roiA(i);
            hB = gui.spc.figure.roiB(i);
            hC = gui.spc.figure.roiC(i);

            if ~ishandle(hA) || ~ishandle(hB) || ~ishandle(hC)
                continue;
            end

            if ~isa(hA, 'matlab.graphics.primitive.Rectangle')            
                set(hA, 'color', 'cyan');
                set(hB, 'color', 'cyan');
                set(hC, 'color', 'cyan');
            end
        end
    end

    Xlim1 = get(gui.spc.figure.projectAxes, 'Xlim');
    Ylim1 = get(gui.spc.figure.projectAxes, 'Ylim');
    siz2 = Ylim1(2) - Ylim1(1);
    siz3 = Xlim1(2) - Xlim1(1);

    spc_roi = [1, 1, siz3, siz2];
    set(gui.spc.figure.roi, 'Position', spc_roi);
    set(gui.spc.figure.mapRoi, 'Position', spc_roi);

    spc_redrawSetting(1);
end