function spc_initLifetimeWindow(screenSize)
    global gui;
    
    fig2_pos = [screenSize(3)-400     50         360         250];
    
    gui.spc.figure.lifetime = figure;
    set(gui.spc.figure.lifetime, 'Position', fig2_pos, 'name', 'Lifetime', 'Tag', 'spc_analysis');
    gui.spc.figure.lifetimeAxes = axes;
    set(gui.spc.figure.lifetimeAxes, 'Position', [0.15, 0.37, 0.8, 0.57], 'XTick', []);
    gui.spc.figure.lifetimePlot = plot(1:64, zeros(64,1));
    hold on;
    gui.spc.figure.fitPlot = plot(1:64, zeros(64, 1));
    xlabel('');
    ylabel('Photon');
    gui.spc.figure.residual = axes;
    set(gui.spc.figure.residual, 'position', [0.15, 0.15, 0.8, 0.18]);
    gui.spc.figure.residualPlot = plot(1:64, zeros(64, 1));
    xlabel('Lifetime (ns)');
    ylabel('Residuals');
end