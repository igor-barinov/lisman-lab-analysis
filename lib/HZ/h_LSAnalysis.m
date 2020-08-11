function Aout = h_LSAnalysis(F)

if nargin<1
    F = [];
end

global h_img

handles = h_img.currentHandles;
roiobj = findobj(handles.imageAxes,'Tag','LSROI');
% bgroiobj = findobj(imgAxes,'Tag','BGROI');
% if ~isempty(bgroiobj)
%     pos = get(bgroiobj,'Position');
%     Aout.bg.pos = round([pos(1),pos(1)+pos(3)]);
%     green_bg = mean(h_img.data(:,Aout.bg.pos(1):Aout.bg.pos(2),1:2:end),2);
%     red_bg = mean(h_img.data(:,Aout.bg.pos(1):Aout.bg.pos(2),2:2:end),2);
%     Aout.bg.green = green_bg(:);
%     Aout.bg.red = red_bg(:);
% else
%     Aout.bg = [];
% end

sampleRate = 1/(h_img.header.acq.msPerLine/1000);%mod 2015-04-22 now msPerLine is real ms.

if ~isempty(F)&F<sampleRate
    [b,a] = butter(4,F*2/sampleRate);
    Hd = dfilt.df2t(b,a);
end

% try
%     green = sum(h_img.data(:,:,1:2:end),2);
%     [opentime, shutter_range] = h_findShutterOpen(green(:));
% catch
    shutter_range = [25 26];
% end
n_roi = length(roiobj)/2;

if isempty(roiobj)
    ROI_num = get(handles.numberOfROI,'Value');
    boundaryThresh = 0.1*get(handles.roiBoundaryThresh,'Value');
    roiSelectionChannelOpt = get(handles.roiSelectionChannelOpt,'Value');
    
    if get(handles.lineScanDisplay,'Value')
        zLim(1) = str2num(get(handles.zStackControlLow,'String'));
        zLim(2) = str2num(get(handles.zStackControlHigh,'String'));
    else
        zLim = [1,size(h_img.data,3)/2];
    end    
    
    y = sum(sum(h_img.data(:,:,(2*zLim(1)-mod(roiSelectionChannelOpt,2)):2:2*zLim(2)),1),3);
    [peaks,valleys,error]=h_findPeaks(y,ROI_num);
    roi_pos = h_findROIboundary(y,peaks,valleys,boundaryThresh);
    if length(peaks)<ROI_num
        roi_pos([1,2],end+1:ROI_num) = length(y);
    end
    ydata = get(handles.imageAxes,'YLim');
    for i = 1:ROI_num
        UData(i).number = i;
        UData(i).ROIHandles = [];
        UData(i).roi_pos = roi_pos(:,i);
    end
    n_roi = ROI_num;
end


for i = 1:n_roi
    if isempty(roiobj)
        UserData = UData(i);
    else
        UserData = get(roiobj(1),'Userdata');
    end
    Aout.roi(i).pos = round(sort(UserData.roi_pos));
    Aout.roi(i).roiNumber = UserData.number;
    Aout.roi(i).roiSiz = diff(Aout.roi(i).pos) + 1;
    green = mean(h_img.data(:,Aout.roi(i).pos(1):Aout.roi(i).pos(2),1:2:end),2);
    red = mean(h_img.data(:,Aout.roi(i).pos(1):Aout.roi(i).pos(2),2:2:end),2);
    Aout.roi(i).green = green(:);
    Aout.roi(i).red = red(:);
    %         if ~isempty(Aout.bg)
    %             Aout.roi(i).green = Aout.roi(i).green - mean(Aout.bg.green);
    %             Aout.roi(i).red = Aout.roi(i).red - mean(Aout.bg.red);
    %         end
    if i > 1 && get(handles.subtractBackground,'Value'); % if subtract background is checked,
        % subtract the average of background from green and from red, and update data -- AZ
        Aout.roi(2).green = Aout.roi(2).green - mean(Aout.roi(1).green);
        Aout.roi(2).red = Aout.roi(2).red - mean(Aout.roi(1).red);
    end
    if get(handles.autoShutterBaselineSelection,'Value');
        baseline_g = mean(green(1:shutter_range(1)));
        baseline_r = mean(red(1:shutter_range(1)));
        Aout.roi(i).green = Aout.roi(i).green - baseline_g;
        Aout.roi(i).red = Aout.roi(i).red - baseline_r;
    end
    if ~isempty(F)&F<sampleRate
        Aout.roi(i).green = filter(Hd,Aout.roi(i).green);
        Aout.roi(i).red = filter(Hd,Aout.roi(i).red);
        Aout.roi(i).green(1:round(sampleRate/F)) = NaN;
        Aout.roi(i).red(1:round(sampleRate/F)) = NaN;
    end
    Aout.roi(i).ratio = Aout.roi(i).green ./ Aout.roi(i).red;
    if ~isempty(roiobj)
        roiobj(roiobj==UserData.ROIHandles(1))=[];
        roiobj(roiobj==UserData.ROIHandles(2))=[];
    end
end
% else 
%     Aout.roi = [];
% end

% siz = size(h_img.data);
Aout.time = [1:length(Aout.roi(1).green)]*h_img.header.acq.msPerLine*1000;