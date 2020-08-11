function a = spc_calcRoi;
global spc;
global gui;
global thresholds_list;
% global spc_bg;
% global Red_bg;


%   these threshold values are linked to global thresholds_list from
%   thresholds.m, which are updated from gui - AZ
thresholds; % run the gui and return preset or altered values
filterwindow = thresholds_list(1); %setting filter. if =3 makes 3x3 smoothing before calculation-nick
BMF = thresholds_list(2); %background multiplication factor: spc_background = BMF*mean+2*std; if BMF=0 then background = low threthould LUT in lifetime map fig3-nick
BMFr = thresholds_list(3);% bg=BMFr * mean+2std similar to above but if BMF =0 then red_background = set_red-bg
SD_BMFr = thresholds_list(4); % muliplication factor for SD . nomally it is =2
set_red_bg = thresholds_list(5);% if 0 then bg = mean + 2 SD- nicko
% pixelshift=0;
sdf = thresholds_list(6);
rdf = thresholds_list(7);
Red = thresholds_list(8); Green = thresholds_list(9); Yellow = thresholds_list(10); % red image mask  color
deltaX = thresholds_list(11); %these are ROI shift corection for the red ROI relatively spc-Roi-nicko
deltaY = thresholds_list(12);
set_nRoi = thresholds_list(13);% if 0 nRoi are automatic otherwise set nRoi including bg ROi
plotave = thresholds_list(14);%-nicko
page3 = thresholds_list(15);%if page3=1 then time1=time3 otherwise time1=time-nicko
dpixels = thresholds_list(16);%   Make dpixels=1 if dendpixels are calculated in the last region-nicko
DendROI =dpixels; %for calculation dendritic statistics nicko
BMFg = BMFr; %thresholds_list(17);% bg=BMFg * mean+2std similar to above but if BMF =0 then red_background = set_red-bg
SD_BMFg = SD_BMFr; %thresholds_list(18); % muliplication factor for SD . nomally it is =2
set_green_bg = thresholds_list(19);% if 0 then bg = mean + 2 SD- nicko
% pixelshift=0;
% sdf = thresholds_list(20);
% rdf = thresholds_list(21);
% Green = thresholds_list(22);

%goodRoi = 1; %indicates presence of  ROIs

%nChannels = spc.SPCdata.scan_rout_x; %from RY calcROI

if length(findobj('Tag', 'RoiA0')) == 0
    beep;
    errordlg('Set the background ROI (roi 0)!');
    return;
end

[filepath, basename, fn, max1] = spc_AnalyzeFilename(spc.filename);

sSiz = get(0, 'ScreenSize');
fpos = [50   100   500   sSiz(4)-200]; %RY
%fpos = [53   192   568   713];
if isfield(gui.spc, 'calcRoi')
    if ishandle(gui.spc.calcRoi)
    else
        gui.spc.calcRoi = figure ('position', fpos);
    end
else
    gui.spc.calcRoi = figure ('position', fpos);
end

spc_updateMainStrings;
% spc.filename,
% name_start=findstr(spc.filename, '\'); %RY
% name_start=name_start(end)+1;

cd (filepath);

fname = [basename, '_ROI2'];
evalc(['global  ', fname]);   %loads _ROI2

%if exist([fname, '.mat'])
if exist([fname, '.mat'], 'file') %RY
    load([fname, '.mat'], fname);
    %evalc(['Ch = ', fname]); %RY
    evalc(['a = ', fname, '.roiData']);
    evalc(['bg = ', fname, '.bgData']);
    evalc(['ana = ', fname, '.analyzeData']);           %added by JZ
end

% for channelN = 1:nChannels  %RY for tnChannel
%         try
%             a = Ch(channelN).roiData;
%             bg = Ch(channelN).bgData;
%         end
%         gui.spc.proChannel = channelN;
%         spc_switchChannel;

           if get(gui.spc.spc_main.fit_eachtime, 'Value')
                try
                    betahat=spc_fitexp2gauss;
                    spc_redrawSetting(1);
                    fit_error = 0;
                catch
                    fit_error = 1;
                end
           else
             fit_error = 1;
           end

        pause(0.1);

nRoi = length(gui.spc.figure.roiB);
if set_nRoi >0
    nRoi=set_nRoi;
end
if ~spc.switches.noSPC
    range = spc.fit.range;
end

project1 = filter2(ones(filterwindow,filterwindow)/filterwindow^2, spc.project);

if spc.switches.redImg
    img_greenMax = filter2(ones(filterwindow,filterwindow)/filterwindow^2, spc.state.img.greenMax);
    img_redMax = filter2(ones(filterwindow,filterwindow)/filterwindow^2, spc.state.img.redMax);
end

% pos_max2 = str2num(get(gui.spc.spc_main.F_offset, 'String'));
% if pos_max2 == 0 | isnan (pos_max2)
%     pos_max2 = 1.0
% end

newroiTemp = project1 * 0;% NickO
newRedroiTemp = img_redMax*0;% NickO
newGreenroiTemp = img_greenMax*0;% NickO

if exist('a','var') && length(a) < nRoi  % HS; to work, Roi's must be added in order
    for roiN=length(a)+1:nRoi-1            % this is so that new Roi's have data structures of same length as previous Roi's
        %a(roiN).time1 = a(1).time;
        a(roiN).time = a(1).time;
        a(roiN).time3 = nan(size(a(1).time3));
        a(roiN).fraction2 = nan(size(a(1).fraction2));
        a(roiN).tauD = nan(size(a(1).tauD));
        a(roiN).tauAD = nan(size(a(1).tauAD));
        a(roiN).tau_m = nan(size(a(1).tau_m));
        a(roiN).position = cell(size(a(1).position));
        a(roiN).nPixel = nan(size(a(1).nPixel));
        a(roiN).mean_int = nan(size(a(1).mean_int));
        a(roiN).int_int2 = nan(size(a(1).int_int2));
        a(roiN).max_int = nan(size(a(1).max_int));
        
        a(roiN).red_int = nan(size(a(1).red_int));
        a(roiN).red_mean = nan(size(a(1).red_mean));
        a(roiN).red_nPixel = nan(size(a(1).red_nPixel));
        a(roiN).red_int2 = nan(size(a(1).red_int2));
        a(roiN).red_max = nan(size(a(1).red_max));
        a(roiN).red_position = cell(size(a(1).red_position));
        
        a(roiN).green_int = nan(size(a(1).green_int));
        a(roiN).green_mean = nan(size(a(1).green_mean));
        a(roiN).green_nPixel = nan(size(a(1).green_nPixel));
        a(roiN).green_int2 = nan(size(a(1).green_int2));
        a(roiN).green_max = nan(size(a(1).green_max));
        a(roiN).green_position = cell(size(a(1).green_position));
        a(roiN).SpDendRatio(fn)= nan(size(a(1).SpDendRatio));
     end
end

for j = 1:nRoi
    if ishandle(gui.spc.figure.roiB(j));
        siz = spc.size;
        goodRoi = 1; %indicates presence of  ROIs
        if strcmp(get(gui.spc.figure.roiB(j), 'Type'), 'rectangle')   % loads rectangular ROIs -nicko
            ROI = get(gui.spc.figure.roiB(j), 'Position');
            tagA = get(gui.spc.figure.roiB(j), 'Tag');
            RoiNstr = tagA(6:end);
            
            theta = [0:1/20:1]*2*pi;
            xr = ROI(3)/2;
            yr = ROI(4)/2;
            xc = ROI(1) + ROI(3)/2;
            yc = ROI(2) + ROI(4)/2;
            x1 = round(sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*cos(theta) + xc);
            y1 = round(sqrt(xr^2*yr^2./(xr^2*sin(theta).^2 + yr^2*cos(theta).^2)).*sin(theta) + yc);
            ROIreg = roipoly(ones(siz(2), siz(3)), x1, y1);
            redROIreg = roipoly(ones(siz(2), siz(3)), x1+deltaX, y1+deltaY);% corrects position of red ROI. Use only if NEEDED!!!-nicko
            greenROIreg = roipoly(ones(siz(2), siz(3)), x1+deltaX, y1+deltaY);
            
        elseif strcmp(get(gui.spc.figure.roiB(j), 'Type'), 'line')% for polygonal ROI -nicko
            xi = get(gui.spc.figure.roiB(j),'XData');
            yi = get(gui.spc.figure.roiB(j),'YData');
            ROIreg = roipoly(ones(siz(2), siz(3)), xi, yi);
            redROIreg = roipoly(ones(siz(2), siz(3)), xi+deltaX, yi+deltaY);% corrects position of red ROI. Use only if NEEDED!!!-nicko
            greenROIreg = roipoly(ones(siz(2), siz(3)),xi+deltaX, yi+deltaY);% corrects position of green ROI. Use only if NEEDED!!!-nicko
            ROI = [xi(:), yi(:)];
            
        else
            ROI = 0;
            goodRoi = 0; %indicates that NO ROIs are present
        end
        
        if j == 1  % background ROI
            if ~spc.switches.noSPC  %SPC image background ROI statistics
                bg_intensity = project1(ROIreg);
                bg_intensity = bg_intensity(~isnan(bg_intensity));
                spc_bg_mean = mean(bg_intensity(:));
                spc_bg_std = std2(bg_intensity);
                spc_bg_nPixels = sum(bg_intensity)/spc_bg_mean;
                
                %bw = (spc.project >= spc.switches.lutlim(1));   %bw = SPC image above the spc.switches.lutlim(1)= low threshold for FLIM image
                %spc_background=spc.switches.lutlim(1); %avg_bg_intensity+4*ab_std %NickO
                spc_bg =BMF*(spc_bg_mean+2*spc_bg_std); %NickO:this background is to find cell borders in spc and FLIM image data but not to subtruct from the signal
                if BMF == 0
                    spc_bg =spc.switches.lutlim(1); 
                end
            end
            if spc.switches.redImg   %%%%%RED and GREEN images Background ROI statistics-nick
                %                     green_R = img_greenMax(ROIreg);
                %                     bg_green_int = sum(green_R);
                %                     bg_green_mean = mean(green_R);
                %                     bg_green_nPixel = bg.green_int(fn) / bg.mean_int(1);
                green_bg_intensity = img_greenMax(redROIreg);% -nicko
                green_bg_intensity = green_bg_intensity(~isnan(green_bg_intensity));
                green_bg_mean = mean(green_bg_intensity(:));
                green_bg_std = std2(green_bg_intensity);
                green_bg_nPixels = sum(green_bg_intensity)/green_bg_mean;
                
                green_bg = BMFg*(green_bg_mean+SD_BMFg*green_bg_std); %NickO:this background is to find cell borders in green image data but not to subtruct from the signal
                
                red_bg_intensity = img_redMax(redROIreg);% -nicko
                red_bg_intensity = red_bg_intensity(~isnan(red_bg_intensity));
                red_bg_mean = mean(red_bg_intensity(:));
                red_bg_std = std2(red_bg_intensity);
                red_bg_nPixels = sum(red_bg_intensity)/red_bg_mean;
                
                red_bg = BMFr*(red_bg_mean+SD_BMFr*red_bg_std); %NickO:this background is to find cell borders in red image data but not to subtruct from the signal
                
                if BMFr == 0
                    red_bg =set_red_bg; %nicko
                else
                end
                if BMFg == 0
                    green_bg =set_green_bg; %nicko
                else
                end
            end
        end
    end
    
    
   if goodRoi
        
        if ~spc.switches.noSPC
            newroi = project1 * 0;
            
            if j~=1       %for good (NOT background) ROIs in SPC image
                roipixels=intersect(find(ROIreg),find(project1>=spc_bg));  %makes NOTbackgraound ROIs in spc_images restricted to pixels above the spc_background intensity
                newroi(roipixels) = 255;
                ROIreg = newroi>1;   %ROI pixels above the SPC background!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%                 if j < nRoi+1-dpixels  % use j<nRoi if dendpixels are calculated in the LAST ROI -nicko
%                     newroiTemp(roipixels) = 255;
%                     ROIregTemp = newroiTemp>1;
%                 end
                F_int = project1(ROIreg);   % calcultes statistics in ROIs of spc-images corrected  for the spc_background threshold!
                F_int = F_int(~isnan(F_int));
                spc_sum = sum(F_int(:));
                spc_mean = mean(F_int(:));
                nPixel = spc_sum/spc_mean;
                spc_max = max(F_int(:));
                 if j==2   % calcultes statistics in First good ROI of spc-images corrected for background-nicko
                    spine_spc_mean =spc_mean;
                    spine_spc_max =spc_max;
                 end
                
                %bw = (spc.project >= spc.switches.lutlim(1));   %bw= low threshold for lifetime image   * this line was mooved to above -Nick
                %lifetimeMap = spc.lifetimeMap(bw & ROIreg); %lifetime values in all pixels in a current ROI that are higher than lower threshold
                lifetimeMap = spc.lifetimeMap(ROIreg); %Nick: ROI was already corected for the background threschold above
                project = spc.project(ROIreg);       %SPC values in all pixels in a current ROI that are higher than lower spc_background threshold
                lifetime = sum(lifetimeMap.*project)/sum(project); %calculates average of LT in a current ROI above the thresholod bw
                t1 = (1:range(2)-range(1)+1); t1 = t1(:);
                tauD = spc.fit.beta0(2)*spc.datainfo.psPerUnit/1000;
                tauAD = spc.fit.beta0(4)*spc.datainfo.psPerUnit/1000;
                tau_m = lifetime; %average of LT in a current ROI above the thresholod bw
            end
        end
        if spc.switches.redImg
             if j~=1        %for good (NOT backgraound) ROIs in Red image
                newRedroi =  img_redMax*0;
                redroipixels=intersect(find(redROIreg),find(img_redMax>=red_bg));
                %                    %Redroipixels=intersect(find(ROIreg),find(project1>=spc_bg));
                newRedroi(redroipixels) = 255;
                redROIreg = newRedroi>1;   %ROI pixels above the REd background !!!!!!!!!!!!!!!
                 if j < nRoi+1 %-dpixels  % use j<nRoi if dendpixels are calculated  NIck
                    newRedroiTemp(redroipixels) = 255;
                     redROIregTemp = newRedroiTemp>1;
                  end
                red_F_int = img_redMax(redROIreg);   % calcultes statistics in ROIs of Red-images corrected  for the spc_background threshold!
                red_F_int = red_F_int(~isnan(red_F_int));
                red_sum = sum(red_F_int(:));
                red_nPixel = red_sum / mean(red_F_int(:));
                red_mean = mean(red_F_int(:));
                red_max =max(red_F_int(:));
                 if j==2
                    spine_red_mean =red_mean;
                    spine_red_max =red_max;
                 end
                newGreenroi =  img_greenMax*0;
                greenroipixels=intersect(find(greenROIreg),find(img_greenMax>=green_bg));
                %                    %Greenroipixels=intersect(find(ROIreg),find(project1>=spc_bg));
                newGreenroi(greenroipixels) = 255;
                greenROIreg = newGreenroi>1;   %ROI pixels above the Green background !!!!!!!!!!!!!!!
                 if j < nRoi+1%-dpixels  % use j<nRoi if dendpixels are calculated  NIck
                     newGreenroiTemp(greenroipixels) = 255;
                     greenROIregTemp = newGreenroiTemp>1;
                 end
                green_F_int = img_greenMax(greenROIreg);   % calcultes statistics in ROIs of Red-images corrected  for the spc_background threshold!
                green_F_int = green_F_int(~isnan(green_F_int));
                green_sum = sum(green_F_int(:));
                green_nPixel = green_sum / mean(green_F_int(:));
                green_mean = mean(green_F_int(:));
                green_max =max(green_F_int(:));
                 if j==2
                    spine_green_mean =green_mean;
                    spine_green_max =green_max;
                 end
              end
         end
        
        
        roiN = j-1;   %makes roiN start with 0; roiN=0 = background ROI
        
      if roiN == 0 % | roiN == [] %%%%%Background of spc ROI calculation
            if spc.switches.noSPC
                bg.time(fn) = datenum(spc.state.internal.triggerTimeString);
            else
                bg.time(fn) = datenum([spc.datainfo.date, ',', spc.datainfo.time]);
                bg.position{fn} = ROI;
                bg.mean_int(fn) =spc_bg_mean;
                bg.nPixel(fn) = spc_bg_nPixels;
            end
                bg.position{fn} = ROI;
            %                 bg.mean_int(fn) =spc_bg_mean;
            %                 bg.nPixel(fn) = spc_bg_nPixels;
            
            if spc.switches.redImg   %%%%%Background of RED and GREEN ROI calculation NIck
                %                     green_R = img_greenMax(ROIreg);
                %                     bg.green_int(fn) = sum(green_R);
                %                     bg.green_mean(fn) = mean(green_R);
                %                     bg.green_nPixel(fn) = bg.green_int(fn) / bg.mean_int(fn);
                bg.red_position{fn} = redROIreg;
                bg.green_mean_int(fn) = green_bg_mean;
                bg.green_nPixel(fn) = green_bg_nPixels;
                
                bg.red_mean_int(fn) = red_bg_mean;
                bg.red_nPixel(fn) = red_bg_nPixels;
            end
        else
            a(roiN).position{fn} = ROI;
            if spc.switches.noSPC     %%%%%Lifetime and spc_  ROI  calculations; Nick ROI -corrected for the background threashold
                a(roiN).time(fn) = datenum(spc.state.internal.triggerTimeString);
                a(roiN).time3(fn) = datenum(spc.state.internal.triggerTimeString);
            else
                a(roiN).time(fn) = datenum([spc.datainfo.date, ',', spc.datainfo.time]);
                a(roiN).time3(fn) = datenum(spc.datainfo.triggerTime);
                a(roiN).fraction2(fn) = tauD*(tauD-tau_m)/(tauD-tauAD) / (tauD + tauAD -tau_m);
                a(roiN).tauD(fn) = tauD;
                a(roiN).tauAD(fn) = tauAD;
                a(roiN).tau_m(fn) = tau_m;
                %end
                a(roiN).position{fn} = ROI;
                a(roiN).nPixel(fn) = nPixel;
                %                 a(roiN).mean_int(fn) = mean(F_int(:))- bg.mean_int(fn); % subtracting background from SPC mean data
                a(roiN).spc_mean(fn) = spc_mean - spc_bg_mean;
                a(roiN).spc_sum(fn) = spc_sum;
                a(roiN).spc_max(fn) = spc_max - spc_bg_mean;
            end
            if spc.switches.redImg    %%%%% RED and GREEN   ROI calculation
                %                      a(roiN).red_mean(fn) = mean(Red_F_int(:))- bg.RedMean_int(fn); % subtracting background from SPC mean data
                a(roiN).red_mean(fn)= red_mean -red_bg_mean;
                a(roiN).red_sum(fn) = red_sum;
                a(roiN).red_max(fn) = red_max - red_bg_mean;     
                a(roiN).red_nPixel(fn) = red_nPixel;
                a(roiN).red_position{fn} = redROIreg;
                
                a(roiN).green_mean(fn)= green_mean -green_bg_mean;
                a(roiN).green_sum(fn) = green_sum;
                a(roiN).green_max(fn) = green_max - green_bg_mean;
                a(roiN).green_nPixel(fn) = green_nPixel;
                a(roiN).green_position{fn} = greenROIreg;
            end
        
      end
 end
end 

% these values now display in thresholds.fig - AZ
  if ~spc.switches.noSPC
    mTextBox = uicontrol(thresholds, 'style','edit','Position', [70 60 60 20]);
    set(mTextBox,'string',spc_bg_mean);  %+2*spc_ab_std
    mTextBox1 = uicontrol(thresholds, 'style','edit', 'Position', [70 80 60 20]);
    set(mTextBox1,'string',spc_bg);  %spc_bg mean +2*spc_ab_std
  else
    mTextBox2 = uicontrol(thresholds, 'style','edit','Position', [290 100 60 20]);
    set(mTextBox2,'string',red_bg_mean+SD_BMFr*red_bg_std);
    mTextBox3 = uicontrol(thresholds, 'style','edit', 'Position', [290 180 60 20]);
    set(mTextBox3,'string',red_bg); %red_bg
  end

 if j==nRoi
    if ~spc.switches.noSPC
        mTextBox4 = uicontrol(thresholds, 'style','edit','Position', [70 20 60 20]);
        set(mTextBox4,'string',spine_spc_max/sdf); %+2*red_ab_std
    else
        mTextBox5 = uicontrol(thresholds, 'style','edit', 'Position', [290 250 60 20]);
        set(mTextBox5,'string',spine_red_max/rdf);
    end
 end

 if ~spc.switches.noSPC
    figure(8); %JZ
    newmat = project1; newmat(newmat<=spc_bg)=0;
    ROIregTemp(roipixels) = 255;
    cmap = colormap;
    newmap = cmap;
    newmap(1,:) = [0 0 0];
    colormap(newmap);
    colorbar
%     if dpixels == 1
%         image(newmat); alphamask(project2,[[1 0 0],0.03]);
%     else
    imagesc(newmat);alphamask(ROIregTemp,[[1 0 0],0.1]);
      %end
 else
 end

figure('Name','Red','NumberTitle','off'); %nicko
Rednewmat = img_redMax; Rednewmat(Rednewmat<red_bg)=0;
imagesc(Rednewmat);
redROIregTemp(redroipixels) = 255;
alphamask(redROIregTemp,[[Red Green Yellow],0.1]);
cmap = colormap;
newmap = cmap;
newmap(1,:) = [0 0 0];
colormap(newmap);
colorbar

figure('Name','Green','NumberTitle','off'); %nicko
greennewmat = img_greenMax; greennewmat(greennewmat<green_bg)=0;
imagesc(greennewmat);
greenROIregTemp(greenroipixels) = 255;
alphamask(greenROIregTemp,[[Red Green Yellow],0.1]);
cmap = colormap;
newmap = cmap;
newmap(1,:) = [0 0 0];
colormap(newmap);
colorbar

%         Ch(channelN).roiData = a;
%         Ch(channelN).bgData = bg;

if isfield(gui.spc.figure, 'polyRoi')
    if ishandle(gui.spc.figure.polyRoi{1})
        nPoly = length(gui.spc.figure.polyRoi);
    else
        nPoly = 0;
    end
else
    nPoly = 0;
end
if nPoly
    la = spc_calcpolyLines;
    evalc([fname, '.polyLines{fn} = la']);
    evalc(['tmp=', fname, '.polyLines']);
    for i=1:length(tmp)
        try
            dLen(i) = length(tmp{i}.fraction);
        catch
            dLen(i) = nan;
        end
    end
    len = min(dLen);
    %for j=1:length(tmp{1}.fraction);
    for i=1:length(tmp)
        try
            dend(i, 1:len) = tmp{i}.fraction(1:len);
        catch
            dend(i, 1:len) = nan(1, len);
        end
    end
    %end
    evalc([fname, '.Dendrite = dend']);
end
%     end

numROI = length(a);%-dpixels ; %nicko this line is for dendpixels calulations
 %numROI =nRoi;  % Nick Temp
ana.time3 = [];
ana.time = []; 
if ~spc.switches.noSPC
    ana.tau_m = [];
    ana.avetau = [];            %JZ - added in to calculate average tau_m of ROIs
    ana.spc_mean = [];           %nicko - added in to calculate average spc_mean int for all ROIs
    ana.ave_spc_mean = [];
    ana.spc_sum = [];
    ana.ave_spc_sum = [];   %nicko - added in to calculate average spc_mean int for all ROIs
    ana.red_mean = [];
    ana.ave_red_mean = [];
    ana.red_sum = [];
    ana.ave_red_sum = []; 
     for i = 1:numROI
        ana.time3(i,:) = a(i).time3;
        ana.time(i,:) = a(i).time;
        ana.tau_m(i,:) = a(i).tau_m;
        ana.spc_mean(i,:)= a(i).spc_mean;
        ana.avetau = nanmean(ana.tau_m);
        ana.ave_spc_mean = nanmean(ana.spc_mean); %NickO - added in to calculate average spc_mean int for all ROIs
        ana.spc_sum(i,:)= a(i).spc_sum;
        ana.ave_spc_sum = nanmean(ana.spc_sum);%NickO - added in to calculate integral spc_mean int for all ROIselse
        ana.red_sum(i,:)= a(i).red_sum;
        ana.red_mean(i,:)= a(i).red_mean;
     end

else
    ana.red_mean = [];
    ana.ave_red_mean = [];
    ana.red_sum = [];
    ana.ave_red_sum = []; 
    ana.green_mean = [];
    ana.ave_green_mean = [];
    ana.green_sum = [];
    ana.ave_green_sum = []; 
    ana.SpDendRatio = [];
    for i = 1:numROI
        ana.time3(i,:) = a(i).time3;
        ana.time(i,:) = a(i).time;
        ana.red_sum(i,:)= a(i).red_sum;
        ana.red_mean(i,:)= a(i).red_mean;
        ana.green_sum(i,:)= a(i).green_sum;
        ana.green_mean(i,:)= a(i).green_mean;
    end
    l = length(ana.green_mean);
    for i = 1:numROI-1 %nicko    calcultaion os Sp to Dendr ratio G/R normalised 
         for k =1: l
             ana.SpDendRatio(i,k)= (ana.green_mean(i,k)/ana.green_mean(DendROI,k))/(ana.red_mean(i,k)/ana.red_mean(DendROI,k));
         end
          %ana.SpDendRatio(i,:)= (ana.green_mean(i,:)./ana.green_mean(DendROI,:))./(ana.red_mean(i,:)./ana.red_mean(DendROI,:));
    end
end

% for i = 1:numROI
%     
%     ana.time3(i,:) = a(i).time3;
%     ana.tau_m(i,:) = a(i).tau_m;
%     ana.spc_mean(i,:)= a(i).spc_mean;
%     ana.avetau = nanmean(ana.tau_m);
%     ana.ave_spc_mean = nanmean(ana.spc_mean); %NickO - added in to calculate average spc_mean int for all ROIs
%     ana.spc_sum(i,:)= a(i).spc_sum;
%     ana.ave_spc_sum = nanmean(ana.spc_sum);%NickO - added in to calculate integral spc_mean int for all ROIs
    
%     ana.red_sum(i,:)= a(i).red_sum;
%     ana.red_mean(i,:)= a(i).red_mean;
%     ana.green_sum(i,:)= a(i).green_sum;
%     ana.green_mean(i,:)= a(i).green_mean;
    
%end



%evalc ([fname, '.stack = stack']);
%save(fname, fname);                    %JZ
%Aout = a;
%%%%%%%%%%%%%%%%%%%%%%%%
a(1).filename = fname;                       %JZ
evalc ([fname, '.roiData = a']);             %JZ
evalc ([fname, '.bgData = bg']);             %JZ
evalc ([fname, '.analyzeData = ana']);       %JZ

save(fname, fname, fname);                   %JZ



%Figure
figFormat = [3, 1]; %3 by 1 subplot.
color_a = {[0.7,0.7,0.7], 'red', 'blue', 'green', 'magenta', 'cyan', [1,0.5,0],'black'};
if ~spc.switches.noSPC
    %      fig_content = {'tau_m', 'int_int2', 'dendpixels'};
    fig_content = {'tau_m', 'spc_mean', 'red_mean'};
    fig_yTitle = {'Lifetime', 'SPC mean', 'Red mean'};
else
    fig_content = {'SpDendRatio', 'green_mean', 'red_mean'};
    fig_yTitle = {'S/D ratio', 'green mean', 'red mean'};
end

for subP = 1:3  %Three figures
    error = 0;
    
    figure (gui.spc.calcRoi);
    subplot(figFormat(1), figFormat(2), subP);
    hold off;
    legstr = [];
    sval = zeros(1);
    
    %if subP ~=3
    
    for j=1:nRoi-1 -(nRoi -dpixels)
        if ishandle(gui.spc.figure.roiB(j+1))
            k = mod(j, length(color_a))+1;
            if page3 ==1
                time1 = a(j).time3;
            else
                time1 = a(j).time;
            end
            time1 = time1(a(j).time > 1000);
            if j==1 && subP == 1
                basetime = min(time1);
            end
            t = (time1 - basetime)*24*60;
            
            ana.time = [];                 %saves time values in .mat file JZ
            ana.time = t;
            
%            if subP == 1 %added by nicko  
%                evalc(['val = ana.', fig_content{subP} '(j,:)']); %added by nicko
%                %val = ana.SpDendRatio(j,:); %added by nicko           
%                val = val(a(j).time > 1000);
%            else
               evalc(['val = ana.', fig_content{subP} '(j,:)']); %nicko 
               %evalc(['val = a(j).', fig_content{subP}]); %nicko
              val = val(a(j).time > 1000);
           end          
%             val = val(a(j).time > 1000);
            if length(sval)<length(val)
                sval = padarray(sval, [0, length(val) - length(sval)], 'post'); %adds val together in order to calculate and plot average later JZ
            else        %  if-else added by HS for the case of one ROI being added later, where length(val)<length(sval)
                val = padarray(val, [0, length(sval)-length(val)], 'post');
            end
            for i = 1:length(val)
                sval(i) = sval(i) + val(i);
            end
%              if subP == 1
% %                 plot(t, val, 'color', 'black');
%                   plot(t, val, '-o', 'color', color_a{k});
%              else
                 if length(t) == length(val)
                   plot(t, val, '-o', 'color', color_a{k});
                 else
               plot(val, '-o', 'color', color_a{k});
               error = 1;
                 end  
%              end
            hold on;
%               if subP == 1
%                  str1 = sprintf('ROI%02d', j);
% %                   str1 = 'red bg ROI';
%                  legstr = [legstr; str1];
%                  legstr = str1;
%               else 
                str1 = sprintf('ROI%02d', j);
                legstr = [legstr; str1];
              %end
        end
    %end
    %else
%     if subP ~=3 && dpixels == 1
%         evalc(['val = ana.', fig_content{subP}]);
%         dendIndex = find(val);
%         graphDend = val(dendIndex);
%         timeDend = t(dendIndex);
%         plot(timeDend, graphDend, '-ob', 'LineWidth', 1.5);
%         axis([min(t) max(t) (min(graphDend) - 2) (max(graphDend) + 2) ])
%     end
    %if subP ~=3 && dpixels == 0
    % evalc(['val = a(j).', fig_content{subP}]);
    %val = val(a(j).time > 1000);
    %plot(t, sval, '-ok', 'LineWidth', 1.5);
    %             axis([min(t) max(t) (min(graphDend) - 2) (max(graphDend) + 2) ])
    %end
 %end
    
    
%  if subP ~= 3% && dpixels == 0
    if plotave ==1 %&& dpixels == 0
        slegstr = size(legstr);               %to find number of ROI (nRoi sometimes unreliable)
        aveval = sval./(slegstr(1));          %finds average of "val"  JZ
        hold on;
        plot(t, aveval, '-ok', 'LineWidth', 1.5);
        legend(legstr);
    end
 
    ylabel(['\fontsize{12} ', fig_yTitle{subP}]);
    slegstr = size(legstr);               %to find number of ROI (nRoi sometimes unreliable)
    hold on;
    %         plot(t, val, '-ok', 'LineWidth', 1.5);
    legend(legstr);
    
    if ~error
        xlabel ('\fontsize{12} Time (min)');
    else
        xlabel ('\fontsize{12} ERROR');
    end
%  end
end

a(1).filename = fname;                       %JZ
evalc ([fname, '.roiData = a']);             %JZ
evalc ([fname, '.bgData = bg']);             %JZ
evalc ([fname, '.analyzeData = ana']);       %JZ
save(fname, fname, fname);


end
