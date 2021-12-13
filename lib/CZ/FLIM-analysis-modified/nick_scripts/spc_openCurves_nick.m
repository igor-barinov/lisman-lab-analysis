function spc_openCurves(fname)
global spc gui fitsave;

% loadbar = waitbar(1, 'Opening file...');
% pause (0.5)
% close (loadbar)
no_lastProject = 0;
try
    spc.lastProject = spc.project;
catch
    no_lastProject = 1;
end

if ~ischar(fname)
    filenumber1 = fname;
    [filepath, basename, ~, ~, ~, ext1] = spc_AnalyzeFilename(spc.filename); %Takes info from pre-existing file.
    fname = sprintf('%s%s%03d%s', filepath, basename, filenumber1, ext1); %???
    
else
    [filepath, basename, filenumber, ~, ~, ext1] = spc_AnalyzeFilename(fname);
    fname = sprintf('%s%s%03d%s', filepath, basename, filenumber, ext1); %???
end

% f=waitbar(0.25,'Reading SPC file...');%nicko
% close (f)
disp ('Found SPC file...')%nicko
if ~exist(fname, 'file')
    disp('No such file (spc_openCurves L39)');
    return;
end


if contains(fname, '.sdt')
    error = spc_readdata(fname);
elseif contains(fname, '.mat')
    load(fname);
    disp ('Found SPC.mat file...')%nicko
    error = 0;
elseif contains(fname, '.tif')
    error = spc_loadTiff(fname);
    disp ('Found SPC.tif file...')%nicko
end
spc.switches.redImg = 0;

if ~error
    spc_maxProc_offLine;
    spc.switches.noSPC = 0;
end

if error == 2
    spc.switches.noSPC = 1;
end

if ~error
    roiP = get(gui.spc.figure.mapRoi, 'position');
    
    if roiP(3)<=1 || roiP(4) <= 1 || (roiP(1)+roiP(3)) >= spc.datainfo.scan_x || (roiP(2) + roiP(4)) >= spc.datainfo.scan_y/spc.datainfo.scan_rx
        spc_selectAll();
    end
    
end


filename = '';
[filepath, basename, filenumber, ~, spc1, ext1] = spc_AnalyzeFilename(fname);
if error == 2 %Not spc file.
    if contains(ext1, 'tif')
        filename = sprintf('%s%s%03d%s', filepath, basename, filenumber, ext1); %Tiff but nof spc file
    end
elseif ~error
    if spc1
        filepath = filepath(1:end-4);
        filename = sprintf('%s%s%03d%s', filepath, basename, filenumber, ext1); %Tiff and spc file.
    end
else
    
end

% f=waitbar(0.5,'Reading non SPC file...');
% pause (0.5)
% close (f)
disp ('Reading non SPC file...')%nicko
spc.switches.redImg = 0;
if exist(filename, 'file') == 2
    try
        im2_opentif(filename);
    catch
        spc.state.img.greenImg = 0;
        spc.state.img.redImg = 0;
    end
    if sum(size(spc.state.img.greenImg)) > 0
        spc.switches.redImg = 1;
    end
    if error == 2
        spc.filename = filename;
        spc.switches.noSPC = 1;
        spc.project = spc.state.img.greenMax;
        spc.size = [1, size(spc.project)];
    end
end

% IB 11/9/20,
[filepath, basename, fileNum, ~, ~] = spc_AnalyzeFilename(spc.filename);
savedFile = fullfile(filepath, [basename, '_ROI2.mat']);
% f=waitbar(0.5, 'Reading ROI2 file...');
% pause (0.5)
% close (f)
disp ('Reading ROI2 file...')%nicko
try
    spc_loadROI2(basename, savedFile, fileNum);
%     no_lastProject=1; %nicko
catch
    warning('off', 'backtrace');
    warning('Could not load ROI2 file');
    warning('on', 'backtrace');
end

spc_redrawSetting(1);

if ~no_lastProject
    bg = 0;
    if isfield(gui.spc.figure, 'roiB')
        nRoi = length(gui.spc.figure.roiB);
    else
        nRoi = 0;
    end
    
    if nRoi > 0
        if ishandle(gui.spc.figure.roiB(1))
            ROI = get(gui.spc.figure.roiB(1), 'Position');
            
            theta = (0:1/20:1)*2*pi;
            xr = ROI(3)/2;
            yr = ROI(4)/2;
            xc = ROI(1) + ROI(3)/2;
            yc = ROI(2) + ROI(4)/2;
            x1 = round(sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*cos(theta) + xc);
            y1 = round(sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*sin(theta) + yc);
            siz = spc.size;
            ROIreg = roipoly(ones(siz(2), siz(3)), x1, y1);
            F_int = spc.lastProject(ROIreg);
            bg = mean(F_int);
        else
            bg = 0;
        end
        prj1 = spc.project-bg;
        prj2 = spc.lastProject-bg;
        xc = xcorr2(prj1(8:end-8,8:end-8), prj2(8:end-8,8:end-8));
        [~, pos] = max(xc(:));
        siz = size(xc);
        cent = (1+siz)/2;
        shift = [ceil(pos/siz(1))-cent(1), mod(pos, siz(2))-cent(2)];
        if sum(shift) > cent/8
            shift = 0;
        end
        spc.switches.spc_roi = {};
        for i = 1:nRoi
            if ishandle(gui.spc.figure.roiB(i))
                if strcmp(get(gui.spc.figure.roiB(i), 'Type'), 'rectangle')
                    spc.switches.spc_roi{i} = get(gui.spc.figure.roiB(i), 'Position');
                    saveRoi = spc.switches.spc_roi{i};
                    spc.switches.spc_roi{i}(1:2) = spc.switches.spc_roi{i}(1:2) + shift;
                    if spc.switches.spc_roi{i}(1) < 0 || spc.switches.spc_roi{i}(2) < 0 ...
                            || spc.switches.spc_roi{i}(1)+spc.switches.spc_roi{i}(3) > size(spc.project, 1) ...
                            || spc.switches.spc_roi{i}(2)+spc.switches.spc_roi{i}(4) > size(spc.project, 2)
                        spc.switches.spc_roi{i} = saveRoi;
                    end
                    set(gui.spc.figure.roiA(i), 'Position', spc.switches.spc_roi{i});
                    set(gui.spc.figure.roiB(i), 'Position', spc.switches.spc_roi{i});
                    set(gui.spc.figure.roiC(i), 'Position', spc.switches.spc_roi{i});
                    textRoi = spc.switches.spc_roi{i}(1:2)-[2,2];
                    set(gui.spc.figure.textA(i), 'Position', textRoi);
                    set(gui.spc.figure.textB(i), 'Position', textRoi);
                    set(gui.spc.figure.textC(i), 'Position', textRoi);
                elseif strcmp(get(gui.spc.figure.roiB(i), 'Type'), 'line')
                    xi = get(gui.spc.figure.roiB(i), 'XData') + shift(1);
                    yi = get(gui.spc.figure.roiB(i), 'YData') + shift(2);
                    spc.switches.spc_roi{i} = [xi(:), yi(:)];
                    set(gui.spc.figure.roiA(i), 'XData', xi);
                    set(gui.spc.figure.roiA(i), 'YData', yi);
                    set(gui.spc.figure.roiB(i), 'XData', xi);
                    set(gui.spc.figure.roiB(i), 'YData', yi);
                    set(gui.spc.figure.roiC(i), 'XData', xi); % IB fix 10/17/20
                    set(gui.spc.figure.roiC(i), 'YData', yi); % IB fix 10/17/20
                    textRoi = [xi(1)-2, yi(1)-2];
                    set(gui.spc.figure.textA(i), 'Position', textRoi);
                    set(gui.spc.figure.textB(i), 'Position', textRoi);
                    set(gui.spc.figure.textC(i), 'Position', textRoi);
                end
                
                
            end
        end
        
    end
    
    if isfield(gui.spc.figure, 'polyRoi')
        if ishandle(gui.spc.figure.polyRoi{1})
            nPoly = length(gui.spc.figure.polyRoi);
        else
            nPoly = 0;
        end
    else
        nPoly = 0;
    end
    if nPoly > 0
        if nRoi == 0
            prj1 = spc.project-bg;
            prj2 = spc.lastProject-bg;
            xc = xcorr2(prj1(8:end-8,8:end-8), prj2(8:end-8,8:end-8));
            [~, pos] = max(xc(:));
            siz = size(xc);
            cent = (siz)/2;
            shift = [ceil(pos/siz(1))-cent(1), mod(pos, siz(2))-cent(2)];
            if sum(shift) > cent/8
                shift = 0;
            end
        end
        x = zeros(1,length(gui.spc.figure.polyRoi));
        y = zeros(1,length(gui.spc.figure.polyRoi));
        for i=1:length(gui.spc.figure.polyRoi)
            roiPos = get(gui.spc.figure.polyRoi{i}, 'Position');
            roiPos(1:2) = roiPos(1:2)+shift;
            set(gui.spc.figure.polyRoi{i}, 'Position', roiPos);
            set(gui.spc.figure.polyRoiB{i}, 'Position', roiPos);
            x(i) = roiPos(1)+roiPos(3)/2;
            y(i) = roiPos(2)+roiPos(4)/2;
        end
        
        xx = get(gui.spc.figure.polyLine, 'XData');
        yy = get(gui.spc.figure.polyLine, 'YData');
        set(gui.spc.figure.polyLine, 'XData', xx+shift(1), 'YData', yy+shift(2));
        set(gui.spc.figure.polyLineB, 'XData', xx+shift(1), 'YData', yy+shift(2));
    end
end %LAST_PROJECT

