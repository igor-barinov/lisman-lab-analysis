function [fn] = likelihood_fn(mode, x, y)
    if strcmp(mode, 'single')
        fn = @(beta) expgauss_neg_loglik(beta, x, y);
    elseif strcmp(mode, 'double')
        fn = @(beta) exp2gauss_neg_loglik(beta, x, y);
    end
end