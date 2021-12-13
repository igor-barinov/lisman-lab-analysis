function negloglik = exp2gauss_negloglik2(params,x,y)
    beta1=params(1); beta2=params(2); pulseI=params(3);
    tau1=params(4); tau2=params(5);
    tau_d=params(6); tau_g=params(7);
    ymean = exp2gauss(beta1, beta2, pulseI, tau1, tau2, tau_d, tau_g, x);
    % negloglik = sum( (y-ymean).^2 / (2*sd^2) + log( sqrt(2*pi)*sd ) ) ;    % Gaussian
    negloglik = 2*sum( ymean - y .* log(ymean) );
    % eqn 7 
    % Comparison of maximum likelihood estimation and chi-square statistics applied to counting experiments
    % T.Hauschild M.Jentschel
end

