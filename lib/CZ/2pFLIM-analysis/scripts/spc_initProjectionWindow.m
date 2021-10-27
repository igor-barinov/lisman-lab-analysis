function spc_initProjectionWindow(screenSize)
    global gui;

    fig1_pos = [screenSize(3)-400     400        360         300];
    gui.spc.figure.project = figure;
    set(gui.spc.figure.project, 'Units', 'Pixels');
    set(gui.spc.figure.project, 'MenuBar', 'Figure');
    set(gui.spc.figure.project, 'Position', fig1_pos, 'name', 'Projection', 'Tag', 'spc_analysis');
    roi_context = uicontextmenu;
    gui.spc.figure.projectAxes = axes('Position', [0.1300    0.1100    0.6626    0.8150]);
    gui.spc.figure.projectImage = image(zeros(128,128), 'CDataMapping', 'scaled', 'UIContextMenu', roi_context);
    spc_add_to_menu(roi_context);

    %set axes properties.
    set(gui.spc.figure.projectAxes, 'XTick', [], 'YTick', []);
    %set(gui.spc.figure.projectAxes, 'CLim', [1,spc.switches.threshold]);
    %draw default roi in Fig1.
    roi_pos = [1,1,50,50];
    gui.spc.figure.roi = rectangle('position', roi_pos, 'ButtonDownFcn', 'spc_dragRoi', 'EdgeColor', [1,1,1]);
    %gui.spc.figure.ptojectColorbar = colorbar;
    colormap('gray');
    gui.spc.figure.projectColorbar = axes('Position', [0.82, 0.11, 0.05, 0.8150]);
    %%%%%%%%%%%%%%%%%%%%%%%%
    scale = 64:-1:1;
    %
    image(scale(:)); colormap('jet');
    set(gui.spc.figure.projectColorbar, 'XTick', [], 'box', 'off', 'Ytick', []);
    set(gui.spc.figure.projectColorbar, 'YAxisLocation', 'right', 'YTickLabel', []);
    gui.spc.figure.projectUpperlimit = uicontrol('Style', 'edit', 'String', '1', ...
        'Unit', 'normalized', 'Position', [0.88, 0.9, 0.1, 0.05], 'Callback', 'spc_redrawSetting(0)');
    gui.spc.figure.projectLowerlimit = uicontrol('Style', 'edit', 'String', '0', ...
        'Unit', 'normalized', 'Position', [0.88, 0.1, 0.1, 0.05], 'Callback', 'spc_redrawSetting(0)');
    gui.spc.figure.projectAuto = uicontrol ('Style', 'checkbox', 'Unit', 'normalized', ...
        'Position', [0.82, 0.02, 0.3, 0.05], 'String', 'Auto', 'Callback', ...
        'spc_redrawSetting', 'BackgroundColor', [0.8,0.8,0.8], 'Value', 1);
    gui.spc.figure.proChannel(1) = uicontrol ('Style', 'radiobutton', 'Unit', 'normalized', ...
        'Position', [0.02, 0.01, 0.2, 0.07], 'String', 'Ch1', 'value', 1, 'Callback', ...
        'global gui;gui.spc.proChannel=1;spc_switchChannel', 'BackgroundColor', [0.8,0.8,0.8]);
    gui.spc.figure.proChannel(2) = uicontrol ('Style', 'radiobutton', 'Unit', 'normalized', ...
        'Position', [0.2, 0.01, 0.2, 0.07], 'String', 'Ch2', 'value', 0, 'Callback', ...
        'global gui;gui.spc.proChannel=2;spc_switchChannel', 'BackgroundColor', [0.8,0.8,0.8]);
    gui.spc.figure.proChannel(3) = uicontrol ('Style', 'radiobutton', 'Unit', 'normalized', ...
        'Position', [0.4, 0.01, 0.2, 0.07], 'String', 'Ch3', 'Callback', ...
        'global gui;gui.spc.proChannel=3;spc_switchChannel', 'BackgroundColor', [0.8,0.8,0.8]);
end