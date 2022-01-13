function spc_add_to_menu(roi_context)
    item1 = uimenu(roi_context, 'Label', 'make new roi', 'Callback', 'spc_makeRoi');
    item2 = uimenu(roi_context, 'Label', 'select all', 'Callback', 'spc_selectAll');
    item2 = uimenu(roi_context, 'Label', 'select all rois', 'Callback', 'spc_selectAllRois');
    item8 = uimenu(roi_context, 'Label', 'make a mask', 'Callback', 'spc_selectRoi');
    item9 = uimenu(roi_context, 'Label', 'log-scale', 'Callback', 'spc_logscale');
    item10 = uimenu(roi_context, 'Label', 'poly-lines', 'Callback', 'spc_makepolyLines');
    item11 = uimenu(roi_context, 'Label', 'delete poly-lines', 'Callback', 'spc_deletepolyLines');
    item12 = uimenu(roi_context, 'Label', 'calculate poly-lines', 'Callback', 'spc_calcpolyLines(1)');
    dlgstr = 'a = inputdlg(''Input'', '''', 1, {num2str(spc.switches.polyline_radius)});';
    dlgstr = [dlgstr, 'global spc; spc.switches.polyline_radius=str2num(a{1});spc_polyDrag(0);'];
    item13 = uimenu(roi_context, 'Label', 'set raidius of poly-line ROIs', 'Callback', dlgstr);
end