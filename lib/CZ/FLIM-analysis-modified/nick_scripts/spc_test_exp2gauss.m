function [y] = spc_test_exp2gauss(beta, x)
    pop1 = beta(1);
    tau1 = beta(2);
    pop2 = beta(3);
    tau2 = beta(4);
    tauG = beta(5);
    tauD = beta(6);
    
    exp1 = spc_test_expgauss([pop1, tau1, tauG, tauD], x);
    exp2 = spc_test_expgauss([pop2, tau2, tauG, tauD], x);
    y = exp1 + exp2;
end