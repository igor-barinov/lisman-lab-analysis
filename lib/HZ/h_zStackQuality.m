function h_zStackQuality

global h_img;

handles = h_img.currentHandles;
maxProjection = get(handles.maxProjectionOpt,'Value');
maxProjectionEnable = get(handles.maxProjectionOpt,'Enable');
if strcmp(maxProjectionEnable,'off')
    maxProjection = 1;
end
[xlim,ylim,zlim] = h_getLimits(handles);
siz = zlim(2) - zlim(1) + 1;
zLim(1) = str2num(get(handles.zStackControlLow,'String'));
zLim(2) = str2num(get(handles.zStackControlHigh,'String'));

if ~maxProjection 
    zLim(2) = zLim(1);
end

if zLim(1)<1
    zLim(1) = 1;
end

if zLim(2)<1
    zLim(2) = 1;
end

if zLim(1)>siz
    zLim(1) = siz;
end

if zLim(2)>siz
    zLim(2) = siz;
end

zLim = sort(zLim);
zLim = round(zLim);

set(handles.zStackControlLow,'String',num2str(zLim(1)));
set(handles.zStackControlHigh,'String',num2str(zLim(2)));
if siz > 1
    set(h_findobj('Tag','zStackControl1'),'SliderStep',[1/(siz-1),0.1]);
    set(h_findobj('Tag','zStackControl2'),'SliderStep',[1/(siz-1),0.1]);
    set(h_findobj('Tag','zStackControl1'),'Value',(zLim(1)-1)/(siz-1));
    set(h_findobj('Tag','zStackControl2'),'Value',(zLim(2)-1)/(siz-1));
end
