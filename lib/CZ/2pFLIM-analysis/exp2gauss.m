function y = exp2gauss(beta0, x)
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


%t = (1:0.05:50)*spc.datainfo.psPerUnit/1000;

y1 = beta0(1)*exp(tau_g^2/2/tau1^2 - (x-tau_d)/tau1);
y2 = erfc((tau_g^2-tau1*(x-tau_d))/(sqrt(2)*tau1*tau_g));
y=y1.*y2;

%decay1 = beta0(1)*exp(tau_g^2/2/tau1^2 - (t-tau_d)/tau1);
%pulse1 = erfc((tau_g^2-tau1*(t-tau_d))/(sqrt(2)*tau1*tau_g));
%conv1 = decay1.*pulse1;

%"Pre" pulse
y1 = beta0(1)*exp(tau_g^2/2/tau1^2 - (x-tau_d+pulseI)/tau1);
y2 = erfc((tau_g^2-tau1*(x-tau_d+pulseI))/(sqrt(2)*tau1*tau_g));

ya = y1.*y2+y;
ya = ya/2;

%pre_decay1 = beta0(1)*exp(tau_g^2/2/tau1^2 - (t-tau_d+pulseI)/tau1);
%pre_pulse1 = erfc((tau_g^2-tau1*(t-tau_d+pulseI))/(sqrt(2)*tau1*tau_g));
%pre_conv1 = pre_decay1.*pre_pulse1;
%pulse_int_amp1 = pre_conv1(ceil(spc.datainfo.pulseInt));
%exp1 = (pre_conv1 + conv1) / 2;

%{
figure('Name', 'Pulse 1');
hold on;
plot(t, exp1);
plot(t, decay1);
plot(t, pulse1);
plot(t, conv1);
yline(beta0(1));
yline(pulse_int_amp1, 'g');
set(gca, 'YScale', 'log');
legend('exp', 'decay', 'pulse', 'conv', 'pop1', 'pre pulse amp');

figure('Name', 'Pre Pulse 1');
hold on;
plot(t, exp1);
plot(t, pre_decay1);
plot(t, pre_pulse1);
plot(t, pre_conv1);
yline(beta0(1));
yline(pulse_int_amp1, 'g');
legend('exp', 'decay', 'pulse', 'conv', 'pop1', 'pre pulse amp');
set(gca, 'YScale', 'log');
%}

y1 = beta0(3)*exp(tau_g^2/2/tau2^2 - (x-tau_d)/tau2);
y2 = erfc((tau_g^2-tau2*(x-tau_d))/(sqrt(2)*tau2*tau_g));
y=y1.*y2;

%decay2 = beta0(3)*exp(tau_g^2/2/tau2^2 - (t-tau_d)/tau2);
%pulse2 = erfc((tau_g^2-tau2*(t-tau_d))/(sqrt(2)*tau2*tau_g));
%conv2 = decay2.*pulse2;

y1 = beta0(3)*exp(tau_g^2/2/tau2^2 - (x-tau_d+pulseI)/tau2);
y2 = erfc((tau_g^2-tau2*(x-tau_d+pulseI))/(sqrt(2)*tau2*tau_g));

yb = y1.*y2+y;
yb = yb/2;

%pre_decay2 = beta0(3)*exp(tau_g^2/2/tau2^2 - (t-tau_d+pulseI)/tau2);
%pre_pulse2 = erfc((tau_g^2-tau2*(t-tau_d+pulseI))/(sqrt(2)*tau2*tau_g));
%pre_conv2 = pre_decay2.*pre_pulse2;
%pulse_int_amp2 = pre_conv2(ceil(spc.datainfo.pulseInt));
%exp2 = (pre_conv2+conv2)/2;

y=ya+yb;

%full_exp = exp1 + exp2;

%{
figure('Name', 'Pulse 2');
hold on;
plot(t, exp2);
plot(t, decay2);
plot(t, pulse2);
plot(t, conv2);
yline(beta0(3));
yline(pulse_int_amp2, 'g');
set(gca, 'YScale', 'log');
legend('exp', 'decay', 'pulse', 'conv', 'pop2', 'pre pulse amp');

figure('Name', 'Pre Pulse 2');
hold on;
plot(t, exp2);
plot(t, pre_decay2);
plot(t, pre_pulse2);
plot(t, pre_conv2);
yline(beta0(3));
yline(pulse_int_amp2, 'g');
legend('exp', 'decay', 'pulse', 'conv', 'pop2', 'pre pulse amp');
set(gca, 'YScale', 'log');

figure('Name', 'Fit');
hold on;
plot(t, full_exp);
legend('Fit');

disp('showing fits');
%}
