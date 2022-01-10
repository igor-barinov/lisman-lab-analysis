function [p] = exp2gauss_neg_loglik(beta, x, y)%Mle 2 exp fit with P distr by Igor    
    % Eqn 7 by T.Hauschild M.Jentschel
    %
    % -2 ln(L_p(beta)) = 2 * sum( yhat(beta) - y * ln(yhat(beta)) )
    % ^^^^^^^^^^^^^^^^ Minimize
    
    yhat = Fitting.flimage_double_exp(beta, x);
    p = 2 * sum(yhat - y .* log(yhat));

    %ymean = Fitting.flimage_double_exp(beta, x); %exp2gauss(beta1, beta2, pulseI, tau1, tau2, tau_d, tau_g, x);
    % negloglik = sum( (y-ymean).^2 / (2*sd^2) + log( sqrt(2*pi)*sd ) ) ;    % Gaussian
    %p = 2*sum( ymean - y .* log(ymean) );
    % eqn 7 
    % Comparison of maximum likelihood estimation and chi-square statistics applied to counting experiments
    % T.Hauschild M.Jentschel
end