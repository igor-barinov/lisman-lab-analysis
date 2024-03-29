function spc_drawfit (t, fit, lifetime, channel)
global spc;
global gui;

%figure(gui.spc.figure.lifetime);
%lifetime = spc.lifetime(range(1):1:range(2));

residual = (lifetime(:) - fit(:)) ./ sqrt(lifetime(:));
    bg_residual_max=[1:3];
    bg_residual_min=[1:3];
  N=length(bg_residual_max);
     for i=1:N
        bg_residual_max(1,i)=max(residual(1:3));
        bg_residual_min(i)=min(residual(1:3));
     end
%x = spc_nanoseconds(t);
%for i = 1:numel(x)
    %xypair = sprintf('(%.3f, %.3f) -> %.3f\n', x(i), lifetime(i), fit(i));
    %disp(xypair);
%end

%axes(gui.spc.figure.lifetimeaxes);

set(gui.spc.figure.lifetimePlot, 'XData', t, 'YData', lifetime(:));
set(gui.spc.figure.fitPlot, 'XData', t, 'YData', fit);
set(gui.spc.figure.fitPlot, 'Color', 'red');
if (spc.switches.logscale == 0)
    set(gui.spc.figure.lifetimeAxes, 'YScale', 'linear');
else
    set(gui.spc.figure.lifetimeAxes, 'YScale', 'log');
end

set(gui.spc.figure.lifetimeAxes, 'XTick', []);

try
    res = residual;
catch
    res = 0;
end

if (res ~= 0 & length(t) == length(res))
    set(gui.spc.figure.residualPlot, 'XData', t, 'YData', res);
end

spc.fit(channel).residual = residual;
