function h_loadAnalyzedRoiData(handles)

global h_img;

currentFilename = get(handles.currentFileName,'String');
[pname, fname] = h_analyzeFilename(currentFilename);
analysisNumber = h_img.state.analysisNumber.Value;
if analysisNumber == 1
    analysisNumber = [];
end
roiFilename = fullfile(pname,'Analysis',[fname(1:end-4),'_zroi',num2str(analysisNumber),'.mat']);
% roiFilename = [pname,'Analysis\',fname(1:end-4),'_zroi.mat'];
load(roiFilename);
h_img.lastCalcROI = Aout;
objs = [findobj(handles.imageAxes,'Tag','HROI');findobj(handles.imageAxes,'Tag','HBGROI')];
for i = 1:length(objs)
    UserData = get(objs(i),'UserData');
    delete(objs(i));
    delete(horzcat(UserData.texthandle));
end
axes(handles.imageAxes);
if isfield(Aout,'roi')
    for i = 1:length(Aout.roi)
        UserData.roi.xi = Aout.roi(i).xi;
        UserData.roi.yi = Aout.roi(i).yi;
               
        hold on;
        h = plot(UserData.roi.xi,UserData.roi.yi,'m-');
        set(h,'ButtonDownFcn', 'h_dragRoi2', 'Tag', 'HROI', 'Color','red', 'EraseMode','xor');
        hold off;
        
        x = (min(UserData.roi.xi) + max(UserData.roi.xi))/2;
        y = (min(UserData.roi.yi) + max(UserData.roi.yi))/2;
        UserData.texthandle = text(x,y,num2str(Aout.roiNumber(i)),'HorizontalAlignment',...
            'Center','VerticalAlignment','Middle', 'Color','red', 'EraseMode','xor', 'ButtonDownFcn', 'h_dragRoiText2');
        UserData.number = Aout.roiNumber(i);
        UserData.ROIhandle = h;
        UserData.timeLastClick = clock;
        set(h,'UserData',UserData);
        set(UserData.texthandle,'UserData',UserData);
    end
end

if isfield(Aout,'bgroi') & ~isempty(Aout.bgroi)
        UserData.roi.xi = Aout.bgroi.xi;
        UserData.roi.yi = Aout.bgroi.yi;
               
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

            
    