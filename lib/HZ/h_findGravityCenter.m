function Aout = h_findGravityCenter

global h_img

handles = h_img.currentHandles;
siz = size(h_img.data);

zLim(1) = str2num(get(handles.zStackControlLow,'String'));
zLim(2) = str2num(get(handles.zStackControlHigh,'String'));


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
[Aout.roi(end+1).BW,Aout.roi(end+1).xi,Aout.roi(end+1).yi] = ...
    roipoly(ones(siz(1), siz(2)), [0,siz(1),siz(1),0,0]+1/2, [0,0,siz(2),siz(2),0]+1/2);
Aout.roiNumber(end+1) = 0;
n_roi = n_roi+1;

[Aout.roiNumber,I] = sort(Aout.roiNumber);
Aout.roi = Aout.roi(I);

% bgroiobj = findobj(handles.h_imstack,'Tag','HBGROI');
% if ~isempty(bgroiobj)
%     UserData = get(bgroiobj, 'UserData');
%     [Aout.bgroi.BW,Aout.bgroi.xi,Aout.bgroi.yi] = roipoly(ones(siz(1), siz(2)), UserData.roi.xi, UserData.roi.yi);
% else
%     Aout.bgroi = [];
% end

%%%%%%%%%%%%%%%%  Calculate  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if h_img.state.roiControl.channelForZ.value
    climit = h_climit(h_img.redimg,0.05,0.98);
    thresh = 3*climit(1);
    %     thresh = str2num(get(handles.redLimitTextLow,'String'));
    data = (h_img.data(:,:,2*zLim(1):2:2*zLim(2))>thresh);
else
    climit = h_climit(h_img.greenimg,0.05,0.98);
    thresh = 3*climit(1);
%     thresh = str2num(get(handles.redLimitTextLow,'String'));
    data = (h_img.data(:,:,(2*zLim(1)-1):2:2*zLim(2))>thresh);
end

for i = 1:n_roi
    BW = repmat(Aout.roi(i).BW,[1,1,size(data,3)]);
    data2 = data.*BW;
    sum_along_x = sum(sum(data2,3),1);
    sum_along_x = sum_along_x(:);
    relative_cum = cumsum(sum_along_x)/sum(sum_along_x);
    temp = find([relative_cum > 0.5]);
    p = polyfit(relative_cum(temp(1)-1:temp(1)),[temp(1)-1:temp(1)]',1);
    Aout.center(i).x = polyval(p,0.5);
    
    sum_along_y = sum(sum(data2,3),2);
    sum_along_y = sum_along_y(:);
    relative_cum = cumsum(sum_along_y)/sum(sum_along_y);
    temp = find([relative_cum > 0.5]);
    p = polyfit(relative_cum(temp(1)-1:temp(1)),[temp(1)-1:temp(1)]',1);
    Aout.center(i).y = polyval(p,0.5);
    
    sum_along_z = sum(sum(data2,2),1);
    sum_along_z = sum_along_z(:);
    relative_cum = cumsum(sum_along_z)/sum(sum_along_z);
    temp = find([relative_cum > 0.5]);
    p = polyfit(relative_cum(temp(1)-1:temp(1)),[temp(1)-1:temp(1)]',1);
    Aout.center(i).z = polyval(p,0.5);
end 