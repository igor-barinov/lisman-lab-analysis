function [beta] = spc_packParams(pop1, tau1, pop2, tau2, tau_d, tau_g, bg)
    if nargin < 6
        error('Could not pack parameters: not enough inputs given.');
    end

    if nargin > 6
        beta = [pop1, tau1, pop2, tau2, tau_d, tau_g, bg];
    else
        beta = [pop1, tau1, pop2, tau2, tau_d, tau_g];
    end
end