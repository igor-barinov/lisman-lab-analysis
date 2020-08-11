function Aout = h_tracingAlongROI(basename, nums)

Aout.ratio = nan;
Aout.d = 0;
for i = nums
    str1 = '000';
    str2 = num2str(i);
    str1(end-length(str2)+1:end) = str2;
    filename = fullfile('Analysis',[basename, str1, '_zroi.mat']);
    filename1 = [basename, str1, '.tif'];
    roiResult = load(filename);
    [data,header] = h_opentif(filename1,0);
    
    info = h_quickinfo(header);
    x_pixelSize = calculateFieldOfView(info.zoom)/ header.acq.pixelsPerLine;
    y_pixelSize = calculateFieldOfView(info.zoom)/ header.acq.linesPerFrame;
    roi = roiResult.Aout.roi;
    
    d = h_roiDistance(roi(1:end-1),roi(2:end),x_pixelSize,y_pixelSize,header.acq.zStepSize);
    cum_d = cumsum(d);
    
    ratio = roiResult.Aout.ratio-0.03;
    Aout.ratio = vertcat(Aout.ratio(1:end-1),ratio(:));
    Aout.d = vertcat(Aout.d,cum_d(:)+Aout.d(end));
end
    % Aout.I = 1;
    % space = 10;
    % i = 1;
    % while i*space < max(cum_d)
    %     D = i*space;
    %     I = find(cum_d <= D);
    % %     I1 = find(cum_d>D & cum_d<D+space);
    %     if ~isempty(I) & (length(I)<length(cum_d))
    %         d1 = abs(cum_d(I(end))-D);
    %         d2 = abs(cum_d(I(end)+1)-D);
    %         Aout.ratio(i+1) = ratio(I(end)+1) * d2/(d1+d2) + ratio(I(end)+2) * d1/(d1+d2);
    %         Aout.d(i+1) = D;
    %         Aout.I(i+1) = (I(end)+1) * d2/(d1+d2) + (I(end)+2) * d1/(d1+d2);
    %         i = i + 1;
    %     else
    %         error
    %     end
    % end