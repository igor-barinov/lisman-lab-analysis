function spc_initScanImageWindow(screenSize)
    global gui;
    
    fig4_pos = [screenSize(3)-800     400        360         300];

    gui.spc.figure.scanImgF = figure;
    gui.spc.figure.scanImgA = axes('Position', [0.1300    0.1100    0.6626    0.8150]);
    set(gui.spc.figure.scanImgF, 'MenuBar', 'Figure');
    set(gui.spc.figure.scanImgF, 'Units', 'Pixels');
    set(gui.spc.figure.scanImgF, 'Position', fig4_pos, 'name', 'ScanImage', 'Tag', 'spc_analysis');
    gui.spc.figure.scanImg = image(zeros(128,128), 'CDataMapping', 'scaled');
    %set axes properties.
    gui.spc.figure.scanImgA = gca;
    set(gui.spc.figure.scanImgA, 'XTick', [], 'YTick', []);

    gui.spc.figure.redColorbar = axes('Position', [0.82, 0.11, 0.05, 0.8150]);
    scale = 64:-1:1;
    image(scale(:));
    set(gui.spc.figure.redColorbar, 'XTickLabel', []);
    set(gui.spc.figure.redColorbar, 'YAxisLocation', 'right', 'YTickLabel', []);
    gui.spc.figure.redUpperlimit = uicontrol('Style', 'edit', 'String', '1', ...
        'Unit', 'normalized', 'Position', [0.88, 0.9, 0.1, 0.05], 'Callback', 'spc_redrawSetting(0)');
    gui.spc.figure.redLowerlimit = uicontrol('Style', 'edit', 'String', '0', ...
        'Unit', 'normalized', 'Position', [0.88, 0.1, 0.1, 0.05], 'Callback', 'spc_redrawSetting(0)');
    gui.spc.figure.redAuto = uicontrol ('Style', 'checkbox', 'Unit', 'normalized', ...
        'Position', [0.82, 0.02, 0.3, 0.05], 'String', 'Auto', 'Callback', ...
        'spc_redrawSetting(0)', 'BackgroundColor', [0.8,0.8,0.8], 'Value', 1);
    gui.spc.figure.channel(1) = uicontrol ('Style', 'radiobutton', 'Unit', 'normalized', ...
        'Position', [0.02, 0.01, 0.2, 0.07], 'String', 'Ch1', 'Callback', ...
        'global gui;gui.spc.scanChannel=1;spc_redrawSetting(0)', 'BackgroundColor', [0.8,0.8,0.8]);
    gui.spc.figure.channel(2) = uicontrol ('Style', 'radiobutton', 'Unit', 'normalized', ...
        'Position', [0.2, 0.01, 0.2, 0.07], 'String', 'Ch2', 'value', 1, 'Callback', ...
        'global gui;gui.spc.scanChannel=2;spc_redrawSetting(0)', 'BackgroundColor', [0.8,0.8,0.8]);
    gui.spc.figure.channel(3) = uicontrol ('Style', 'radiobutton', 'Unit', 'normalized', ...
        'Position', [0.4, 0.01, 0.2, 0.07], 'String', 'Ch3', 'Callback', ...
        'global gui;gui.spc.scanChannel=3;spc_redrawSetting(0)', 'BackgroundColor', [0.8,0.8,0.8]);
    colormap('gray');
end