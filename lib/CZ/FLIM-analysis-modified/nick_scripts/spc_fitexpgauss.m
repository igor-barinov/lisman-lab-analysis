function [betahat] = spc_fitexpgauss()
    global spc gui;

    handles = gui.spc.spc_main;
    range = spc.fit(gui.spc.proChannel).range;
    lifetime = spc.lifetime(range(1):1:range(2));
    x = range(1):range(2);

    beta_in = spc.fit(gui.spc.proChannel).beta0;

    use_spc_fitting = get(handles.checkUseSpcFit, 'Value');
    use_mle_fitting = get(handles.useMLEFit, 'Value');
    if use_spc_fitting
        [betahat, curve] = Fitting.fit(beta_in, spc.fit(gui.spc.proChannel).fixtau, x, lifetime, 'spc_single');
    elseif use_mle_fitting
        [betahat, curve] = Fitting.fit(beta_in, spc.fit(gui.spc.proChannel).fixtau, x, lifetime, 'mle_single');
    else
        [betahat, curve] = Fitting.fit(beta_in, spc.fit(gui.spc.proChannel).fixtau, x, lifetime, 'flimage_single');
    end
    
    

    spc.fit(gui.spc.proChannel).beta0 = betahat;
    spc.fit(gui.spc.proChannel).curve = curve;

    tau_m = spc_picoseconds(spc.fit(gui.spc.proChannel).beta0(2));
    tau_m2 = spc_picoseconds(sum(lifetime.*x)/sum(lifetime));
    shift1 = tau_m2 - tau_m; 

    spc.fit(gui.spc.proChannel).t_offset = shift1;
end