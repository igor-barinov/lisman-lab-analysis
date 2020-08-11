function h_selectPALine

global h_img;

h = findobj(gca,'Type','Line');
set(h,'Selected','off','LineWidth',0.5,'MarkerSize',6);
set(gco,'Selected','on','LineWidth',1.5,'MarkerSize',6);

try
    ss_selectCurrentPlot;
end

t0 = clock;
h_gco = gco;
UserData = get(h_gco,'UserData');
if isfield(UserData,'timeLastClick') & etime(t0,UserData.timeLastClick) < 0.3
    [pname,fname,fExt] = fileparts(UserData.filename);
    h_openFile([fname,fExt],pname);
end
UserData.timeLastClick = t0;
set(h_gco,'UserData',UserData);