function spc_selectAllRois()
    global spc
    global gui
    
    spc.roipoly = spc.project * 0;

    fullMask = spc.roipoly;
    for i = 1:length(gui.spc.figure.roiB)
        hA = gui.spc.figure.roiA(i);
        hB = gui.spc.figure.roiB(i);
        hC = gui.spc.figure.roiC(i);

        if ~ishandle(hA) || ~ishandle(hB) || ~ishandle(hC)
            continue;
        end

        if ~isa(hA, 'matlab.graphics.primitive.Rectangle')
            lineX = get(hA, 'XData');
            lineY = get(hA, 'YData');

            imgSize = size(spc.project);
            roiMask = roipoly([1 imgSize(1)], [1 imgSize(2)], spc.project, lineX, lineY);

            fullMask = fullMask | roiMask;
            
            set(hA, 'color', 'red');
            set(hB, 'color', 'red');
            set(hC, 'color', 'red');
        end
    end

    spc.roipoly = fullMask;

    Xlim1 = get(gui.spc.figure.projectAxes, 'Xlim');
    Ylim1 = get(gui.spc.figure.projectAxes, 'Ylim');
    siz2 = Ylim1(2) - Ylim1(1);
    siz3 = Xlim1(2) - Xlim1(1);

    spc_roi = [1, 1, siz3, siz2];
    set(gui.spc.figure.roi, 'Position', spc_roi);
    set(gui.spc.figure.mapRoi, 'Position', spc_roi);

    spc_redrawSetting(1);
end