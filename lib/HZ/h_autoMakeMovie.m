function h_autoMakeMovie

global h_img

handles = h_img.currentHandles;
movieTypeOpt = get(handles.movieTypeOpt,'Value');

switch movieTypeOpt
    case 1
        zLim(1) = str2num(get(handles.zStackControlLow,'String'));
        zLim(2) = str2num(get(handles.zStackControlHigh,'String'));
        maxOpt = get(handles.maxProjectionOpt,'Value');
        set(handles.maxProjectionOpt,'Value',0);
        for i = 1:diff(zLim)+1
            set(handles.zStackControlLow,'String',num2str(zLim(1)+i-1));
            h_zStackQuality;
            h_replot;
%             pause(0.2);
            mov(i) = getframe(handles.imageAxes);
        end
        set(handles.maxProjectionOpt,'Value',maxOpt);
        set(handles.zStackControlLow,'String',num2str(zLim(1)));
        set(handles.zStackControlHigh,'String',num2str(zLim(2)));
        h_zStackQuality;
    otherwise
end

h_img.movie.mov = mov;