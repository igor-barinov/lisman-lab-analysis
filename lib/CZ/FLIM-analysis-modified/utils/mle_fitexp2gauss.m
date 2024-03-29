function betahat=mle_fitexp2gauss
global spc gui

fixtau = spc.fit(gui.spc.proChannel).fixtau;

range = spc.fit(gui.spc.proChannel).range;

lifetime = spc.lifetime(range(1):1:range(2));
x = [1:1:length(lifetime)];

[val_max, pos_max] = max(lifetime);

beta0 = spc_initialValue_double;
    
weight = sqrt(lifetime)/sqrt(max(lifetime));
weight(lifetime < 1)=1/sqrt(max(lifetime));
% %***********non linear fit
% try
% %     betahat = spc_nlinfit(x, lifetime+1, weight, @exp2gauss, beta0);
%    betahat= nlinfit(x,lifetime+1,  @exp2gauss, beta0,'Weights',weight); %by cong
% end
% %******non linear fit end

%******MLE fit add by cong on 2021/12/07
betahMaxLkh = fminsearch(@spc_MaxLkh_exp2gauss, [beta0,1000]);
betahat = betahMaxLkh(1:6);
%***********MLE fit end
for j = [2, 4, 5, 6]
    if fixtau(j)
        betahat(j) = beta0(j);
    end
end

spc.fit(gui.spc.proChannel).beta0 = betahat;
spc.fit(gui.spc.proChannel).curve = exp2gauss(betahat, x);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tauD = spc.fit(gui.spc.proChannel).beta0(2)*spc.datainfo.psPerUnit/1000;
tauAD = spc.fit(gui.spc.proChannel).beta0(4)*spc.datainfo.psPerUnit/1000;
%*******add by cong
if abs(tauD-tauAD)<0.01
    pop2 = 0.01;
else
       pop2 = spc_getFraction(sum(lifetime.*x)/sum(lifetime));
%     pop2 = spc_getFraction(sum(lifetime.*x)/sum(lifetime),lifetime);
end
%********end
% pop2 = spc_getFraction(sum(lifetime.*x)/sum(lifetime));
pop1 = 1 - pop2;
tau_m = (tauD*tauD*pop1+tauAD*tauAD*pop2)/(tauD*pop1 + tauAD*pop2);
tau_m2 = sum(lifetime.*x)/sum(lifetime)*spc.datainfo.psPerUnit/1000;
shift1 = tau_m2 - tau_m;
spc.fit(gui.spc.proChannel).t_offset = shift1;