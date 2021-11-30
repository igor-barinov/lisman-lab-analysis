function spc_loadROI2(basename, filepath, fileNum)
global spc gui fitsave;

spc_recoverRois; %nicko
    savedData = load(filepath);
    structField = [basename, '_ROI2'];
    fitParamsAreSaved = gui.spc.spc_main.Saved.Value;
    if fitParamsAreSaved && isfield(savedData.(structField), 'fitsave')
        fitsave = savedData.(structField).fitsave;
        try
            spc.fit(gui.spc.proChannel).beta0 = fitsave(fileNum).beta0;
            spc.fit(gui.spc.proChannel).fixtau = fitsave(fileNum).fixtau;
            spc.fit(gui.spc.proChannel).range = fitsave(fileNum).range;
            spc.fit(gui.spc.proChannel).lutlim = fitsave(fileNum).lutlim;
            spc.fit(gui.spc.proChannel).lifetime_limit = fitsave(fileNum).lifetime_limit;
        catch
            msgbox('File was not analyzed, current fit parameteres are used', 'replace');
        end
%           spc_estimate_bg;%nicko
        try
            set(gui.spc.figure.projectLowerlimit, 'String', fitsave(fileNum).projectLim{1});
            set(gui.spc.figure.projectUpperlimit, 'String', fitsave(fileNum).projectLim{2});
            set(gui.spc.figure.redLowerlimit, 'String', fitsave(fileNum).scanimgLim{1});
            set(gui.spc.figure.redUpperlimit, 'String', fitsave(fileNum).scanimgLim{2});
            set(gui.spc.figure.LutLowerlimit , 'String', fitsave(fileNum).lutlim(1));
            set(gui.spc.figure.LutUpperlimit , 'String', fitsave(fileNum).lutlim(2));
            set(gui.spc.figure.lifetimeUpperlimit, 'String', num2str(spc.fit(gui.spc.proChannel).lifetime_limit(1)));
            set(gui.spc.figure.lifetimeLowerlimit, 'String', num2str(spc.fit(gui.spc.proChannel).lifetime_limit(2)));
%             set(gui.spc.figure.LutLowerlimit, 'String', num2str(spc.fit(gui.spc.proChannel).lutlim(1)));
%             set(gui.spc.figure.LutUpperlimit, 'String', num2str(spc.fit(gui.spc.proChannel).lutlim(2)));
            set(gui.spc.spc_main.spc_fitstart, 'String', num2str(round(spc.fit(gui.spc.proChannel).range(1)*spc.datainfo.psPerUnit/100)/10));
            set(gui.spc.spc_main.spc_fitend, 'String', num2str(round(spc.fit(gui.spc.proChannel).range(2)*spc.datainfo.psPerUnit/100)/10));
        catch
            warning('off', 'backtrace');
            warning('Project and Scanimage limits were not found, using automatic values');
            warning('on', 'backtrace');

            set(gui.spc.figure.projectAuto, 'Value', 1);
            set(gui.spc.figure.redAuto, 'Value', 1);
        end
    end
      spc_estimate_bg;%nicko
%          set(gui.spc.spc_main.spc_fitstart, 'String', num2str(round(spc.fit(gui.spc.proChannel).range(1)*spc.datainfo.psPerUnit/100)/10));
%     set(gui.spc.spc_main.spc_fitend, 'String', num2str(round(spc.fit(gui.spc.proChannel).range(2)*spc.datainfo.psPerUnit/100)/10));
%     
%     set(gui.spc.figure.lifetimeUpperlimit, 'String', num2str(spc.fit(gui.spc.proChannel).lifetime_limit(1)));
%     set(gui.spc.figure.lifetimeLowerlimit, 'String', num2str(spc.fit(gui.spc.proChannel).lifetime_limit(2)));
%     set(gui.spc.figure.LutLowerlimit, 'String', num2str(spc.fit(gui.spc.proChannel).lutlim(1)));
%     set(gui.spc.figure.LutUpperlimit, 'String', num2str(spc.fit(gui.spc.proChannel).lutlim(2)));

end