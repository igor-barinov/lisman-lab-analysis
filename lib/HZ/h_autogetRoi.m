function [x_start,x_end,y_start,y_end,z_start,z_end, line] = h_autogetRoi(header)

pos = eval([header.init.eom.powerBoxNormCoords]);
if ~isempty(pos)
    if size(pos,1) == 2
        beam = 2;
    else
        beam = 1;
    end
    pos = pos(beam,:);
    pos([1,3]) = pos([1,3]) * header.acq.pixelsPerLine;
    pos([2,4]) = pos([2,4]) * header.acq.linesPerFrame;
    pos = round(pos);
    
    x_start = pos(1);
    x_end = pos(1) + pos(3);
    y_start = pos(2);
    y_end = pos(2) + pos(4);
    if pos(4)==1
        y_start = pos(2) - 3;
        y_end = pos(2) + 3;
        line = 1;
    else
        line = 0;
        y_start = pos(2);
        y_end = pos(2) + pos(4);
    end
    z_start = double(header.init.eom.startFrameArray(2));
%     z_start = z_start(beam);
    z_end = double(header.init.eom.endFrameArray(2));
%     z_end = z_end(beam);
else
    disp('No power box infomation available');
    return
end

