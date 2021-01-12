function y = exp2gauss(beta0, x)
% ********* beta0 Parameters **********
% beta0(1): population 1
% beta0(2): tau1
% beta0(3): population 2
% beta0(4): tau2
% beta0(5): delta peak time
% beta0(6): gaussian width
global gui;
global spc;


pulseI=spc.datainfo.pulseInt / spc.datainfo.psPerUnit*1000;

fix1 = get(gui.spc.spc_main.fixtau1, 'value');
fix2 = get(gui.spc.spc_main.fixtau2, 'value');
fix_g = get(gui.spc.spc_main.fix_g, 'value');
fix_d = get(gui.spc.spc_main.fix_delta, 'value');

if (fix1)
    value = str2double(get(gui.spc.spc_main.beta2, 'string'));
    tau1 = value*1000/spc.datainfo.psPerUnit;
    beta0(2) = tau1;
else
    tau1 = beta0(2);
end

if (fix2)
    value = str2double(get(gui.spc.spc_main.beta4, 'string'));
    tau2 = value*1000/spc.datainfo.psPerUnit;
    beta0(4) = tau2;
else
    tau2 = beta0(4);
end

if (fix_d)
    value =  str2double(get(gui.spc.spc_main.beta5, 'string'));
    tau_d = value * 1000/spc.datainfo.psPerUnit;
else
    tau_d = beta0(5);
end

if (fix_g)
    value = str2double(get(gui.spc.spc_main.beta6, 'string'));
    tau_g = value * 1000/spc.datainfo.psPerUnit;
else
    tau_g = beta0(6);
end


% Time-point to ps conversion: t = x * spc.datainfo.psPerUnit/1000

% ********* First Exponential calculation ************
% y1 = decaying exponential, follows form Ae^-t
% affected by following params: pop1, tau1, gaussian width, delta peak time
y1 = beta0(1)*exp(tau_g^2/2/tau1^2 - (x-tau_d)/tau1);

% y2 = pulse, follows form erfc(-t)
% affected by following params: tau1, gaussian width, delta peak time
y2 = erfc((tau_g^2-tau1*(x-tau_d))/(sqrt(2)*tau1*tau_g));

% y = combination of decay and pulse
% since y2 (pulse) is ~0 near baseline, y1 (decay) only affects amplitude at/after peak
y=y1.*y2;

% Pre-pulse calculation: calculates single exponential except shifted to
% account for residual intensity near baseline
% y1, y2, and ya are same as above except they are shifted to the left by
% amount 'pulseI'
y1 = beta0(1)*exp(tau_g^2/2/tau1^2 - (x-tau_d+pulseI)/tau1);
y2 = erfc((tau_g^2-tau1*(x-tau_d+pulseI))/(sqrt(2)*tau1*tau_g));
ya = y1.*y2+y;

% Final value for first exponential; ya/2 because adding pre-pulse to
% regular exponential doubles all amplitudes
ya = ya/2;


% ********* First Exponential calculation ************
% Calculations are the same except that the second exponential relies on
% pop2 and tau2 instead of pop1 and tau1

y1 = beta0(3)*exp(tau_g^2/2/tau2^2 - (x-tau_d)/tau2);
y2 = erfc((tau_g^2-tau2*(x-tau_d))/(sqrt(2)*tau2*tau_g));
y=y1.*y2;

y1 = beta0(3)*exp(tau_g^2/2/tau2^2 - (x-tau_d+pulseI)/tau2);
y2 = erfc((tau_g^2-tau2*(x-tau_d+pulseI))/(sqrt(2)*tau2*tau_g));

yb = y1.*y2+y;
yb = yb/2;

% Final value for double exponential
y=ya+yb;
