function h_bAPwithYphys

global h_img
handles = h_img.currentHandles;
currentFilename = get(handles.currentFileName,'string');
[pname,fname,fExt] = fileparts(currentFilename);
analysisNumber = h_img.state.analysisNumber.Value;
if analysisNumber == 1
    analysisNumber = [];
end
onlineAnalysisFilename = fullfile(pname,'Analysis',[fname,'_onlinLS',num2str(analysisNumber),'.mat']);

Aout = struct('roi',struct,'time',[],'filename','','pulseN',[],'pulse',struct,'yphysName','','yphysData',[]);

%%%%%% try find the online ROI data, if not exist, autoselect %%%%%%%%
if exist(onlineAnalysisFilename)==2
    onlineData = importData(onlineAnalysisFilename);
    delete(findobj(handles.imageAxes,'Tag','LSROI'));
    ydata = get(handles.imageAxes,'YLim');
    axes(handles.imageAxes);
    hold on;
    cstr(1,:) = {'magenta','green','white','blue'};
    for i = 1:length(onlineData.roi)
        h(1,1) = plot([onlineData.roi.pos(1,i),onlineData.roi.pos(1,i)],ydata,'-');
        h(2,1) = plot([onlineData.roi.pos(2,i),onlineData.roi.pos(2,i)],ydata,'-');
        UserData.number = i;
        UserData.ROIHandles = h;
        UserData.roi_pos = onlineData.roi.pos(:,i);
        set(h,'Tag','LSROI','UserData',UserData,'ButtonDownFcn', 'h_dragLSRoi','LineWidth',2,'Color',cstr{i});
    end
    hold off
% elseif get(handles.autoROISelection,'Value')
%     h_autoSelectLSRoi;
end

F = str2num(get(handles.cutoffFrequency,'String'));
A = h_LSAnalysis(F);
Aout.roi = A.roi;
Aout.time = A.time;
Aout.filename = currentFilename;

if exist(onlineAnalysisFilename)==2
    Aout.pulseN = onlineData.pulseN;
    Aout.pulse = onlineData.pulse;
    [yphys_pname, yphys_fname] = fileparts(onlineData.yphysName);
    Aout.yphysName = fullfile(pname,'spc',[yphys_fname,'.mat']);
    yphysData = importData(Aout.yphysName);
    Aout.yphysData = yphysData.data;
else
    Aout.yphysName = fullfile(pname,'spc',['yphys',fname(end-2:end),'.mat']);
    yphysData = importData(Aout.yphysName);
    Aout.yphysData = yphysData.data;
    Aout.pulseN = yphysData.pulseN;
    Aout.pulse = yphysData.pulse{1,Aout.pulseN};
end

%%%%%%% Display %%%%%%%%%%%%%%%
gif = figure(1111);
h = subplot(3,2,[1:4]);
for i = 1:length(Aout.roi)
    I = find(Aout.time<Aout.pulse.delay & Aout.time > (Aout.pulse.delay-200));
    data(:,i) = (Aout.roi(i).green-mean(Aout.roi(i).green(I)))./mean(Aout.roi(i).green(I));
end
plot(Aout.time,data);
% xlabel('Time (ms)');
ylabel('green (dF/F)');
xlim = get(h,'xlim');
h = subplot(3,2,[5,6]);
plot(Aout.yphysData(:,1),Aout.yphysData(:,2));
set(h,'xlim',xlim);
xlabel('Time (ms)');
ylabel('Membrane potential (mV)');


%%%%%%%% Save %%%%%%%%%%%%%%%%%%%%
if ~(exist(fullfile(pname,'Analysis'))==7)
    currpath = pwd;
    cd (pname);
    mkdir('Analysis');
    cd (currpath);
end
analysisNumber = h_img.state.analysisNumber.Value;
if analysisNumber == 1
    analysisNumber = [];
end
fname = fullfile(pname,'Analysis',[fname,'_bAP',num2str(analysisNumber)]);
save(fname, 'Aout');
