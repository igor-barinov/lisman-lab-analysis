function [p] = expgauss_neg_loglik(beta, x, y)%Mle 1 exp fit with P distr by Igor
    % Eqn 6 by T.Hauschild M.Jentschel
    %
    % L_p(beta) = product( possionpdf(x = y, lambda = yhat(beta)) )
    % ^^^^^^^^^ Maximize
    
%     lambdas = Fitting.flimage_single_exp(beta, x);
%     X = y;
%     poisson = poisspdf(X, lambdas);
%     p = -1 * prod(poisson);
    
    % Eqn 7 by T.Hauschild M.Jentschel
    %
    % -2 ln(L_p(beta)) = 2 * sum( yhat(beta) - y * ln(yhat(beta)) )
    % ^^^^^^^^^^^^^^^^ Minimize
    
    yhat = Fitting.flimage_single_exp(beta, x);
    p = 2 * sum(yhat - y .* log(yhat));
    


%     N = length(x);
%     yhat = Fitting.flimage_single_exp(beta, x);     
%     log_y = log(y);
%     log_yhat = log(yhat);
%     probSum = 0;
%     for i = 1:N
%         p_i = poisspdf(round(log_y(i)), log_yhat(i));
%         probSum = probSum + log(p_i);
%         
%         %fprintf('\tlam = %.3f, x = %.3f\n', yhat(i), round(y(i)));
%     end
%     
%     p = -probSum;
%     fprintf('LL = %.3f\n', probSum);


    %ymean = Fitting.flimage_single_exp(beta, x); %exp2gauss(beta1, beta2, pulseI, tau1, tau2, tau_d, tau_g, x);
    % negloglik = sum( (y-ymean).^2 / (2*sd^2) + log( sqrt(2*pi)*sd ) ) ;    % Gaussian
    %p = 2*sum( ymean - y .* log(ymean) );
    % eqn 7 
    % Comparison of maximum likelihood estimation and chi-square statistics applied to counting experiments
    % T.Hauschild M.Jentschel
end