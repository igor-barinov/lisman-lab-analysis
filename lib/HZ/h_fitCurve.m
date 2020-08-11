function [fit, tau] = h_fitCurve(fitopt, lineHandle)

if ~(exist('lineHandle')==1)|isempty(lineHandle)
    lineHandle = gco;
end

if ~exist('fitopt')
    fitopt = 1;
end

t = get(lineHandle,'XData');
y = get(lineHandle,'YData');

y2 = y(t>=0);
t2 = t(t>=0);
t2(isnan(y2)) = [];
y2(isnan(y2)) = [];

switch fitopt
    case {1}
        fit = h_fitSingleExp(t2,y2);
    case {2}
        fit = h_fitDoubleExp(t2,y2);
end

y3 = y(t>0) - mean(y(t<0));
y3 = y3/max(y3);
tau = sum(y3(~isnan(y3)))*(t(2)-t(1));