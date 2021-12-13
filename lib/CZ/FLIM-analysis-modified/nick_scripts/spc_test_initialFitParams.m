function beta0 = spc_test_initialFitParams(fitType)
global spc;

[fixedParams, paramIsFixed] = spc_test_getInputParams();

fitRange = spc.fit.range;
x = fitRange(1):fitRange(2);
y = spc.lifetime(x);
[yMax, idxMax] = max(y);
xMax = x(idxMax);
ySum = sum(y);

tau0 = ySum / yMax;
tauG0 = 100 / spc.datainfo.psPerUnit;


if strcmp(fitType, 'single')
    beta0(1) = yMax*(1 + (tauG0 / tau0));
    beta0(2) = 1 / tau0;
    beta0(3) = 0; % pop2 unused
    beta0(4) = 0; % tau2 unused
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