function [betahat] = spc_test_fit(fitType)
global gui;
global spc;

isSingleExp = strcmp(fitType, 'single');
isDoubleExp = strcmp(fitType, 'double');

range = spc.fit(gui.spc.proChannel).range;
x = range(1):range(2);
y = spc.lifetime(range(1):1:range(2));

weights = ones(size(y)) ./ sqrt(y);

if isSingleExp
    beta0 = spc_test_initialFitParams('single');
    beta0 = [beta0(1), beta0(2), beta0(5), beta0(6)];
    modelFn = @spc_test_expgauss;
elseif isDoubleExp
    beta0 = spc_test_initialFitParams('double');
    modelFn = @spc_test_exp2gauss;
else
    error('Cannot perform fit: unknown fit type');
end

betahat = nlinfit(x, y, modelFn, beta0, 'Weights', weights);
if isSingleExp
    betahat = [betahat(1), betahat(2), 0, 0, betahat(3), betahat(4)];
end

fitBeta = ones(1, 6);

[fixedParams, paramIsFixed] = spc_test_getInputParams();
for i=1:numel(fixedParams)
    if paramIsFixed(i)
        fitBeta(i) = fixedParams(i);
    else
        fitBeta(i) = betahat(i);
    end
end

if isSingleExp
    beta = [fitBeta(1), fitBeta(2), fitBeta(5), fitBeta(6)];
    spc.fit(gui.spc.proChannel).curve = spc_test_expgauss(beta, x);
elseif isDoubleExp
    beta = fitBeta;
    spc.fit(gui.spc.proChannel).curve = spc_test_exp2gauss(beta, x);
end

spc.fit(gui.spc.proChannel).beta0 = fitBeta;





tauD = spc.fit(gui.spc.proChannel).beta0(2)*spc.datainfo.psPerUnit/1000;
tauAD = spc.fit(gui.spc.proChannel).beta0(4)*spc.datainfo.psPerUnit/1000;
pop1 = betahat(1)/(betahat(1) + betahat(3));
pop2 = 1 - pop1;
tau_m = (tauD*tauD*pop1+tauAD*tauAD*pop2)/(tauD*pop1 + tauAD*pop2);
tau_m2 = sum(y.*x)/sum(y)*spc.datainfo.psPerUnit/1000;
shift1 = tau_m2 - tau_m;
spc.fit(gui.spc.proChannel).t_offset = shift1;
end