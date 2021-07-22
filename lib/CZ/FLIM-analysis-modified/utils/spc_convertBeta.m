function [beta] = spc_convertBeta(beta0, mode)
    beta = beta0;
    if strcmp(mode, 'fitting')
        beta(2) = spc_picoseconds(1 / beta0(2)); % tau1
        beta(4) = spc_picoseconds(1 / beta0(4)); % tau2
        beta(5) = spc_picoseconds(beta0(5));
        beta(6) = spc_picoseconds(beta0(6));
    elseif strcmp(mode, 'display')
        beta(2) = spc_picoseconds(1 / beta0(2)); % tau1
        beta(4) = spc_picoseconds(1 / beta0(4)); % tau2
        beta(5) = spc_picoseconds(beta0(5));
        beta(6) = spc_picoseconds(beta0(6));
    end
end