function spc_redrawSetting (flag)

global spc;
global gui;

if ~nargin
    flag = 1;
end
% 

if ~strcmp(spc.filename(end-2:end), 'sdt')
    spc_maxProc_offLine;
end

try 
    roi_pos = get(gui.spc.figure.roi, 'Position');
catch
    roi_pos = [1, 1, spc.size(3)-1, spc.size(2)-1];
end

if flag
    if spc.switches.noSPC
        if gui.spc.proChannel == 1
            spc.project = spc.state.img.greenMax;
        else
            spc.project = spc.state.img.redMax;
        end
        if isfield(gui.spc.figure, 'proChannel')
            for i=1:length(gui.spc.figure.proChannel)
                val = get(gui.spc.figure.proChannel(i), 'Value');
                if val ~= (i==gui.spc.proChannel)
                    set(gui.spc.figure.proChannel(i), 'Value', (i==gui.spc.proChannel));
                    set(gui.spc.figure.projectAuto, 'Value', 1);
                end
            end
        end
    else
        spc.project = reshape(sum(spc.imageMod, 1), spc.SPCdata.scan_size_x, spc.SPCdata.scan_size_y);
        if spc.SPCdata.line_compression > 1
            aa = 1/spc.SPCdata.line_compression;
            %[xi, yi] = meshgrid(aa:aa:spc.SPCdata.scan_size_x, aa:aa:spc.SPCdata.scan_size_y);
            [xi, yi] = meshgrid(1:aa:1-aa+spc.SPCdata.scan_size_x, 1:aa:1-aa+spc.SPCdata.scan_size_y);
            project1 = [spc.project; spc.project(end, :)];
            project2 = [project1, project1(:, end)];
            spc.project = interp2(project2, xi, yi)*aa*aa;
            spc.size(2) = spc.SPCdata.scan_size_x /aa;
            spc.size(3) = spc.SPCdata.scan_size_y /aa;           
        end
    end
    spc.switches.filter = str2num(get(gui.spc.figure.filter, 'String'));
    if spc.switches.filter > 1
       filterWindow = ones(spc.switches.filter, spc.switches.filter)/spc.switches.filter/spc.switches.filter;
        spc.project = imfilter(spc.project, filterWindow, 'replicate');
    end
end %{flag}
set(gui.spc.figure.projectImage, 'CData', spc.project);
autoLUT = get(gui.spc.figure.projectAuto, 'Value');
if autoLUT
    %set(gui.spc.figure.projectImage, 'CDataMapping', 'direct');
    uplimit = round(max(spc.project(:)));
    lowlimit = round(min(spc.project(:)));
else
    uplimit = str2num(get(gui.spc.figure.projectUpperlimit, 'String'));
    lowlimit = str2num(get(gui.spc.figure.projectLowerlimit, 'String'));
end
set(gui.spc.figure.projectUpperlimit, 'String', num2str(uplimit));
set(gui.spc.figure.projectLowerlimit, 'String', num2str(lowlimit));
set(gui.spc.figure.projectAxes, 'Clim', [lowlimit, uplimit]);
set(gui.spc.figure.projectAuto, 'Value', 0);
siz = size(spc.project);

%gui.spc.figure.roi = rectangle ('position', roi_pos, 'ButtonDownFcn', 'spc_dragRoi', 'EdgeColor', [1,1,1]);

if ~spc.switches.noSPC
    spc_drawAll(flag); %flag = calculation of lifetimeMap
end

%%%%%%%%%%%%%%%%%%%%%%
if spc.switches.redImg
    if flag == 1
        if isfield(gui.spc.figure, 'channel')
            for i=1:length(gui.spc.figure.channel)
                val = get(gui.spc.figure.channel(i), 'Value');
                if val ~= (i==gui.spc.scanChannel)
                    set(gui.spc.figure.channel(i), 'Value', (i==gui.spc.scanChannel));
                    set(gui.spc.figure.redAuto, 'Value', 1);
                end
            end
        end
        
        if gui.spc.scanChannel == 1
            scanImg = spc.state.img.greenMax;
        else
            scanImg = spc.state.img.redMax;
        end
        
        if spc.switches.filter > 1
            scanImg = imfilter(scanImg, filterWindow, 'replicate');
        else
            scanImg = scanImg;
        end
        set(gui.spc.figure.scanImg, 'CData', scanImg);
        set(gui.spc.figure.scanImgA, 'XTick', [], 'YTick', []);
        autoLUT = get(gui.spc.figure.redAuto, 'Value');
        if autoLUT
            %set(gui.spc.figure.projectImage, 'CDataMapping', 'direct');
            uplimit = round(max(scanImg(:)));
            lowlimit = round(min(scanImg(:)));
        else
            uplimit = str2num(get(gui.spc.figure.redUpperlimit, 'String'));
            lowlimit = str2num(get(gui.spc.figure.redLowerlimit, 'String'));
        end
        set(gui.spc.figure.redUpperlimit, 'String', num2str(uplimit));
        set(gui.spc.figure.redLowerlimit, 'String', num2str(lowlimit));
        set(gui.spc.figure.scanImgA , 'Clim', [lowlimit, uplimit]);
        set(gui.spc.figure.redAuto, 'Value', 0);    
    end
end

set(gui.spc.figure.projectAxes, 'Xlim', [0.5,siz(1)+0.5], 'Ylim', [0.5,siz(2)+0.5]);
set(gui.spc.figure.lifetimeMapAxes, 'Xlim', [0.5,siz(1)+0.5], 'Ylim', [0.5,siz(2)+0.5]);
set(gui.spc.figure.scanImgA, 'Xlim', [0.5,siz(1)+0.5], 'Ylim', [0.5,siz(2)+0.5]);
