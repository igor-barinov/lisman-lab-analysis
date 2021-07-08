function [betahat] = spc_fitexpgauss()
global spc gui;

range = spc.fit(gui.spc.proChannel).range;
lifetime = spc.lifetime(range(1):1:range(2));
x = range(1):range(2);

initial_beta = spc.fit(gui.spc.proChannel).beta0;
tau_is_fixed = spc.fit(gui.spc.proChannel).fixtau;
beta0 = FLIMageFitting.ExpGaussInitialPrms(x, lifetime, spc.datainfo.psPerUnit);
betahat = FLIMageFitting.ExpGaussFit(beta0, x, lifetime);

for j = [2, 5, 6]
    if tau_is_fixed(j)
        betahat(j) = initial_beta(j);
    end
end

spc.fit(gui.spc.proChannel).beta0 = betahat;
spc.fit(gui.spc.proChannel).curve = FLIMageFitting.ExpGauss(betahat, x);

tau_m = spc.fit(gui.spc.proChannel).beta0(2)*spc.datainfo.psPerUnit/1000;
tau_m2 = sum(lifetime.*x)/sum(lifetime)*spc.datainfo.psPerUnit/1000;
shift1 = tau_m2 - tau_m; 

spc.fit(gui.spc.proChannel).t_offset = shift1;