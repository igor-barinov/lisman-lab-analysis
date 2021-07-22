function [pop1, tau1, pop2, tau2, tau_d, tau_g] = spc_unpackParams(beta)
    pop1 = beta(1);
    tau1 = beta(2);
    pop2 = beta(3);
    tau2 = beta(4);
    tau_d = beta(5);
    tau_g = beta(6);
end