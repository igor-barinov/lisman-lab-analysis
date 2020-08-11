function h_loadDendriteTracingData

global h_img;

handles = h_img.currentHandles;

cstr = {'red', 'blue', 'green', 'magenta', 'cyan', 'black'};

currentFilename = get(handles.currentFileName,'String');
[pname, fname, fExt] = fileparts(currentFilename);

analysisNumber = h_img.state.analysisNumber.Value;
if analysisNumber == 1
    analysisNumber = [];
end

dataFilename = fullfile(pname,'Analysis',[fname,'_tracing',num2str(analysisNumber),'.mat']);

load(dataFilename);
h_img.lastDendriteTracing = Aout;

%delete all (temp)
h = get(handles.imageAxes,'Children');
g = findobj(h,'Type','Image');
h(h==g(1)) = [];
delete(h);
%delete all (temp)

axes(handles.imageAxes);

if isfield(Aout,'calcRoi') && isfield(Aout.calcRoi,'roi')
    for i = 1:length(Aout.calcRoi.roi)
        UserData.roi.xi = Aout.calcRoi.roi(i).xi;
        UserData.roi.yi = Aout.calcRoi.roi(i).yi;
               
        hold on;
        h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
        set(h,'ButtonDownFcn', 'h_dragRoi2', 'Tag', 'HROI', 'Color','red', 'EraseMode','xor');
        hold off;
        
        x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
        y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
        UserData.texthandle = text(x,y,num2str(Aout.calcRoi.roiNumber(i)),'HorizontalAlignment',...
            'Center','VerticalAlignment','Middle', 'Color','red', 'EraseMode','xor', 'ButtonDownFcn', 'h_dragRoiText2');
        UserData.number = Aout.calcRoi.roiNumber(i);
        UserData.ROIhandle = h;
        UserData.timeLastClick = clock;
        set(h,'UserData',UserData);
        set(UserData.texthandle,'UserData',UserData);
    end
end

if isfield(Aout,'calcRoi') && isfield(Aout.calcRoi,'bgroi') && ~isempty(Aout.calcRoi.bgroi)
        UserData.roi.xi = Aout.calcRoi.bgroi.xi;
        UserData.roi.yi = Aout.calcRoi.bgroi.yi;
               
        hold on;
        h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
        set(h,'ButtonDownFcn', 'h_dragRoi2', 'Tag', 'HBGROI');
        hold off;
        
        x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
        y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
        UserData.texthandle = text(x,y,'BG','HorizontalAlignment',...
            'Center','VerticalAlignment','Middle', 'Color','red', 'EraseMode','xor', 'ButtonDownFcn', 'h_dragRoiText2');
        UserData.number = 'BG';
        UserData.ROIhandle = h;
        UserData.timeLastClick = clock;
        set(h,'UserData',UserData);
        set(UserData.texthandle,'UserData',UserData);
end

mark_size = 9;
if isfield(Aout,'tracingMarks') && ~isempty(Aout.tracingMarks)
    for i = 1:length(Aout.tracingMarks)
        UData = Aout.tracingMarks(i);
        point1 = UData.pos;
        hold on;
        h = plot(point1(1),point1(2),'.','MarkerSize',mark_size, 'Tag', 'h_tracingMark',...
            'Color',cstr{mod(UData.flag-1,6)+1},'ButtonDownFcn', 'h_dragTracingMark', 'EraseMode','xor');
        hold off;

        x = point1(1);% + h_img.header.acq.pixelsPerLine/64;
        y = point1(2);% + h_img.header.acq.pixelsPerLine/64;
        h2 = text(x,y,[' ', num2str(UData.flag), '.', num2str(UData.number)],'HorizontalAlignment', 'Left', 'VerticalAlignment', 'Middle',...
            'Tag', 'h_tracingMarkText', 'Color',cstr{mod(UData.flag-1,6)+1}, 'EraseMode','xor', 'ButtonDownFcn', 'h_dragTracingMarkText');

        UData.markHandle = h;
        UData.textHandle = h2;
        UData.timeLastClick = clock;

        set(h,'UserData',UData);
        set(UData.textHandle,'UserData',UData);
    end
end

%write in this way so that in the future it will become an independent
%functional module.
axes(handles.imageAxes);
hold on;
flag = Aout.skeletonInPixel(:,5);
flag2 = flag;%flag2 is the one that will change within the loop, flag does not change.
while ~isempty(flag2)
    currentFlag = min(flag2);
    ind = find(flag==currentFlag);    
    plot(Aout.skeletonInPixel(ind,1),Aout.skeletonInPixel(ind,2),'-', 'Color', cstr{mod(currentFlag-1,6)+1},...
        'tag', 'h_dendriteSkeleton', 'UserData', currentFlag);
    flag2(flag2==currentFlag) = [];
end
hold off;


h_setDendriteTracingVis;
