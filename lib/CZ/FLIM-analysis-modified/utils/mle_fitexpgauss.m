function betahat=mle_fitexpgauss
global spc;
global gui;


range = spc.fit(gui.spc.proChannel).range;
lifetime = spc.lifetime(range(1):1:range(2));
fixtau = spc.fit(gui.spc.proChannel).fixtau;
x = [1:1:length(lifetime)];

[val_max, pos_max] = max(lifetime);

%beta0 = [max(lifetime), sum(lifetime)/max(lifetime), 0, 0, pos_max, tau_g];
try
	handles = gui.spc.spc_main;
	beta0(1)=str2num(get(handles.beta1, 'String'));
	beta0(2)=str2num(get(handles.beta2, 'String'));
	beta0(3)=str2num(get(handles.beta3, 'String'));
	beta0(4)=str2num(get(handles.beta4, 'String'));
	beta0(5)=str2num(get(handles.beta5, 'String'));
    beta0(6)=str2num(get(handles.beta6, 'String'));
	beta0(2) = beta0(2)*1000/spc.datainfo.psPerUnit;
	beta0(4) = beta0(4)*1000/spc.datainfo.psPerUnit;
	beta0(5) = beta0(5)*1000/spc.datainfo.psPerUnit;
    beta0(6) = beta0(6)*1000/spc.datainfo.psPerUnit;
catch
    beta0 = [0, 0, 0, 0, 0, 0];
end
if beta0(1) <= 100 || beta0(2) <= 0.5*1000/spc.datainfo.psPerUnit || beta0(2) >=5*1000/spc.datainfo.psPerUnit
    beta0(1) = max(spc.lifetime(range(1):1:range(2)));
    beta0(2) = sum(spc.lifetime(range(1):1:range(2)))/beta0(1);
end
%beta0(3) = 0;
%beta0(4) = 0;
if beta0(5) <= 0*1000/spc.datainfo.psPerUnit || beta0(5) >= 6*1000/spc.datainfo.psPerUnit 
    beta0(5) = 1000/spc.datainfo.psPerUnit;
end
if beta0(6) <= 0.05*1000/spc.datainfo.psPerUnit || beta0(6) >= 1.0*1000/spc.datainfo.psPerUnit 
    beta0(6) = 0.15*1000/spc.datainfo.psPerUnit;
end

%fix1 = get(gui.spc.spc_main.fixtau1, 'value');
% set(gui.spc.spc_main.fixtau2, 'value', 0); --why? 
betahat(4) = beta0(4);

weight = sqrt(lifetime)/sqrt(max(lifetime));
weight(lifetime < 1)=1/sqrt(max(lifetime));

% betahat = nlinfit(x, lifetime+1, @expgauss, beta0,'Weights', weight);%by cong
%**non linear fit
% betahat = spc_nlinfit(x, lifetime+1, weight, @expgauss, beta0);
%********non linear fit end

% % add mle fitting by Cong on 11/30/2021
betahMaxLkh = fminsearch(@spc_MaxLkh_expgauss, [beta0,1000]);
betahat = betahMaxLkh(1:6);
% betahMaxLkh = fminunc(@spc_MaxLkh_expgauss, [beta0,1]);
%********MLE fit end
for j = [2, 5, 6]
    if fixtau(j)
        betahat(j) = beta0(j);
    end
end

%Drawing
spc.fit(gui.spc.proChannel).beta0 = betahat;
spc.fit(gui.spc.proChannel).curve = expgauss(betahat, x);
% t = [range(1):1:range(2)];
% t = t*spc.datainfo.psPerUnit/1000;
% 
% spc_drawfit (t, fit, lifetime, betahat);