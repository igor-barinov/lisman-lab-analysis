function a = spc_calcRoi;
global spc;
global gui;
global spc_bg;
global Red_bg;

filterwindow = 1; %seting filter. if =3 makes 3x3 smoothing before calculation-nick
BMF =1; %backgraund multiplication factor over (avg_bg_intensity+2*ab_std); if BMF=0 then background = low threthould LUT in lifetime map fig3-nick
BMFr=1;
plotave =0;%-nick
page3 = 1;%-nick
dpixels=0;%   Make dpixels=1 if dendpixels are calculated in the last region-nick
%goodRoi = 1; %indicates presence of  ROIs

if length(findobj('Tag', 'RoiA0')) == 0
    beep;
    errordlg('Set the background ROI (roi 0)!');
    return;
end

[filepath, basename, fn, max1] = spc_AnalyzeFilename(spc.filename);
fpos = [53   192   568   713];
if isfield(gui.spc, 'calcRoi')
     if ishandle(gui.spc.calcRoi)
     else
         gui.spc.calcRoi = figure ('position', fpos);
     end
 else
      gui.spc.calcRoi = figure ('position', fpos);
end


spc_updateMainStrings;
spc.filename,
name_start=findstr(spc.filename, filesep);  % replaced '\' with filesep   % or use fileparts
name_start=name_start(end)+1;

cd (filepath);

fname = [basename, '_ROI2'];
evalc(['global  ', fname]);   %loads _ROI2
if exist([fname, '.mat'])
    load([fname, '.mat'], fname);
    evalc(['a = ', fname, '.roiData']);
    evalc(['bg = ', fname, '.bgData']);
    evalc(['ana = ', fname, '.analyzeData']);           %added by JZ
end

nRoi = length(gui.spc.figure.roiB);
% nRoi=3;

if ~spc.switches.noSPC
    range = spc.fit.range;
end

project1 = filter2(ones(filterwindow,filterwindow)/filterwindow^2, spc.project);

if spc.switches.redImg
    img_greenMax = filter2(ones(filterwindow,filterwindow)/filterwindow^2, spc.state.img.greenMax);
    img_redMax = filter2(ones(filterwindow,filterwindow)/filterwindow^2, spc.state.img.redMax);
end

pos_max2 = str2num(get(gui.spc.spc_main.F_offset, 'String'));
if pos_max2 == 0 | isnan (pos_max2)
    pos_max2 = 1.0
end

newroiTemp = project1 * 0;% NickO
newRedroiTemp = img_redMax*0;% NickO

if exist('a','var') && length(a) < nRoi  % HS; to work, Roi's must be added in order
    for roiN=length(a)+1:nRoi-1            % this is so that new Roi's have data structures of same length as previous Roi's
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
        
%         a(roiN).green_int = nan(size(a(1).green_int));
%         a(roiN).green_mean = nan(size(a(1).green_mean));
%         a(roiN).green_nPixel = nan(size(a(1).green_nPixel));
%         a(roiN).green_int2 = nan(size(a(1).green_int2));
%         a(roiN).green_max = nan(size(a(1).green_max));
        %ana(roiN).dendpixels= nan(size(ana(1).dendpixels)); %nick ana.dendpixels
                   
    end
end

for j = 1:nRoi
    if ishandle(gui.spc.figure.roiB(j));
        siz = spc.size;
        goodRoi = 1; %indicates presence of  ROIs
        if strcmp(get(gui.spc.figure.roiB(j), 'Type'), 'rectangle')   % loads ROIs
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
            
            if j == 1  % background ROI 
               if ~spc.switches.noSPC  %SPC image background ROI statistics
                bg_intensity = project1(ROIreg);
                bg_intensity = bg_intensity(~isnan(bg_intensity));
                spc_bg_mean = mean(bg_intensity(:));
                spc_ab_std = std2(bg_intensity);
                spc_bg_nPixels = sum(bg_intensity)/spc_bg_mean;
                
                %bw = (spc.project >= spc.switches.lutlim(1));   %bw = SPC image above the spc.switches.lutlim(1)= low threshold for FLIM image
                %spc_background=spc.switches.lutlim(1); %avg_bg_intensity+4*ab_std %NickO
                spc_background=BMF*(spc_bg_mean+2*spc_ab_std); %NickO:this background is to find cell borders in spc and FLIM image data but not to subtruct from the signal
                if BMF == 0
                  spc_background=spc.switches.lutlim(1); %avg_bg_intensity+4*ab_std %NickO
                else
                end
               end 
               if spc.switches.redImg   %%%%%RED and GREEN images Background ROI statistics-nick
%                     green_R = img_greenMax(ROIreg);
%                     bg_green_int = sum(green_R);
%                     bg_green_mean = mean(green_R);
%                     bg_green_nPixel = bg.green_int(fn) / bg.mean_int(1);             
              
                red_bg_intensity = img_redMax(ROIreg);
                red_bg_intensity = red_bg_intensity(~isnan(red_bg_intensity));
                red_bg_mean = mean(red_bg_intensity(:));
                red_ab_std = std2(red_bg_intensity);
                red_bg_nPixels = sum(red_bg_intensity)/red_bg_mean;
               
                red_background = BMFr*(red_bg_mean+2*red_ab_std); %NickO:this background is to find cell borders in spc and FLIM image data but not to subtruct from the signal
%                 if BMF == 0
%                   Red_background=spc.switches.lutlim(1); %avg_bg_intensity+4*ab_std %NickO
%                 else
%                 end
               end 
%                        
            end
             spc_bg = spc_background;  %this line just to show the background value in the history window  
             Red_bg = red_background;
                figure (14); 
                mTextBox = uicontrol('style','text');
                set(mTextBox,'string',spc_bg);
                mTextBox1 = uicontrol('style','text', 'Position', [21 74 60 20]);
                set(mTextBox1,'string',Red_bg);  
         
                          
            
                
        elseif strcmp(get(gui.spc.figure.roiB(j), 'Type'), 'line')% for polygonal ROI? -nick
            xi = get(gui.spc.figure.roiB(j),'XData');
            yi = get(gui.spc.figure.roiB(j),'YData');
            ROIreg = roipoly(ones(siz(2), siz(3)), xi, yi);
            ROI = [xi(:), yi(:)];
        else
            ROI = 0;
            goodRoi = 0; %indicates that NO ROIs are present
           end
        end
     
                  
        if goodRoi        
                              
            if ~spc.switches.noSPC    
                    newroi = project1 * 0;
                                        
               if j~=1,       %for good (NOT backgraound) ROIs in SPC image    
                 roipixels=intersect(find(ROIreg),find(project1>=spc_bg));  %makes NOTbackgraound ROIs in spc_images restricted to pixels above the spc_background intensity
                 newroi(roipixels) = 255;       
                 ROIreg = newroi>1;   %ROI pixels above the SPC background!!!!!!!!!!!!!!!!!!!!!!!!!!!!!                          
                  if j < nRoi+1-dpixels  % use j<nRoi if dendpixels are calculated  NIck
                    newroiTemp(roipixels) = 255;  
                    ROIregTemp = newroiTemp>1; 
                  end
                F_int = project1(ROIreg);   % calcultes statistics in ROIs of spc-images corrected  for the spc_background threshold!
                F_int = F_int(~isnan(F_int));
                spc_sum = sum(F_int(:));
                spc_mean = mean(F_int(:));
                nPixel = spc_sum/spc_mean;
                spc_max =max(F_int(:));
                  
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
                 if j~=1,       %for good (NOT backgraound) ROIs in Red image  
                   newRedroi =  img_redMax*0;
                   Redroipixels=intersect(find(ROIreg),find(img_redMax>=Red_bg));  
                   newRedroi(Redroipixels) = 255;       
                   RedROIreg = newRedroi>1;   %ROI pixels above the REd background !!!!!!!!!!!!!!!  
%                     if j < nRoi+1-dpixels  % use j<nRoi if dendpixels are calculated  NIck                  
%                      newRedroiTemp(Redroipixels) = 255;  
%                      RedROIregTemp = newRedroiTemp>1;
%                     end
                   red_F_int = img_redMax(RedROIreg);   % calcultes statistics in ROIs of Red-images corrected  for the spc_background threshold!
                   red_F_int = red_F_int(~isnan(red_F_int));
                   red_sum = sum(red_F_int(:));
                   red_nPixel = red_sum / mean(red_F_int(:));
                   red_mean = mean(red_F_int(:));
                   red_max =max(red_F_int(:));
                 end
            end                 
                      
            roiN = j-1;   %makes roiN start with 0; roiN=0 = background ROI

            if roiN == 0 | roiN == [] %%%%%Background of spc ROI calculation
                if spc.switches.noSPC
                    bg.time(fn) = datenum(spc.state.internal.triggerTimeString);
                else
                    bg.time(fn) = datenum([spc.datainfo.date, ',', spc.datainfo.time]);
                end
                bg.position{fn} = ROI;
                bg.mean_int(fn) =spc_bg_mean;
                bg.nPixel(fn) = spc_bg_nPixels;
               
                if spc.switches.redImg   %%%%%Background of RED and GREEN ROI calculation NIck
%                     green_R = img_greenMax(ROIreg);
%                     bg.green_int(fn) = sum(green_R);
%                     bg.green_mean(fn) = mean(green_R);
%                     bg.green_nPixel(fn) = bg.green_int(fn) / bg.mean_int(fn);             
                    bg.red_position{fn} = ROI;
                    bg.red_mean_int(fn) = red_bg_mean;
                    bg.red_nPixel(fn) = red_bg_nPixels;

               end

            else 
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
                end
                a(roiN).position{fn} = ROI;
                a(roiN).nPixel(fn) = nPixel;
%                 a(roiN).mean_int(fn) = mean(F_int(:))- bg.mean_int(fn); % subtracting background from SPC mean data
                a(roiN).mean_int(fn) =spc_mean - spc_bg_mean;
                a(roiN).int_int2(fn) = spc_sum;
                a(roiN).max_int(fn) = spc_max - spc_bg_mean;
                
                if spc.switches.redImg    %%%%% RED and GREEN   ROI calculation
%                      a(roiN).red_mean(fn) = mean(Red_F_int(:))- bg.RedMean_int(fn); % subtracting background from SPC mean data
                       a(roiN).red_mean(fn)= red_mean -red_bg_mean;
                       a(roiN).red_int2(fn) = red_sum;
                       a(roiN).red_max(fn) = red_max - red_bg_mean;
                                        
%                     a(roiN).red_int(fn) = sum(red_R);
% %                   a(roiN).red_mean(fn) = (mean(red_R) - bg.red_mean(fn))/(mean(F_int(:))- bg.mean_int(fn));
%                     a(roiN).red_mean(fn) = (mean(red_R) - bg.red_mean(fn));
                      a(roiN).red_nPixel(fn) = red_nPixel;
%                     a(roiN).red_int2(fn) = a(roiN).red_mean(fn)*a(roiN).red_nPixel(fn);
%                     a(roiN).red_max(fn) = max(red_R) -  bg.red_mean(fn);
%                     
%                       green_R = img_greenMax(ROIreg);
%                     a(roiN).green_int(fn) = sum(green_R);
%                     a(roiN).green_mean(fn) = mean(green_R) - bg.green_mean(fn);
%                     a(roiN).green_nPixel(fn) = a(roiN).green_int(fn) / mean(green_R);
%                     a(roiN).green_int2(fn) = a(roiN).green_mean(fn)*a(roiN).green_nPixel(fn);
%                     a(roiN).green_max(fn) = max(green_R) -  bg.green_mean(fn);
%                     a(roiN).ratio = a(roiN).green_mean./a(roiN).red_mean;
%                     
                    
                    
                    
    %                 siz = size(spc.state.img.greenImg);%%%%%%%Calculate stack
    %                 if length(siz) == 3
    %                     stack.roiData(roiN).green_nPixel(fn) = bg.green_nPixel(fn);
    %                     stack.roiData(roiN).red_nPixel(fn) = bg.red_nPixel(fn);
    %                     for i=1:siz(3)
    %                         imgi = spc.state.img.greenImg(:,:,i);
    %                         green_R = imgi(ROIreg);
    %                         stack.roiData(roiN).mean_green{fn}(i) = mean(green_R, 1);
    % 
    %                         imgi = spc.state.img.redImg(:,:,i);
    %                         red_R = imgi(ROIreg);
    %                         stack.roiData(roiN).mean_red{fn}(i) = mean(red_R, 1);
    %                     end
    %                 end

%                     if  j == nRoi                           %  for the last ROI calculation                  
%                    ROIdend=imabsdiff(ROIreg,ROIregTemp);  %finds dendr image  NIck
%                    figure (13); image(ROIdend); colormap(hot(5)); % plots dendr image  NIck
                    
                   %spixels= ROIreg(ROIregTemp);
%                    spixels = intersect(find(ROIreg),find(ROIregTemp));
%                    Redspixels = intersect(find(ROIreg),find(RedROIregTemp))
%                    numdendpix = nPixel -  length(spixels);
%                       if numdendpix > length(spixels)           % pixels in the last ROI> then sum of spines
%                          ana.dendpixels(fn) = numdendpix;
%                          %ana.sdoverlap(fn) = length(spixels);
%                          project2 = project1 * 0;
%                          project2(ROIreg) = 1;
%                          project2(spixels) = 0;
%                      end
                   end 
            end 
                
        end
        
       
        
end
figure(8); %JZ
newmat = project1; newmat(newmat<=spc_bg)=0;
ROIregTemp(roipixels) = 255;
if dpixels == 1
    image(newmat); alphamask(project2,[[1 0 0],0.1]);
else
    imagesc(newmat);alphamask(ROIregTemp,[[1 0 0],0.1]);
end
cmap = colormap;
newmap = cmap;
newmap(1,:) = [0 0 0];
colormap(newmap);
colorbar



figure(9); %nick
Rednewmat = img_redMax; Rednewmat(Rednewmat<Red_bg)=0;
imagesc(Rednewmat);
ROIregTemp(roipixels) = 255;
alphamask(ROIregTemp,[[1 0 0],0.1]);
cmap = colormap;
newmap = cmap;
newmap(1,:) = [0 0 0];
colormap(newmap);
colorbar

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


ana.tau_m = [];  
ana.time3 = [];  
ana.red_mean = []; 
ana.avetau = [];            %JZ - added in to calculate average tau_m of ROIs
ana.mean_int = [];           %NickO - added in to calculate average spc_mean int for all ROIs
ana.avemean_int = [];                       
ana.int_int2 = [];  
ana.red_mean = [];  
ana.aveint_int2 = [];       %NickO - added in to calculate average spc_mean int for all ROIs
% numROI = length(a) - 1;  this line is for dendpixels calulations
numROI = length(a)-dpixels ; %Nick this line is for dendpixels calulations
% numROI =nRoi;  % Nick Temp
for i = 1:numROI
    ana.time3(i,:) = a(i).time3;
    ana.tau_m(i,:) = a(i).tau_m;
    ana.mean_int(i,:)= a(i).mean_int; 
    ana.red_mean(i,:)= a(i).red_mean;
    ana.avetau = nanmean(ana.tau_m);    %NickO - added in to calculate average spc_mean int for all ROIs
    ana.avemean_int = nanmean(ana.mean_int);
    ana.int_int2(i,:)= a(i).int_int2;   
    ana.aveint_int2 = nanmean(ana.int_int2);%NickO - added in to calculate integral spc_mean int for all ROIs
end



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
     fig_content = {'tau_m', 'mean_int', 'red_mean'};
     fig_yTitle = {'Lifetime', 'SPC G mean', 'Red mean'};
 else
    fig_content = {'ratio', 'int_int2', 'red_mean'};
    fig_yTitle = {'Ratio', 'Intensity(Green)', 'Intensity(Red)'};    
end
        
for subP = 1:3  %Three figures
    error = 0;

    figure (gui.spc.calcRoi);
    subplot(figFormat(1), figFormat(2), subP);
    hold off;
    legstr = [];
    sval = zeros(1);
    
    %if subP ~=3 
        for j=1:nRoi-1-dpixels         
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
               
                %if timeinterval ~=0       %Nick Next 3 line remake time using fixed time interval
                   % for m=1:length(time1)
                     %  t(m)=m*timeinterval;
                   % end
                %end     
                ana.time = [];                 %saves time values in .mat file JZ
                ana.time = t;   
            
                evalc(['val = a(j).', fig_content{subP}]);
                val = val(a(j).time > 1000);                        
                if length(sval)<length(val)
                    sval = padarray(sval, [0, length(val) - length(sval)], 'post'); %adds val together in order to calculate and plot average later JZ
                else        %  if-else added by HS for the case of one ROI being added later, where length(val)<length(sval)
                    val = padarray(val, [0, length(sval)-length(val)], 'post');
                end
                for i = 1:length(val)
                    sval(i) = sval(i) + val(i);
               end
                if length(t) == length(val)
                    plot(t, val, '-o', 'color', color_a{k});  
                else
                    plot(val, '-o', 'color', color_a{k});
                    error = 1;
                end
                hold on;
                str1 = sprintf('ROI%02d', j);
                legstr = [legstr; str1];
            
            end                      
        end
    %else
        if subP ~=3 && dpixels == 1
            evalc(['val = ana.', fig_content{subP}]);
            dendIndex = find(val);
            graphDend = val(dendIndex);
            timeDend = t(dendIndex);
            plot(timeDend, graphDend, '-ob', 'LineWidth', 1.5);
            axis([min(t) max(t) (min(graphDend) - 2) (max(graphDend) + 2) ])
        end
         %if subP ~=3 && dpixels == 0
           % evalc(['val = a(j).', fig_content{subP}]);
            %val = val(a(j).time > 1000); 
            %plot(t, sval, '-ok', 'LineWidth', 1.5);
%             axis([min(t) max(t) (min(graphDend) - 2) (max(graphDend) + 2) ])
        %end
    %end
    
    
    %if subP ~= 3 && dpixels == 0
    if plotave ==1&& dpixels == 0
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
end


a(1).filename = fname;                       %JZ 
evalc ([fname, '.roiData = a']);             %JZ
evalc ([fname, '.bgData = bg']);             %JZ
evalc ([fname, '.analyzeData = ana']);       %JZ
save(fname, fname, fname); 


end
