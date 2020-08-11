function Aout = h_calcSphere(center)

global h_img

handles = h_img.currentHandles;
siz = size(h_img.data);

zoom = h_img.header.acq.zoomhundreds*100 + h_img.header.acq.zoomtens*10 + h_img.header.acq.zoomones;
[x_fieldOfView, y_fieldOfView] = calculatefieldofview(zoom);
x_factor = x_fieldOfView/siz(2);
y_factor = y_fieldOfView/siz(1);
z_factor = abs(h_img.header.acq.zStepSize);


fname = get(handles.currentFileName,'String');
[filepath, filename, fExt] = fileparts(fname);

zLim(1) = str2num(get(handles.zStackControlLow,'String'));
zLim(2) = str2num(get(handles.zStackControlHigh,'String'));


% color_a = {'green', 'red', 'yellow', 'cyan', 'magenta'};

% find ROIs
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

bgroiobj = findobj(handles.h_imstack,'Tag','HBGROI');
if ~isempty(bgroiobj)
    UserData = get(bgroiobj, 'UserData');
    [Aout.bgroi.BW,Aout.bgroi.xi,Aout.bgroi.yi] = roipoly(ones(siz(1), siz(2)), UserData.roi.xi, UserData.roi.yi);
else
    Aout.bgroi = [];
end

% Calculation
green_data = h_img.data(:,:,(2*zLim(1)-1):2:2*zLim(2));
red_data = h_img.data(:,:,2*zLim(1):2:2*zLim(2));
    
% Calculate background
try
    BW = repmat(Aout.bgroi.BW,[1,1,size(green_data,3)]);
    Aout.green_bg = mean(green_data(BW));
    Aout.red_bg = mean(red_data(BW));
catch
    error('No background ROI!');
end

% thresh
if h_img.state.roiControl.channelForZ.value
    sd = std(double(red_data(BW)));
    thresh = Aout.red_bg + 6*sd;
%     climit = h_climit(h_img.redimg,0.05,0.98);
%     thresh = 3*climit(1);
    %     thresh = str2num(get(handles.redLimitTextLow,'String'));
    thresh_data = red_data;
else
    sd = std(double(green_data(BW)));
    thresh = Aout.green_bg + 6*sd;
%     climit = h_climit(h_img.greenimg,0.05,0.98);
%     thresh = 3*climit(1);
%     thresh = str2num(get(handles.redLimitTextLow,'String'));
    thresh_data = green_data;
end

% smooth whole image to reduce random photon noise
f = ones(3)/9;
for i = 1:size(thresh_data,3)
    thresh_data(:,:,i) = filter2(f,thresh_data(:,:,i));
end

ind = thresh_data<=thresh;
%calculation
% green_data(ind) = 0;
% red_data(ind) = 0;

for i = 1:n_roi
    BW = repmat(Aout.roi(i).BW,[1,1,size(green_data,3)]);
    I1 = find(~ind & BW);
    [y,x,z] = ind2sub([siz(1),siz(2),size(green_data,3)],I1 );
    distance = sqrt(((x-center.x).*x_factor).^2 + ((y-center.y).*y_factor).^2 + ((z-center.z).*z_factor).^2);
    j = 1;
    for D = 5:5:ceil(max(distance)/5)*5
        I2 = I1(find(distance<=D & distance>(D-5)));
%         disp(num2str(length(I2)));
        Aout.distance{i}(j) = D;
        Aout.green{i}(j) = mean(green_data(I2)) - Aout.green_bg;
        Aout.red{i}(j) = mean(red_data(I2)) - Aout.red_bg;
        Aout.ratio{i}(j) = Aout.green{i}(j)/Aout.red{i}(j);
        j = j + 1;
    end
end
Aout.center = center;    
