function spc_selectAll()
    global spc
    global gui

    if isfield(spc, 'roipoly')
        spc.roipoly = spc.project*0 + 1;    
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