function spc_drawLifetimeMap()
    global spc gui;

    colormap1 = 1;
    %0: gray scale, 1: Rainbow, 2: Red and blue, 3: modified rainbow, 4: modified rainbow 2
    %Defined in spc_im2rb

    if spc.switches.imagemode == 0
        return;
    end

    calcPop = get(gui.spc.figure.drawPopulation, 'Value');

    range(1) = str2num(get(gui.spc.figure.lifetimeUpperlimit, 'String'));
    range(2) = str2num(get(gui.spc.figure.lifetimeLowerlimit, 'String'));

    LUTrange(2) = str2num(get(gui.spc.figure.LutUpperlimit, 'String'));
    LUTrange(1) = str2num(get(gui.spc.figure.LutLowerlimit, 'String'));
    if (LUTrange(1) >= 0 && LUTrange(2) >= 0) && LUTrange(2) > LUTrange(1)
        spc.fit(gui.spc.proChannel).lutlim = LUTrange;
    else
        set(gui.spc.figure.LutLowerlimit, 'String', num2str(spc.fit(gui.spc.proChannel).lutlim(1)));
        set(gui.spc.figure.LutUpperlimit, 'String', num2str(spc.fit(gui.spc.proChannel).lutlim(2)));
        LUTrange = spc.fit(gui.spc.proChannel).lutlim;
    end
    %
    spc.fit(gui.spc.proChannel).lutlim = LUTrange;
    spc.fit(gui.spc.proChannel).lifetime_limit = range;

    if calcPop
        if range(1) <= 1 && range(2) <= 1
            popLimit = range;
        else
            popLimit = [1,0];
        end
        if get(gui.spc.spc_main.fixtau1, 'Value') && get(gui.spc.spc_main.fixtau2, 'Value')
            spc.rgbLifetime = spc_drawPopulation (popLimit);
        else
            errordlg ('Fix tau1 and tau2, and then press Auto!');
            set(gui.spc.spc_main.pop_check, 'Value', 0);
            return;
        end
    else
        if range(1) > 1 || range(2) > 1
            spc.fit(gui.spc.proChannel).lifetime_limit = range;
        end
        
        spc_calcLifetimeMap();
        spc_makeRGBLifetimeMap(colormap1);
        %%0: gray scale, 1: Rainbow, 2: Red and blue, 3, modified rainbow, 4, modified rainbow 2
    end

    if spc.datainfo.scan_rx > 1
        spc.rgbLifetime = spc.rgbLifetime;
    end

    set(gui.spc.figure.lifetimeMapImage, 'CData', spc.rgbLifetime);
    scale = 64:-1:1;
    barRGB = spc_im2rgb(scale(:), [64, 1], colormap1);
    set(gui.spc.figure.lifetimeMapColorbarIm, 'CData', barRGB);

    if calcPop
        range = popLimit;
    else
        range = spc.fit(gui.spc.proChannel).lifetime_limit;
    end
    set(gui.spc.figure.lifetimeUpperlimit, 'String', num2str(range(1)));
    set(gui.spc.figure.lifetimeLowerlimit, 'String', num2str(range(2)));
end

