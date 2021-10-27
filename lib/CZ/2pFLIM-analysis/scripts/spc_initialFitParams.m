function beta0 = spc_test_initialFitParams(fitType)
global spc;
global gui;

handles = gui.spc.spc_main;

pop1=str2num(get(handles.beta1, 'String'));
tau1=str2num(get(handles.beta2, 'String'));
pop2=str2num(get(handles.beta3, 'String'));
tau2=str2num(get(handles.beta4, 'String'));
tauG=str2num(get(handles.beta5, 'String'));
tauD=str2num(get(handles.beta6, 'String'));

paramIsFixed = [0, get(handles.fixtau1, 'Value'), 0, get(handles.fixtau2, 'Value'), get(handles.fix_delta, 'Value'), get(handles.fix_g, 'Value') ];
fixedParams = [pop1, tau1, pop2, tau2, tauG, tauD];

fitRange = spc.fit.range;
x = fitRange(1):fitRange(2);
y = spc.lifetime(x);
[yMax, idxMax] = max(y);
xMax = x(idxMax);
ySum = sum(y);

tau0 = ySum / yMax;
tauG0 = 1000 / spc.datainfo.psPerUnit;


if strcmp(fitType, 'single')
    beta0(1) = yMax*(1 + (tauG0 / tau0));
    beta0(2) = 1 / tau0;
    beta0(5) = tauG0;
    beta0(6) = xMax - 2*tauG0;
elseif strcmp(fitType, 'double')
    beta0(1) = yMax / 2;
    beta0(2) = 1 / (2 * tau0);
    beta0(3) = yMax / 2;
    beta0(4) = 2 / tau0;
    beta0(5) = tauG0;
    beta0(6) = xMax - tauG0;
else
    beta0 = fixedParams;
    warning('Unknown fit type, using fixed params');
end

for i = 1:numel(fixedParams)
    if paramIsFixed(i)
        beta0(i) = fixedParams(i);
    end
end

fprintf('Using initial parameters:\n %f\n%f\n%f\n%f\n%f\n%f\n', ...
        beta0(1), beta0(2), beta0(3), beta0(4), beta0(5), beta0(6));

end