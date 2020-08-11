function Aout = h_calculatePAROI(handles)

global h_img

offset = [0,0];
fname = get(handles.currentFileName,'String');
[filepath,filename,fileExt] = fileparts(fname);

zLim(1) = str2num(get(handles.zStackControlLow,'String'));
zLim(2) = str2num(get(handles.zStackControlHigh,'String'));

header = h_img.header;

roiobj = sort(findobj(handles.h_imstack,'Tag', 'HROI'));
n_roi = length(roiobj);
set(roiobj, 'Visible', 'Off'); 
set(roiobj, 'Visible', 'On');

siz = size(h_img.data);
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


%%%%%%%%%%%%%%%%% Find the photo-activating frame %%%%%%%%%%%%%%%%
try
    [x_start,x_end,y_start,y_end,z_start,z_end, line] = h_autogetRoi(header);
    Aout.PA_frames = [z_start:z_end];
    
    BW_auto = zeros(siz(1),siz(2));
    BW_auto([y_start:y_end],[x_start:x_end]) = 1;
    
    Aout.frame_before.g = h_img.data(:,:,2*z_start-3);
    Aout.frame_before.r = h_img.data(:,:,2*z_start-2);
    Aout.frame_after.g = h_img.data(:,:,2*z_end+1);
    Aout.frame_after.r = h_img.data(:,:,2*z_end+2);
    roi_fail = 0;
catch
    roi_fail = 1;
    Aout.PA_frames = [];
    Aout.frame_before = [];
    Aout.frame_after = [];
end

Aout.green = cell(1,n_roi);
Aout.red = cell(1,n_roi);

for i = zLim(1):zLim(2)
    green = h_img.data(:,:,2*i-1);
    red = h_img.data(:,:,2*i);
    
    if isempty(bgroiobj)
        green_bg = 0;
        red_bg = 0;
    else
        green_bg = mean(green(Aout.bgroi.BW));
        red_bg = mean(red(Aout.bgroi.BW));
    end
    
    Aout.green_bg(i) = green_bg;
    Aout.red_bg(i) = red_bg;
    
    for j = [1:n_roi]
        Aout.green{j} = [Aout.green{j},mean(green(Aout.roi(j).BW)) - green_bg];
        Aout.red{j} = [Aout.red{j},mean(red(Aout.roi(j).BW)) - red_bg];
    end
end

for i = 1:n_roi
    if ~roi_fail & max(Aout.roi(i).BW(find(BW_auto)))==1
        Aout.green{i}([z_start:z_end]) = NaN;
        Aout.red{i}([z_start:z_end]) = NaN;
    end
end

Aout.time = [1:(diff(zLim)+1)] * header.acq.msPerLine * header.acq.linesPerFrame / 1000;

  for k = 1:n_roi      %nicko  to transpose the data
    Aout.green_t{1,k} = cell2mat(Aout.green(1,k))';
    Aout.red_t{1,k} = cell2mat(Aout.red(1,k))';
  end 
    Aout.time_t=Aout.time';%nicko  to transpose the data
    Aout.filename = fname;

%%%%%%%% Save %%%%%%%%%%%%%%%%%%%%

if ~(exist(fullfile(filepath,'Analysis'))==7)
    currpath = pwd;
    cd (filepath);
    mkdir('Analysis');
    cd (currpath);
end
save(fullfile(filepath,'Analysis',[filename,'_roim']), 'Aout');
