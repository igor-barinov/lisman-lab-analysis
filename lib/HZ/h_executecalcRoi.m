function Aout = h_executecalcRoi(handles)

global h_img

offset = [0,0];
fname = get(handles.currentFileName,'String');
% pos = strfind(fname,'/');
% filepath = fname(1:pos(end));
% filename = fname((pos(end)+1):end);
[filepath, filename] = h_analyzeFilename(fname);

hLow = h_findobj('Tag','zStackControlLow');
zLim(1) = str2num(get(hLow(1),'String'));
hHigh = h_findobj('Tag','zStackControlHigh');
zLim(2) = str2num(get(hHigh(1),'String'));

header = h_img.header;

siz = size(h_img.data);

% color_a = {'green', 'red', 'yellow', 'cyan', 'magenta'};
roiobj = sort(findobj(handles.h_imstack,'Tag', 'HROI'));
n_roi = length(roiobj);
Aout.roi = [];
Aout.roiNumber = [];
for j = 1:n_roi
    UserData = get(roiobj(j), 'UserData');
    [Aout.roi(j).BW,Aout.roi(j).xi,Aout.roi(j).yi] = roipoly(ones(siz(1), siz(2)), UserData.roi.xi, UserData.roi.yi);
    Aout.roiNumber(j) = UserData.number;
end

[Aout.roiNumber,I] = sort(Aout.roiNumber);
Aout.roi = Aout.roi(I);

bgroiobj = findobj(handles.h_imstack,'Tag','HBGROI');
if ~isempty(bgroiobj)
    UserData = get(bgroiobj, 'UserData');
    [Aout.bgroi.BW,Aout.bgroi.xi,Aout.bgroi.yi] = roipoly(ones(siz(1), siz(2)), UserData.roi.xi, UserData.roi.yi);
else
    Aout.bgroi = [];
end

%%%%%%%%%%%%%%%%  Calculate  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
green_data = h_img.data(:,:,(2*zLim(1)-1):2:2*zLim(2));
red_data = h_img.data(:,:,2*zLim(1):2:2*zLim(2));

Aout.zLim = zLim;
for i = 1:n_roi
    ind = find(Aout.roi(i).BW);
    try ind_bg = find(Aout.bgroi.BW); end
    if h_img.state.roiControl.channelForZ.value
        for j = 1:size(red_data,3)
            imr = red_data(:,:,j);
            intensity(j) = mean(imr(ind));
        end
    else
        for j = 1:size(green_data,3)
            imr = green_data(:,:,j);
            intensity(j) = mean(imr(ind));
        end
    end

    zi = find(intensity==max(intensity));
    zi = zi(1);
    if zi+1 <= size(red_data,3)
        z_end = zi+1;
    else 
        z_end = zi;
    end
    if zi-1 >= 1 
        z_start = zi-1;
    else 
        z_start = zi;
    end
    Aout.roi(i).z = [z_start:z_end];
    ind2 = [];
    ind_bg2 = [];
    for z = Aout.roi(i).z
        ind2 = [ind2;ind+(z-1)*size(green_data,1)*size(green_data,2)];
        try ind_bg2 = [ind_bg2;ind_bg+(z-1)*size(green_data,1)*size(green_data,2)]; end
    end
    
    if ~isempty(bgroiobj)
        Aout.green_bg(i) = mean(green_data(ind_bg2));
        Aout.red_bg(i) = mean(red_data(ind_bg2));
    else
        Aout.green_bg(i) = 0;
        Aout.red_bg(i) = 0;
    end
    green = green_data(ind2);
    red = red_data(ind2);
    
    %%%%%%%%%%%% Setting up threshold option%%%%%%%%%%%%%
    if isfield(handles,'treshControl')    
        threshstr = get(handles.threshControl,'String');
        threshvalue = get(handles.threshControl,'Value');
        threshswitch = cell2mat(threshstr(threshvalue));
        if strcmp(threshswitch,'Thresh')|isempty(bgroiobj)
            threshr = -Inf;
            threshg = -Inf;
            set(handles.threshControl,'Value',1);
            green = green(green>threshg);
            red = red(red>threshr);
        elseif ~isempty(strfind(threshswitch,'SD'))
            threshr = str2num(threshswitch(1:2))*std(red_data(ind_bg2)) + Aout.red_bg(i);
            threshg = str2num(threshswitch(1:2))*std(green_data(ind_bg2)) + Aout.green_bg(i);
            green = green(green>threshg);
            red = red(red>threshr);
        elseif ~isempty(strfind(threshswitch,'Top'))
            pct = 1 - str2num(threshswitch(5:6))*0.01;
            temp = sort(red);
            threshr = temp(round(pct*length(temp)));
            red = temp([round(pct*length(temp)):end]);
            temp = sort(green);
            threshg = temp(round(pct*length(temp)));
            green = temp([round(pct*length(temp)):end]);
        else
            threshr = str2num(threshswitch);
            threshg = str2num(threshswitch);
            green = green(green>threshg);
            red = red(red>threshr);
        end
    else
        threshr = -Inf;
        threshg = -Inf;
        green = green(green>threshg);
        red = red(red>threshr);
    end
    
    Aout.green_thresh(i) = threshg;
    Aout.red_thresh(i) = threshr;
    Aout.green(i) = mean(green) - Aout.green_bg(i);
    Aout.red(i) = mean(red) - Aout.red_bg(i);
    Aout.ratio(i) = Aout.green(i)/Aout.red(i);
    Aout.roiVol(i) = length(ind2);
    Aout.roi(i).z = Aout.roi(i).z + zLim(1) - 1; %reset the data to absolute z value.
    
    %measure the max value. To reduce noise, the average of 5 maximum value is used.    
    sorted_green = sort(green,'descend');
    sorted_red = sort(red,'descend');
    Aout.max_green(i) = mean(sorted_green(1:5)) - Aout.green_bg(i);
    Aout.max_red(i) = mean(sorted_red(1:5)) - Aout.red_bg(i);
    
end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %add the x, y, z localization calculation%
Aout.roiCentroidPos = calculateXYZPos(Aout);
    %end of adding the x, y, z calculation position%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55555
try
    Aout.timestr = header.internal.triggerTimeString;
    if isempty(Aout.timestr)
        fileinfo = dir(fname);
        Aout.time = datenum(fileinfo.date);
    end
catch % for non-scanimage files, there is no header info.
    fileinfo = dir(fname);
    Aout.time = datenum(fileinfo.date);
end

Aout.filename = filename;

%%%%%%%% Save %%%%%%%%%%%%%%%%%%%%

if ~exist(fullfile(filepath,'Analysis'),'dir')
    currpath = pwd;
    cd (filepath);
    mkdir('Analysis');
    cd (currpath);
end
analysisNumber = h_img.state.analysisNumber.Value;
if analysisNumber == 1
    analysisNumber = [];
end
fname = fullfile(filepath,'Analysis',[filename(1:end-4),'_zroi',num2str(analysisNumber)]);
save(fname, 'Aout');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% basename=filename(1:end-7);
% 
% try
%     load([basename,'_Int.mat'])
% catch
%     numPoints=0;
% end
% 
% numPoints=numPoints+1;
% 
% Bout(numPoints).green=Aout.green;
% Bout(numPoints).red=Aout.red;
% 
% save([basename,'_Int.mat'],'Bout','numPoints')


function roiCentroidPos = calculateXYZPos(Aout)

global h_img

try %non-scanimage files does not have a proper header
    info = h_quickinfo(h_img.header);

    [xFOV yFOV] = calculateFieldOfView(info.zoom);
    % xFOV = 40;%temp - no calculateFieldOfView
    % yFOV = 40;
    xScale = xFOV / h_img.header.acq.pixelsPerLine;
    yScale = yFOV / h_img.header.acq.linesPerFrame;%pixel size in micron
    zScale = h_img.header.acq.zStepSize;
catch
    xScale = h_img.header(1).XResolution / h_img.header(1).Width;
    yScale = h_img.header(1).YResolution / h_img.header(1).Height;
    zScale = 1; % this is fake.
end
scale = [xScale yScale zScale];

%%%%%%%% find intensity center of each ROI %%%%%%%%
siz = size(h_img.data);
green_data = h_img.data(:,:,1:2:end);
red_data = h_img.data(:,:,2:2:end);

roiCentroidPos.roiCentroid_g = zeros(length(Aout.roi),3);% x, y, z in pixels
roiCentroidPos.roiCentroid_r = zeros(length(Aout.roi),3);% x, y, z 
roiCentroidPos.roiCentroidInMicron_g = zeros(length(Aout.roi),3);% x, y, z in microns
roiCentroidPos.roiCentroidInMicron_r = zeros(length(Aout.roi),3);% x, y, z 

for i = 1:length(Aout.roi)
    BW = Aout.roi(i).BW;
    z = Aout.roi(i).z;
    xi = Aout.roi(i).xi;
    yi = Aout.roi(i).yi;

    fitZRange = [z(1)-1, z, z(end)+1];
    fitZRange = fitZRange(fitZRange > 0);
    fitZRange = fitZRange(fitZRange <= siz(3)/2);


    %     BW2 = repmat(BW, [1, 1, length(z)]);
    %fit x, y
    avgGreenImg = mean(green_data(:,:,z),3);%average to reduce noice.
    greenRoiImg = avgGreenImg.*BW;
    if max(greenRoiImg(:))
    greenRoiImgToBeFit = greenRoiImg(round(min(yi)):round(max(yi)),...
        round(min(xi)):round(max(xi))) - Aout.green_bg(i);
    fit = h_gauss2DFitWithIntegration(greenRoiImgToBeFit);
    roiCentroidPos.roiCentroid_g(i,1) = fit.mu(1) + round(min(xi)) - 1;
    roiCentroidPos.roiCentroid_g(i,2) = fit.mu(2) + round(min(yi)) - 1;
    end
    avgRedImg = mean(red_data(:,:,z),3);%average to reduce noice.
    redRoiImg = avgRedImg.*BW;
    redRoiImgToBeFit = redRoiImg(round(min(yi)):round(max(yi)),...
        round(min(xi)):round(max(xi))) - Aout.red_bg(i);
    fit = h_gauss2DFitWithIntegration(redRoiImgToBeFit);
    roiCentroidPos.roiCentroid_r(i,1) = fit.mu(1) + round(min(xi)) - 1;
    roiCentroidPos.roiCentroid_r(i,2) = fit.mu(2) + round(min(yi)) - 1;

    %fit z.
    intensity = zeros(1,siz(3)/2);
    for j = 1:siz(3)/2
        imr = green_data(:,:,j) - Aout.green_bg(i);
        intensity(j) = mean(imr(BW));
    end
    if length(fitZRange)>1
%         gaussianFit = h_fitGaussian(fitZRange, intensity(fitZRange));% h_fitGaussian has a floating baseline.
%         if gaussianFit.converge && gaussianFit.sigma>0
%             roiCentroidPos.roiCentroid_g(i,3) = gaussianFit.mu;
%         else
            roiCentroidPos.roiCentroid_g(i,3) = sum(intensity(fitZRange).*fitZRange)/sum(intensity(fitZRange));
%         end
    else
        roiCentroidPos.roiCentroid_g(i,3) = 1; % in case there is only one z step
    end
        

    intensity = zeros(1,siz(3)/2);
    for j = 1:siz(3)/2
        imr = red_data(:,:,j) - Aout.red_bg(i);
        intensity(j) = mean(imr(BW));
    end
    if length(fitZRange)>1
%         gaussianFit = h_fitGaussian(fitZRange, intensity(fitZRange));% h_fitGaussian has a floating baseline.
%         if gaussianFit.converge && gaussianFit.sigma>0
%             roiCentroidPos.roiCentroid_r(i,3) = gaussianFit.mu;
%         else
            roiCentroidPos.roiCentroid_r(i,3) = sum(intensity(fitZRange).*fitZRange)/sum(intensity(fitZRange));
%         end
    else
        roiCentroidPos.roiCentroid_r(i,3) = 1; % in case there is only one z step
    end

    roiCentroidPos.roiCentroidInMicron_r(i,:) = roiCentroidPos.roiCentroid_r(i,:) .* scale;
    roiCentroidPos.roiCentroidInMicron_g(i,:) = roiCentroidPos.roiCentroid_g(i,:) .* scale;
end