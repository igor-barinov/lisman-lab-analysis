function [LL] = maxLkh_exp2gauss(para)
global spc;
global gui;

beta = para(1:7);
sd = para(8);
range = spc.fit(gui.spc.proChannel).range;
lifetime = spc.lifetime(range(1):1:range(2));
 y = lifetime+1;
 x = range(1):range(2);
 %x = [1:1:length(lifetime)];
 for i = 1:length(y)
     ypred = Fitting.flimage_double_exp(beta, x(i));
     %ypred =exp2gauss(beta,x(i));
     %p = poisspdf(y(i), ypred);
     %L(i) = log(p);
     %P(i) = p;
     L(i) = log(normpdf(y(i),ypred,sd));
 end
LL = -sum(L);

%LL = prod(P);
end
