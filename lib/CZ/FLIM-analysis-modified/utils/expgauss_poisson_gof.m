function [p] = expgauss_poisson_gof(beta, x, y)
    % Eqn 23 by T.Hauschild M.Jentschel
    %
    % 2 * ( sum(yhat - y) - sum(y * log(yhat / y)) )
    % ^^^^^^^^^^^^^^^^ Minimize
    
    yhat = Fitting.flimage_single_exp(beta, x);
    yClamp = max(y, ones(size(y)));
    s1 = sum(yhat - y);
    s2 = sum(yClamp .* log(yhat ./ yClamp));
    
    p = 2 * (s1 - s2);
end