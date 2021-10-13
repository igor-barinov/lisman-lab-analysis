function spc_saveFitParams(fileNum)
    global spc gui fitsave;

    fitsave(fileNum).beta0 = spc.fit(gui.spc.proChannel).beta0;
    fitsave(fileNum).fixtau = spc.fit(gui.spc.proChannel).fixtau;
    fitsave(fileNum).range = spc.fit(gui.spc.proChannel).range;
    fitsave(fileNum).lutlim = spc.fit(gui.spc.proChannel).lutlim;
    fitsave(fileNum).lifetime_limit = spc.fit(gui.spc.proChannel).lifetime_limit;
    projectLow = get(gui.spc.figure.projectLowerlimit, 'String');
    projectUp = get(gui.spc.figure.projectUpperlimit, 'String');
    lifetimeLow = get(gui.spc.figure.lifetimeLowerlimit, 'String');
    lifetimeUp = get(gui.spc.figure.lifetimeUpperlimit, 'String');
    scanimgLow = get(gui.spc.figure.redLowerlimit, 'String');
    scanimgUp = get(gui.spc.figure.redUpperlimit, 'String');

    fitsave(fileNum).projectLim = {projectLow, projectUp};
    fitsave(fileNum).lifetimeLim = {lifetimeLow, lifetimeUp};
    fitsave(fileNum).scanimgLim = {scanimgLow, scanimgUp};
end