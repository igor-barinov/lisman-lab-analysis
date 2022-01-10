function [fn] = likelihood_fn(mode, x, y) %Mle 1 or 2 exp fit with P distr by Igor
    if strcmp(mode, 'poisson_single')
        fn = @(beta) expgauss_neg_loglik(beta, x, y);
    elseif strcmp(mode, 'poisson_double')
        fn = @(beta) exp2gauss_neg_loglik(beta, x, y);
    elseif strcmp(mode, 'gof_single')
        fn = @(beta) expgauss_poisson_gof(beta, x, y);
    elseif strcmp(mode, 'gof_double')
        fn = @(beta) exp2gauss_poisson_gof(beta, x, y);
    end
end