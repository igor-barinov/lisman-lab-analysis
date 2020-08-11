function h_syncslider(sliderTag, syncBoxTag)

slider = h_findobj('Tag','sliderTag');
syncBox = h_findobj('Tag','syncBoxTag');

value = get(slider,'Value');
set(syncBox,'String',value);