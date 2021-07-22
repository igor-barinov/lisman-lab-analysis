function spc_drawInit
    global spc gui;

    delete(findobj('Tag', 'spc_analysis'));
    ScSize = get(0, 'ScreenSize');
    
    spc_initGlobalParams();
    spc_initProjectionWindow(ScSize);
    spc_initLifetimeWindow(ScSize);
    spc_initLifetimeMapWindow(ScSize);
    spc_initScanImageWindow(ScSize);
    
    gui.spc.scanChannel = 2;
    spc_main();
    spc_selectAll();


    if isfield(spc, 'imageMod')
        try
            spc_redrawSetting(1);
        catch
            disp('Error: no images produced (function spc_drawInit)');
        end
    end
end
