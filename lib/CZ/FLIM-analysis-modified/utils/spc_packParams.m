function [beta] = spc_packParams(pop1, tau1, pop2, tau2, tau_d, tau_g)
    if nargin < 6
        error('Could not pack parameters: not enough inputs given.');
    end

    beta = [pop1, tau1, pop2, tau2, tau_d, tau_g];
end