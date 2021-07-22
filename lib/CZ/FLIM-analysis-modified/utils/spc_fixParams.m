function [beta] = spc_fixParams(beta0, beta0_fixed, is_fixed)
    beta = beta0;

    for i = 1:numel(beta0)
        if is_fixed(i)
            beta(i) = beta0_fixed(i);
        end
    end
end