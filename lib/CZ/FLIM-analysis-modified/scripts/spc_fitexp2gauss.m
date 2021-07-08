function [betahat] = spc_fitexp2gauss()
global spc gui;

range = spc.fit(gui.spc.proChannel).range;
lifetime = spc.lifetime(range(1):1:range(2));
x = range(1):range(2);

tau_is_fixed = spc.fit(gui.spc.proChannel).fixtau;
initial_beta = spc.fit(gui.spc.proChannel).beta0;
beta0 = FLIMageFitting.Exp2GaussInitialPrms(x, lifetime, spc.datainfo.psPerUnit);
betahat = FLIMageFitting.Exp2GaussFit(beta0, x, lifetime);

for j = [2, 4, 5, 6]
    if tau_is_fixed(j)
        betahat(j) = initial_beta(j);
    end
end

spc.fit(gui.spc.proChannel).beta0 = betahat;
spc.fit(gui.spc.proChannel).curve = FLIMageFitting.Exp2Gauss(betahat, x);

tauD = spc.datainfo.psPerUnit/1000/spc.fit(gui.spc.proChannel).beta0(2);
tauAD = spc.datainfo.psPerUnit/1000/spc.fit(gui.spc.proChannel).beta0(4);
pop1 = betahat(1)/(betahat(1) + betahat(3));
pop2 = 1 - pop1;
tau_m = (tauD*tauD*pop1+tauAD*tauAD*pop2)/(tauD*pop1 + tauAD*pop2);
tau_m2 = sum(lifetime.*x)/sum(lifetime)*spc.datainfo.psPerUnit/1000;
shift1 = tau_m2 - tau_m;

spc.fit(gui.spc.proChannel).t_offset = shift1;