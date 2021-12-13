function betahat=spc_fitexp2gauss
global spc gui

fixtau = spc.fit(gui.spc.proChannel).fixtau;

range = spc.fit(gui.spc.proChannel).range;

lifetime = spc.lifetime(range(1):1:range(2));
%x = [1:1:length(lifetime)];
x = range(1):range(2);

[val_max, pos_max] = max(lifetime);

%beta0 = spc_initialValue_double;
%beta0 = spc_initialFitParams('double');
    
weight = sqrt(lifetime)/sqrt(max(lifetime));
weight(lifetime < 1)=1/sqrt(max(lifetime));

bg = str2double(get(gui.spc.spc_main.beta7, 'string'));

lifetime = lifetime;

warning('');
warning('off');
% betahat = nlinfit(x, lifetime+1, @exp2gauss, beta0,'Weights',weight); %by cong
%betahat = spc_nlinfit(x, lifetime, weight, @exp2gauss, beta0);

beta0 = FLIMageFitting.Exp2GaussInitialPrms(x, lifetime, spc.datainfo.psPerUnit);
betahat = FLIMageFitting.Exp2GaussFit(beta0, x, lifetime);

[warnMsg, warnID] = lastwarn();
if ~isempty(warnMsg)
    disp(['Warning raised during fit: ', warnID]);
end
warning('on');



for j = [2, 4, 5, 6]
    if fixtau(j)
        betahat(j) = beta0(j);
    end
end

spc.fit(gui.spc.proChannel).beta0 = betahat;
spc.fit(gui.spc.proChannel).curve = FLIMageFitting.Exp2Gauss(betahat, x);
%spc.fit(gui.spc.proChannel).curve = exp2gauss(betahat, x);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tauD = spc.datainfo.psPerUnit/1000/spc.fit(gui.spc.proChannel).beta0(2);
tauAD = spc.datainfo.psPerUnit/1000/spc.fit(gui.spc.proChannel).beta0(4);

% pop2 = spc_getFraction(sum(lifetime.*x)/sum(lifetime));
pop1 = betahat(1)/(betahat(1) + betahat(3));
pop2 = 1 - pop1;

%curve = spc.fit(gui.spc.proChannel).curve;
tau_m = (tauD*tauD*pop1+tauAD*tauAD*pop2)/(tauD*pop1 + tauAD*pop2);
tau_m2 = sum(lifetime.*x)/sum(lifetime)*spc.datainfo.psPerUnit/1000; %tau_m.
shift1 = tau_m2 - tau_m; %(betahat(5)-1)*spc.datainfo.psPerUnit/1000; %;
spc.fit(gui.spc.proChannel).t_offset = shift1;