function spc_estimate_bg
global gui spc
%spc_redrawSetting(1);

range = spc.fit(gui.spc.proChannel).range;
x = range(1):1:range(2);
lifetime = spc.lifetime(x);

spc.fit(gui.spc.proChannel).background = mean(lifetime(1:3));
set(gui.spc.spc_main.beta7, 'string', num2str(spc.fit(gui.spc.proChannel).background ));