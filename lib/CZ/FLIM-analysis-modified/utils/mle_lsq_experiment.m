function mle_lsq_experiment()
    %beta_true = [22000, 2.686, 7100, 0.585, 1.833, 0.138, 0]; % Inspired by 121021B, image 1
    beta_true = [500, 2.686, 1000, 0.585, 1.833, 0.138, 0]; % Inspired by 121021B, image 1

    x = -5:1:30;
    y = Fitting.flimage_double_exp(beta_true, x);
    N = numel(x);
    
    noise = zeros(1, N);
    
    for i = 1:N
        sample = poissrnd(y(i), 1, 10);
        noise(i) = mean(sample);
    end
    
    
    figure('Name', 'Model Data');
    plot(x, y); hold on;
    plot(x, noise);
    
    
    beta0 = [1, 1, 1, 1, 1, 1, 0];
    
    [beta_lsq, fit_lsq] = Fitting.fit(beta0, false(1, 7), x, noise, 'flimage_double');
    [beta_mle, fit_mle] = Fitting.fit(beta0, false(1, 7), x, noise, 'mle_double');
    %[beta_mle2, fit_mle2] = Fitting.fit(beta0, false(1, 7), x, noise, 'mle_single');
    
    beta_lsq(2) = spc_nanoseconds(beta_lsq(2));
    beta_lsq(4) = spc_nanoseconds(beta_lsq(4));
    beta_mle(2) = spc_nanoseconds(beta_mle(2));
    beta_mle(4) = spc_nanoseconds(beta_mle(4));
    
    
%     sq_err_lsq = (noise - fit_lsq) .* (noise - fit_lsq);
%     sq_err_mle = (noise - fit_mle) .* (noise - fit_mle);
%     sse_lsq = sum(sq_err_lsq);
%     sse_mle = sum(sq_err_mle);
%     
%     chi_p_lsq = sum(sq_err_lsq ./ fit_lsq);
%     chi_p_mle = sum(sq_err_mle ./ fit_mle);
%     
%     chi_n_lsq = sum(sq_err_lsq ./ max(fit_lsq, ones(1, N)));
%     chi_n_mle = sum(sq_err_mle ./ max(fit_mle, ones(1, N)));
    
    figure('Name', 'LSQ Fit');
    plot(x, noise); hold on;
    plot(x, fit_lsq);
    
    
    figure('Name', 'MLE Fit');
    plot(x, noise); hold on;
    plot(x, fit_mle);
    
%     figure('Name', 'MLE 2 Fit');
%     plot(x, noise); hold on;
%     plot(x, fit_mle2);
    
    fprintf('LSQ betahat: %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f\n', beta_lsq(1), beta_lsq(2), beta_lsq(3), beta_lsq(4), beta_lsq(5), beta_lsq(6), beta_lsq(7));
    fprintf('MLE betahat: %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f\n', beta_mle(1), beta_mle(2), beta_mle(3), beta_mle(4), beta_mle(5), beta_mle(6), beta_mle(7));
%     
%     fprintf('LSQ SSE: %.3f\n', sse_lsq);
%     fprintf('MLE SSE: %.3f\n', sse_mle);
%     
%     fprintf('LSQ Pearsons Chi^2: %.3f\n', chi_p_lsq);
%     fprintf('MLE Pearsons Chi^2: %.3f\n', chi_p_mle);
%     
%     fprintf('LSQ Neymans Chi^2: %.3f\n', chi_n_lsq);
%     fprintf('MLE Neymans Chi^2: %.3f\n', chi_n_mle);
    
end
