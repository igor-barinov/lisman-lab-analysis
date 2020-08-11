function h_rulerButtonDownFcn

t0 = clock;
UserData = get(gco,'UserData');
if isfield(UserData,'timeLastClick') & etime(t0,UserData.timeLastClick) < 0.3
    delete(gco);
else
    UserData.timeLastClick = t0;
    set(gco,'UserData',UserData);
end
