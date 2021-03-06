function spc_openCurves(fname)
global spc
global gui
global fitsave

no_limit = 0;

% no_fit = 0;
% try
%     save_fit = spc.fit;
% catch
%     no_fit = 1;
%     %disp('error')
% end

no_lastProject = 0;
try
    spc.lastProject = spc.project;
catch
    no_lastProject = 1;
end

if ~ischar(fname)
    filenumber1 = fname;
    [filepath, basename, filenumber, max1, spc1, ext1] = spc_AnalyzeFilename(spc.filename); %Take info from pre-existing file.
    fname = sprintf('%s%s%03d%s', filepath, basename, filenumber1, ext1); %???

else
    [filepath, basename, filenumber, max1, spc1, ext1] = spc_AnalyzeFilename(fname);
    fname = sprintf('%s%s%03d%s', filepath, basename, filenumber, ext1); %???
end

disp(['Reading SPC.  ', fname]);

if ~exist(fname)
    disp('No such file (spc_openCurves L39)');
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp (['Reading.. ', fname]);
if strfind(fname, '.sdt')
    error = spc_readdata(fname);
elseif strfind(fname, '.mat')
    load(fname);
    error = 0;
elseif strfind(fname, '.tif')
    error = spc_loadTiff (fname);
end
spc.switches.redImg = 0;

if ~error
    spc_maxProc_offLine;
    spc.switches.noSPC = 0;
end

if error == 2
    spc.switches.noSPC = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~error
    % 
%     if ~no_fit
%         spc.fit = save_fit;
%     end

    roiP = get(gui.spc.figure.mapRoi, 'position');
    
    if roiP(3)<=1 || roiP(4) <= 1 || (roiP(1)+roiP(3)) >= spc.datainfo.scan_x || (roiP(2) + roiP(4)) >= spc.datainfo.scan_y/spc.datainfo.scan_rx
        spc_selectAll;
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%

filename = '';
[filepath, basename, filenumber, max1, spc1, ext1] = spc_AnalyzeFilename(fname);
if error == 2 %Not spc file.
    if strfind(ext1, 'tif')
        filename = sprintf('%s%s%03d%s', filepath, basename, filenumber, ext1); %Tif but nof spc file
    end
elseif ~error
    if spc1
        filepath = filepath(1:end-4);
        filename = sprintf('%s%s%03d%s', filepath, basename, filenumber, ext1); %Tif and spc file.
    end
else

end
disp(['Reading.not SPC', filename]);

spc.switches.redImg = 0;
if exist(filename) == 2
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

if exist(savedFile) == 2 % ROI2 file exists
    disp(['Reading ROI2', savedFile]);
    savedData = load(savedFile);
    structField = [basename, '_ROI2'];    
%         usecurrentParam = 1; %nicko temp fix
%      if usecurrentParam ==1 %nicko temp fix
      if isfield(savedData.(structField), 'fitsave') % fit was saved
        loadedFit = savedData.(structField).fitsave;        
        if isstruct(loadedFit) && ...
           isfield(loadedFit, 'beta0') && ...
           isfield(loadedFit, 'fixtau') && ...
           isfield(loadedFit, 'range') && ...
           isfield(loadedFit, 'lutlim') && ...
           isfield(loadedFit, 'lifetime_limit') && ...
           numel(loadedFit) >= fileNum && ...
           ~isempty(loadedFit(fileNum).beta0)
%             fitsave(fileNum).beta0= loadedFit(fileNum).beta0;
%             fitsave(fileNum).fixtau = loadedFit(fileNum).fixtau;
%           if fileNum <= length (fitsave)% if data analysed or missed
                fitsave= loadedFit; %nicko 11.10.20
                spc.fit(gui.spc.proChannel).beta0 = fitsave(fileNum).beta0;
                spc.fit(gui.spc.proChannel).fixtau = fitsave(fileNum).fixtau;
                spc.fit(gui.spc.proChannel).range = fitsave(fileNum).range;
                spc.fit(gui.spc.proChannel).lutlim = fitsave(fileNum).lutlim;
                spc.fit(gui.spc.proChannel).lifetime_limit = fitsave(fileNum).lifetime_limit;
                msgbox('Saved fitting param. have been loaded', 'replace');
        else
%           if fileNum >= length (fitsave)% if data analysed or missed 
            %disp('file was not analized , current fit parameteres are used');
                msgbox('file was not analized , current fit parameteres are used', 'replace');
        end 
      end
%      end          
   
%     if fileNum >= length (fitsave)% if data analysed or missed 
% %        if numUnsavedFit = max(0, fileNum - numel(fitsave)); % if file was not analysed; nicko
%            disp('file was not analized , current fit parameteres are used');
    
%       for i = 1:numUnsavedFit
%         defaultParams.beta0 = spc.fit(gui.spc.proChannel).beta0;
%         defaultParams.fixtau = spc.fit(gui.spc.proChannel).fixtau;
%         defaultParams.range = spc.fit(gui.spc.proChannel).range; %nicko 11.10.20 next4 line
%         defaultParams.lutlim = spc.fit(gui.spc.proChannel).lutlim;
%         defaultParams.lifetime_limit = spc.fit(gui.spc.proChannel).lifetime_limit;
%         %defaultParams.fixtau = spc.fit(gui.spc.proChannel).t_offset;
%         fitsave = [fitsave, defaultParams];%nicko 11.10.20
%        end  
    
%      if isempty(loadedFit(fileNum).beta0)  %nicko for not analyzed files?
%             defaultParams.beta0 = spc.fit(gui.spc.proChannel).beta0;
%             defaultParams.fixtau = spc.fit(gui.spc.proChannel).fixtau;
%             defaultParams.range = spc.fit(gui.spc.proChannel).range; %nicko 11.10.20 next4 line
%             defaultParams.lutlim = spc.fit(gui.spc.proChannel).lutlim;
%             defaultParams.lifetime_limit = spc.fit(gui.spc.proChannel).lifetime_limit;
% %         %defaultParams.fixtau = spc.fit(gui.spc.proChannel).t_offset;
%                 spc.fit(gui.spc.proChannel).beta0 = fitsave(fileNum).beta0;
%                 spc.fit(gui.spc.proChannel).fixtau = fitsave(fileNum).fixtau;
%                 spc.fit(gui.spc.proChannel).range = fitsave(fileNum).range;
%                 spc.fit(gui.spc.proChannel).lutlim = fitsave(fileNum).lutlim;
%                 spc.fit(gui.spc.proChannel).lifetime_limit = fitsave(fileNum).lifetime_limit;
% %     spc.fit(gui.spc.proChannel).t_offset = fitsave(fileNum).t_offset;           
% fitsave = [fitsave, defaultParams];%nicko 11.10.20
%            disp('file was not analized , current fit parameteres are used');
%      end
%     else
%     disp('Found saved fit, loading params...');
    
%                 spc.fit(gui.spc.proChannel).beta0 = fitsave(fileNum).beta0;
%                 spc.fit(gui.spc.proChannel).fixtau = fitsave(fileNum).fixtau;
%                 spc.fit(gui.spc.proChannel).range = fitsave(fileNum).range;
%                 spc.fit(gui.spc.proChannel).lutlim = fitsave(fileNum).lutlim;
%                 spc.fit(gui.spc.proChannel).lifetime_limit = fitsave(fileNum).lifetime_limit;
%     spc.fit(gui.spc.proChannel).t_offset = fitsave(fileNum).t_offset;
%     if fileNum >= length (fitsave)% if data analysed or missed 
%        if numUnsavedFit = max(0, fileNum - numel(fitsave)); % if file was not analysed; nicko
           
%     end
set(gui.spc.spc_main.spc_fitstart, 'String', num2str(round(spc.fit(gui.spc.proChannel).range(1)*spc.datainfo.psPerUnit/100)/10));
set(gui.spc.spc_main.spc_fitend, 'String', num2str(round(spc.fit(gui.spc.proChannel).range(2)*spc.datainfo.psPerUnit/100)/10));


 set(gui.spc.figure.lifetimeUpperlimit, 'String', num2str(spc.fit(gui.spc.proChannel).lifetime_limit(1)));
 set(gui.spc.figure.lifetimeLowerlimit, 'String', num2str(spc.fit(gui.spc.proChannel).lifetime_limit(2)));
 
 set(gui.spc.figure.LutLowerlimit, 'String', num2str(spc.fit(gui.spc.proChannel).lutlim(1)));
 set(gui.spc.figure.LutUpperlimit, 'String', num2str(spc.fit(gui.spc.proChannel).lutlim(2)));
        
else
      disp('ROI2 is not found');
end
% IB 11/9/20, end
%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
    
try
    spc_redrawSetting(1);
end
if ~no_lastProject
    bg = 0;
    if isfield(gui.spc.figure, 'roiB')
        nRoi = length(gui.spc.figure.roiB);
    else
        nRoi = 0;
    end

    if nRoi > 0
        if ishandle(gui.spc.figure.roiB(1));
            ROI = get(gui.spc.figure.roiB(1), 'Position');
            tagA = get(gui.spc.figure.roiB(1), 'Tag');
            RoiNstr = tagA(6:end);

            theta = [0:1/20:1]*2*pi;
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
        [val, pos] = max(xc(:));
        siz = size(xc);
        cent = (1+siz)/2;
        shift = [ceil(pos/siz(1))-cent(1), mod(pos, siz(2))-cent(2)];
        if sum(shift) > cent/8;
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

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
            [val, pos] = max(xc(:));
            siz = size(xc);
            cent = (siz)/2;
            shift = [ceil(pos/siz(1))-cent(1), mod(pos, siz(2))-cent(2)];
            if sum(shift) > cent/8;
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

    %     xx = [x(1):0.25:x(end)];
    %     yy = spline(x, y, xx);
        xx = get(gui.spc.figure.polyLine, 'XData');
        yy = get(gui.spc.figure.polyLine, 'YData');
        set(gui.spc.figure.polyLine, 'XData', xx+shift(1), 'YData', yy+shift(2));
        set(gui.spc.figure.polyLineB, 'XData', xx+shift(1), 'YData', yy+shift(2));
    end
end %LAST_PROJECT
%%%%%%%%%%%%%%%%%%%%%%%%%%%





