function [betahat] = spc_fitexp2gauss()
    global spc gui;

    handles = gui.spc.spc_main;

    range = spc.fit(gui.spc.proChannel).range;
    lifetime = spc.lifetime(range(1):1:range(2));
    x = (range(1):range(2));% - 1;

    beta_in = spc.fit(gui.spc.proChannel).beta0;

    use_spc_fitting = get(handles.checkUseSpcFit, 'Value');
    if use_spc_fitting
        [betahat, curve] = Fitting.fit(beta_in, spc.fit(gui.spc.proChannel).fixtau, x, lifetime, 'spc_double');
    else
        [betahat, curve] = Fitting.fit(beta_in, spc.fit(gui.spc.proChannel).fixtau, x, lifetime, 'flimage_double');
    end

    spc.fit(gui.spc.proChannel).curve = curve;
    spc.fit(gui.spc.proChannel).beta0 = betahat;


    tauD = spc.fit(gui.spc.proChannel).beta0(2);
    tauAD = spc.fit(gui.spc.proChannel).beta0(4);
    pop1 = betahat(1)/(betahat(1) + betahat(3));
    pop2 = 1 - pop1;
    tau_m = (tauD*tauD*pop1+tauAD*tauAD*pop2)/(tauD*pop1 + tauAD*pop2);
    tau_m2 = spc_picoseconds(sum(lifetime.*x)/sum(lifetime));
    shift1 = tau_m2 - tau_m;

    spc.fit(gui.spc.proChannel).t_offset = shift1;
end