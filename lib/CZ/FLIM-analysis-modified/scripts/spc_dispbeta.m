function spc_dispbeta
    global gui spc;
    handles = gui.spc.spc_main;
   
    if isfield(spc.fit(gui.spc.proChannel), 'beta0')    

        betahat = spc.fit(gui.spc.proChannel).beta0;
        [~, tau, ~, tau2, peaktime, tau_g, bg] = spc_unpackParams(betahat);
        
        fixtau = spc.fit(gui.spc.proChannel).fixtau;

        set(handles.fixtau1, 'Value', fixtau(2));
        set(handles.fixtau2, 'Value', fixtau(4));
        set(handles.fix_delta, 'Value', fixtau(5));
        set(handles.fix_g, 'Value', fixtau(6));

        set(handles.beta1, 'String', num2str(betahat(1)));
        set(handles.beta3, 'String', num2str(betahat(3)));
        set(handles.beta2, 'String', num2str(tau));
        set(handles.beta4, 'String', num2str(tau2));


        set(handles.beta5, 'String', num2str(peaktime));
        set(handles.beta6, 'String', num2str(tau_g));
        set(handles.beta7, 'String', num2str(bg));

        pop1 = betahat(1)/(betahat(3)+betahat(1));
        pop2 = betahat(3)/(betahat(3)+betahat(1));
        set(handles.pop1, 'String', num2str(pop1));
        set(handles.pop2, 'String', num2str(pop2));
        mean_tau = (tau*tau*pop1+tau2*tau2*pop2)/(tau*pop1 + tau2*pop2);
        set(handles.average, 'String', num2str(mean_tau));

    end

    try
        set(handles.F_offset, 'String', num2str(spc.fit(gui.spc.proChannel).t_offset));
    catch
        set(handles.F_offset, 'String', 'NAN');
    end

    range1 = round(spc.fit(gui.spc.proChannel).range.*spc_picoseconds(10))/10;
    set(handles.spc_fitstart, 'String', num2str(range1(1)));
    set(handles.spc_fitend, 'String', num2str(range1(2)));
end
