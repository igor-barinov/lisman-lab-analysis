function spc_initLifetimeMapWindow(screenSize)
    global gui;
    
    fig3_pos = [screenSize(3)-800, 50, 360, 300];

    gui.spc.figure.lifetimeMap = figure;
    set(gui.spc.figure.lifetimeMap, 'MenuBar', 'Figure');
    set(gui.spc.figure.lifetimeMap, 'Position', fig3_pos, 'name', 'LifetimeMap', 'Tag', 'spc_analysis');
    gui.spc.figure.lifetimeMapAxes = axes('Position', [0.1300    0.1100    0.6626    0.8150]);
    set(gui.spc.figure.lifetimeMap, 'Units', 'Pixels');
    roi_context3 = uicontextmenu;
    gui.spc.figure.lifetimeMapImage = image(zeros(128,128,3), 'CDataMapping', 'scaled', 'UIContextMenu', roi_context3);
    spc_add_to_menu(roi_context3);

    roi_pos = [1,1,50,50];
    set(gui.spc.figure.lifetimeMapAxes, 'XTick', [], 'YTick', []);
    gui.spc.figure.mapRoi=rectangle('position', roi_pos, 'EdgeColor', [1,1,1], 'ButtonDownFcn', 'spc_dragRoi');
    gui.spc.figure.lifetimeMapColorbar = axes('Position', [0.82, 0.11, 0.05, 0.8150]);
    scale = 64:-1:1;
    imRGB = spc_im2rgb(scale(:), [64, 1], 0);
    gui.spc.figure.lifetimeMapColorbarIm = image(imRGB);
    %colormap(jet);
    set(gui.spc.figure.lifetimeMapColorbar, 'XTick', []);
    set(gui.spc.figure.lifetimeMapColorbar, 'YAxisLocation', 'right', 'YTick', [], 'box', 'off');
    gui.spc.figure.lifetimeUpperlimit = uicontrol('Style', 'edit', 'String', '2.4', ...
        'Unit', 'normalized', 'Position', [0.88, 0.9, 0.1, 0.05], 'Callback', 'spc_redrawSetting(0)');
    gui.spc.figure.lifetimeLowerlimit = uicontrol('Style', 'edit', 'String', '1.7', ...
        'Unit', 'normalized', 'Position', [0.88, 0.1, 0.1, 0.05], 'Callback', 'spc_redrawSetting(0)');
    gui.spc.figure.LUTtext = uicontrol('Style', 'text', 'String', 'LUT', ...
        'Unit', 'normalized', 'Position', [0.88, 0.6, 0.1, 0.05], 'BackgroundColor', [0.8,0.8,0.8]);
    gui.spc.figure.LutLowerlimit = uicontrol('Style', 'edit', 'String', '10', ...
        'Unit', 'normalized', 'Position', [0.88, 0.5, 0.1, 0.05], 'Callback', 'spc_redrawSetting(0)');
    gui.spc.figure.LutUpperlimit = uicontrol('Style', 'edit', 'String', '30', ...
        'Unit', 'normalized', 'Position', [0.88, 0.55, 0.1, 0.05], 'Callback', 'spc_redrawSetting(0)');
    gui.spc.figure.drawPopulation = uicontrol ('Style', 'checkbox', 'Unit', 'normalized', ...
        'Position', [0.05, 0.02, 0.3, 0.05], 'String', 'Draw population', 'Callback', ...
        'spc_redrawSetting(0)', 'BackgroundColor', [0.8,0.8,0.8]);
    gui.spc.figure.filterText = uicontrol ('Style', 'text', 'Unit', 'normalized', ...
        'Position', [0.55, 0.02, 0.3, 0.05], 'String', 'Smooth', 'Callback', ...
        'spc_redrawSetting(1)', 'BackgroundColor', [0.8,0.8,0.8]);
    gui.spc.figure.filter = uicontrol ('Style', 'edit', 'Unit', 'normalized', ...
        'Position', [0.75, 0.02, 0.1, 0.05], 'String', '1', 'Callback', ...
        'spc_redrawSetting(1)', 'BackgroundColor', [1,1,1]);

    gui.spc.figure.FLIMchannel(1) = uicontrol ('Style', 'radiobutton', 'Unit', 'normalized', ...
        'Position', [0.02, 0.01, 0.2, 0.07], 'String', 'Ch1', 'Callback', ...
        'global gui;gui.spc.proChannel=1;spc_switchChannel', 'BackgroundColor', [0.8,0.8,0.8]);
    gui.spc.figure.FLIMchannel(2) = uicontrol ('Style', 'radiobutton', 'Unit', 'normalized', ...
        'Position', [0.2, 0.01, 0.2, 0.07], 'String', 'Ch2', 'value', 1, 'Callback', ...
        'global gui;gui.spc.proChannel=2;spc_switchChannel', 'BackgroundColor', [0.8,0.8,0.8]);
    gui.spc.figure.FLIMchannel(3) = uicontrol ('Style', 'radiobutton', 'Unit', 'normalized', ...
        'Position', [0.4, 0.01, 0.2, 0.07], 'String', 'Ch3', 'Callback', ...
        'global gui;gui.spc.proChannel=3;spc_switchChannel', 'BackgroundColor', [0.8,0.8,0.8]);
end