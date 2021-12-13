function [LL] = maxLkh_expgauss(para)
global spc;
global gui;

beta = para(1:7);
sd = para(8);
range = spc.fit(gui.spc.proChannel).range;
lifetime = spc.lifetime(range(1):1:range(2));
 y = lifetime+1;
 x = [1:1:length(lifetime)];
 for i = 1:length(x)
     ypred = Fitting.flimage_single_exp(beta, x(i));
     
     %ypred =expgauss(beta,x(i));
     p = poisspdf(y(i), ypred);
     L(i) = log(p);
     
     %L(i) = log(normpdf(y(i),ypred,sd));
 end
LL = -sum(L);
end



