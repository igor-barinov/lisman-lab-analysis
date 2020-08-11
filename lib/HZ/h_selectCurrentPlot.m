function h_selectCurrentPlot

h = h_findobj('Tag','h_imstackPlot');
set(h,'Selected','off');
set(gcf,'Selected','on');