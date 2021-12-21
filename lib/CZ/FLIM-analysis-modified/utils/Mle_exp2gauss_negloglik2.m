function negloglik = Mle_exp2gauss_negloglik2(params)%Mle 2 exp fit with Poisson distr by Vernon-Nick
   global spc;
   global gui;

beta = params(1:7);
range = spc.fit(gui.spc.proChannel).range;
lifetime = spc.lifetime(range(1):1:range(2));
 y = lifetime+1;
 x = range(1):range(2);
 for i = 1:length(x)
    ypred(i) = Fitting.flimage_double_exp(beta,x(i));

%      ymean = mleexp2gauss(beta1, beta2, tau1, tau2, tau_d, tau_g,pulseI, x);
     %ypred =exp2gauss(beta,x(i));
     %p = poisspdf(y(i), ypred);
     %L(i) = log(p);
     %P(i) = p;
%      L(i) = log(normpdf(y(i),ypred,sd));
ypredmean= mean(ypred);

 end
negloglik = 2*sum( ypredmean - y .* log(ypredmean) );
disp (negloglik);
      % eqn 7
    % Comparison of maximum likelihood estimation and chi-square statistics applied to counting experiments
    % T.Hauschild M.Jentschel
 end
 
 


