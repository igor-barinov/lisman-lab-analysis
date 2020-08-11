function Nick_AnalysisJZ
% global yphys
global windowsize
global numstring
global loadnum
global a


%set windows for analyis
windowsize = 10;
baseLine = [0.1, 9]; %ms  baseline window in ms (from to)%
timewindow = [14, 17]; % ms peak  window in ms (from to) %originally [12, 20]]
slopewindow = [11.5, 14];

% set dir
a = dir('yphys*.mat');
f1 = ones(windowsize, 1)/windowsize;


figure('Name','Nick Analysis','Color',[1 1 1],'MenuBar', 'none');
%%%%%%%%%%%%%%%%%%%% GUI settup
uicontrol('style','text','BackgroundColor','white',...
    'Position',[300 345 70 20], 'String', 'load file:');
uicontrol('style','pushbutton', 'Position',[360 340 40 40], ...
    'String', '<<','CallBack',@loadprev);
loadnum = uicontrol('style','edit', 'Position',[400 340 40 40], ...
    'String', '1','BackgroundColor', 'white');
uicontrol('style','pushbutton', 'Position',[440 340 40 40], ...
    'String', '>>',...
    'Visible','on','CallBack',@loadnext);

uicontrol('style','text','BackgroundColor','white',...
    'Position',[300 305 70 20], 'String', 'peak:');
peakstr1 = uicontrol('style','edit', 'Position',[360 300 40 40], ...
    'String', timewindow(1),'BackgroundColor', 'white');
peakstr2 = uicontrol('style','edit', 'Position',[400 300 40 40], ...
    'String', timewindow(2),'BackgroundColor', 'white');

uicontrol('style','text','BackgroundColor','white',...
    'Position',[300 265 70 20], 'String', 'slope:');
slopestr1 = uicontrol('style','edit', 'Position',[360 260 40 40], ...
    'String', slopewindow(1),'BackgroundColor', 'white');
slopestr2 = uicontrol('style','edit', 'Position',[400 260 40 40], ...
    'String', slopewindow(2),'BackgroundColor', 'white');

uicontrol('style','pushbutton', 'Position',[440 260 40 40], ...
    'String', 'Go',...
    'Visible','on','CallBack',@loadpushfn);
%%%%%%%%%%%%%%%%%%%% GUI settup

numstring = 1;  
presentdatafn


    function loadpushfn(source, eventdata)
        numstring = str2num(get(loadnum,'String'));
        presentdatafn
    end

    function loadprev(source, eventdata)
        numstring = str2num(get(loadnum,'String')) - 1;
        presentdatafn
    end

    function loadnext(source, eventdata)
        numstring = str2num(get(loadnum,'String')) + 1;
        presentdatafn
    end

    function presentdatafn  
        timewindow1 = str2num(get(peakstr1,'String'));
        timewindow2 = str2num(get(peakstr2,'String'));
        slopewindow1 = str2num(get(slopestr1,'String'));
        slopewindow2 = str2num(get(slopestr2,'String'));
        
        set(loadnum,'String',numstring);   
        uicontrol('style','text','Position',[425 10 100 20],...
            'BackgroundColor','white', 'String',a(numstring).name);
        dataset = load(a(numstring).name);
        
        % "a(numstring).name(1:end-4)" is just "yphys###)
        data1 = dataset.(a(numstring).name(1:end-4));
        data_yphys = data1.data(:,2);
        
        plot(data1.data(:,1),data_yphys,'LineWidth',1);
        %axis([0 50 0 550]); 
        hold on;
        meanpeak = mean(data_yphys(timewindow1:timewindow2));
        x1 = [timewindow1,timewindow1]; x2 = [timewindow2,timewindow2];
        ymin = meanpeak - 30; ymax = meanpeak + 200;
        y1 = [ymin, ymax];
        plot(x1, y1,'g-'); plot(x2, y1,'g-');
        
        outputRate = data1.outputRate/1000;
        
        %calculates and draws linear regression line
        x = data1.data(:,1); xlim = x(slopewindow1*outputRate:slopewindow2*outputRate);
        y = data_yphys; ylim = y(slopewindow1*outputRate:slopewindow2*outputRate);
        [R,p] = corrcoef(xlim,ylim); C = cov(xlim,ylim);
        m = R(1,2)*sqrt(C(2,2)/C(1,1));
        b = mean(ylim) - m*mean(xlim);
        X = slopewindow1:slopewindow2;
        Y = m * X + b;
        plot(X,Y,'m--','Linewidth',2);
        hold off;
        
        data_yphys = data_yphys - mean(data_yphys(baseLine(1)*outputRate : baseLine(2)*outputRate));
        data2 = imfilter(data_yphys, f1, 'replicate');
        data3 = data2(timewindow1*outputRate : timewindow2*outputRate);
        
        minutes = str2num(a(numstring).date(16:17));
        secfrac = (str2num(a(numstring).date(19:end))) / 60;
        time = minutes + secfrac;   %time is in minutes
        
        if exist(['analysis_yphys', '.mat'])
            load('analysis_yphys.mat');
        end
        
        analysis.peakmax(numstring) = max(data3);
        analysis.slope(numstring) = m;
        analysis.time(numstring) = time;
        save('analysis_yphys','analysis'); 
    end

end





