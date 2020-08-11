function a = spc_calcRoi;
global spc;
global gui;

filterwindow = 3; %3x3 smoothing before calculation
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
evalc(['global  ', fname]);
if exist([fname, '.mat'])
    load([fname, '.mat'], fname);
    evalc(['a = ', fname, '.roiData']);
    evalc(['bg = ', fname, '.bgData']);
    evalc(['ana = ', fname, '.analyzeData']);           %added by JZ
end

nRoi = length(gui.spc.figure.roiB);
if ~spc.switches.noSPC
    range = spc.fit.range;
end

%project1 = filter2(ones(filterwindow,filterwindow)/filterwindow^2, spc.project);
project1 =spc.project;
if spc.switches.redImg
    img_greenMax = filter2(ones(filterwindow,filterwindow)/filterwindow^2, spc.state.img.greenMax);
    img_redMax = filter2(ones(filterwindow,filterwindow)/filterwindow^2, spc.state.img.redMax);
end

%img_redMax = spc.state.img.redMax;
pos_max2 = str2num(get(gui.spc.spc_main.F_offset, 'String'));
if pos_max2 == 0 | isnan (pos_max2)
    pos_max2 = 1.0
end

newroiTemp = project1 * 0;% NIckO
for j = 1:nRoi
    if ishandle(gui.spc.figure.roiB(j));
        siz = spc.size;
        goodRoi = 1;
        if strcmp(get(gui.spc.figure.roiB(j), 'Type'), 'rectangle')
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
            
            if j == 1
                bg_intensity = project1(ROIreg);
                bg_intensity = bg_intensity(~isnan(bg_intensity));
                avg_bg_intensity = mean(bg_intensity(:));
                ab_std = std2(bg_intensity);
            end
             
        elseif strcmp(get(gui.spc.figure.roiB(j), 'Type'), 'line')
            xi = get(gui.spc.figure.roiB(j),'XData');
            yi = get(gui.spc.figure.roiB(j),'YData');
            ROIreg = roipoly(ones(siz(2), siz(3)), xi, yi);
            ROI = [xi(:), yi(:)];
        else
            ROI = 0;
            goodRoi = 0;
        end
     
        spc_avg_bg =spc.switches.lutlim(1); %*avg_bg_intensity; NickO
        spc_ab_std = 0;%*ab_std;  NickO
        
         
        if goodRoi
            newroi = project1 * 0;
            if j~=1,            %ROI restricted to pixels spc_avg_bg+spc_ab_std above the background intensity
               %figure(9);
               %subplot(2,2,1); image(project1);
               %oldroi = project1*0;
               %oldroi(ROIreg) = 255;
               %subplot(2,2,2); image(oldroi);
               roipixels=intersect(find(ROIreg),find(project1>spc_avg_bg+spc_ab_std));
               newroiTemp(roipixels) = 255;  
               newroi(roipixels) = 255;       
               %subplot(2,2,2); image(newroi);
               %subplot(2,2,3); image(newroiTemp);
               ROIreg = newroi>1; 
               ROIregTemp = newroiTemp>1; 
           end;
                        
                        
            if j ~= 1
                if ~spc.switches.noSPC
                    bw = (spc.project >= spc.switches.lutlim(1));   %bw= low threshold for lifetime image       
                    lifetimeMap = spc.lifetimeMap(bw & ROIreg);     %lifetime values in all pixels in a current ROI that are higher than lower threshold
                    %lifetimeMap = spc.lifetimeMap(ROIreg);
                    project = spc.project(bw & ROIreg);       %SPC values in all pixels in a current ROI that are higher than lower threshold
                    lifetime = sum(lifetimeMap.*project)/sum(project); %calculates average of LT in a current ROI above the thresholod bw
                   
                    t1 = (1:range(2)-range(1)+1); t1 = t1(:);
                    tauD = spc.fit.beta0(2)*spc.datainfo.psPerUnit/1000;
                    tauAD = spc.fit.beta0(4)*spc.datainfo.psPerUnit/1000;
                    tau_m = lifetime; %average of LT in a current ROI above the thresholod bw
                end
            end

            F_int = project1(ROIreg);
            F_int = F_int(~isnan(F_int));

%             

            intensity = sum(F_int(:));
            nPixel = intensity / mean(F_int(:));
            
            roiN = j-1;

            if roiN == 0 | roiN == [] %%%%%Background calculation
                if spc.switches.noSPC
                    bg.time(fn) = datenum(spc.state.internal.triggerTimeString);
                else
                    bg.time(fn) = datenum([spc.datainfo.date, ',', spc.datainfo.time]);
                end
                bg.position{fn} = ROI;
                bg.mean_int(fn) = mean(F_int(:));
                bg.nPixel(fn) = nPixel;
                bg.mean_int(fn) = mean(F_int(:));
                if spc.switches.redImg
                    green_R = img_greenMax(ROIreg);
                    bg.green_int(fn) = sum(green_R);
                    bg.green_mean(fn) = mean(green_R);
                    bg.green_nPixel(fn) = bg.green_int(fn) / bg.mean_int(fn);             
                    red_R = img_redMax(ROIreg);
                    bg.red_int(fn) = sum(red_R);
                    bg.red_mean(fn) = mean(red_R);
                    bg.red_nPixel(fn) = bg.red_int(fn) / bg.mean_int(fn);
                end

            else 
                if spc.switches.noSPC
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
                a(roiN).mean_int(fn) = mean(F_int(:))- bg.mean_int(fn); % subtracting background from SPC mean data
                a(roiN).int_int2(fn) = a(roiN).mean_int(fn)*a(roiN).nPixel(fn)-bg.mean_int(fn)*a(roiN).nPixel(fn);
                a(roiN).max_int(fn) = max(F_int(:)) - bg.mean_int(fn);

                if spc.switches.redImg
                    red_R = img_redMax(ROIreg);
                    a(roiN).red_int(fn) = sum(red_R);
                    a(roiN).red_mean(fn) = mean(red_R) - bg.red_mean(fn);
                    a(roiN).red_nPixel(fn) = a(roiN).red_int(fn) / mean(red_R);
                    a(roiN).red_int2(fn) = a(roiN).red_mean(fn)*a(roiN).red_nPixel(fn);
                    a(roiN).red_max(fn) = max(red_R) -  bg.red_mean(fn);
                    green_R = img_greenMax(ROIreg);
                    a(roiN).green_int(fn) = sum(green_R);
                    a(roiN).green_mean(fn) = mean(green_R) - bg.green_mean(fn);
                    a(roiN).green_nPixel(fn) = a(roiN).green_int(fn) / mean(green_R);
                    a(roiN).green_int2(fn) = a(roiN).green_mean(fn)*a(roiN).green_nPixel(fn);
                    a(roiN).green_max(fn) = max(green_R) -  bg.green_mean(fn);
                    a(roiN).ratio = a(roiN).green_mean./a(roiN).red_mean;

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

                end %reImg

            end %Background
        end %%%Good Roi
    end %%%is handle
end


%added by JZ, displays pixels above threshold on wholeimage
             %ROI restricted to pixels spc_avg_bg+spc_ab_std above the background intensity
               
          
           
%figure(7);
%newmat = project1; newmat(newmat<spc_avg_bg+spc_ab_std)=0; 
%subplot(2,1,1);image(newmat);
%newroiTemp(roipixels) = 255;         
%subplot(2,1,2); image(newroiTemp);
%cmap = colormap;
%newmap = cmap;
%newmap(1,:) = [0 0 0];
%colormap(newmap);

figure(8); 
newmat = project1; newmat(newmat<spc_avg_bg+spc_ab_std)=0;
newroiTemp(roipixels) = 255;
image(newmat); alphamask(ROIregTemp,[[1 0 0],0.1]);
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


ana.tau_m = [];                             %JZ - added in to calculate average tau_m of ROIs
ana.avetau = [];
ana.mean_int = [];           %NickO - added in to calculate average spc_mean int for all ROIs
ana.avemean_int = [];                       
ana.int_int2 = [];           %NickO - added in to calculate average spc_mean int for all ROIs
ana.aveint_int2 = []; 
for i = 1:length(a)
    ana.tau_m(i,:) = a(i).tau_m;
    ana.avetau = nanmean(ana.tau_m);
    ana.mean_int(i,:)= a(i).mean_int;    %NickO - added in to calculate average spc_mean int for all ROIs
    ana.avemean_int = nanmean(ana.mean_int);
    ana.int_int2(i,:)= a(i).int_int2;    %NickO - added in to calculate average spc_mean int for all ROIs
    ana.aveint_int2 = nanmean(ana.int_int2);
end

%a(1).filename = fname;   
%evalc ([fname, '.roiData = a']);       %JZ
%evalc ([fname, '.bgData = bg']);       %JZ
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
    fig_content = {'tau_m', 'int_int2', 'red_mean'};
    fig_yTitle = {'Lifetime', 'Integral Intensity', 'Mean(Red)'};
else
    fig_content = {'ratio', 'int_int2', 'red_int2'};
    fig_yTitle = {'Ratio', 'Intensity(Green)', 'Intensity(Red)'};    
end
        
for subP = 1:3  %Three figures
    error = 0;

    figure (gui.spc.calcRoi);
    subplot(figFormat(1), figFormat(2), subP);
    hold off;
    legstr = [];
    sval = zeros(1);
    for j=1:nRoi-1
        if ishandle(gui.spc.figure.roiB(j+1))
            k = mod(j, length(color_a))+1;
            time1 = a(j).time;
            time1 = time1(a(j).time > 1000);
            if j==1 && subP == 1
                basetime = min(time1);
            end
            t = (time1 - basetime)*24*60;
            ana.time = [];                 %saves time values in .mat file JZ
            ana.time = t;                  
            
            evalc(['val = a(j).', fig_content{subP}]);
            val = val(a(j).time > 1000);                        
            
            sval = padarray(sval, [0 length(val) - length(sval)], 'post'); %adds val together in order to calculate and plot average later JZ
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
     
    end;
    
    aveval = sval./(nRoi - 1);          %finds average of "val"  JZ
            hold on;
            plot(t, aveval, '-ok', 'LineWidth', 1.5);
   
    legend(legstr);
    ylabel(['\fontsize{12} ', fig_yTitle{subP}]);
            
    
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
