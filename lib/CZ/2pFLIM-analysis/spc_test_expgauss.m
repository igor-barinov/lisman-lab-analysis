function [y] = spc_test_expgauss(beta, x)
pop = beta(1);
tau = beta(2);
tauG = beta(3);
tauD = beta(4);

decayTransform = (tauG^2 * tau^2)/2 - tau*(x - tauD);
pulseTransform = (tauG^2 * tau - (x - tauD)) / (sqrt(2) * tauG);

decay = pop * exp(decayTransform);
pulse = erfc(pulseTransform);

y = (decay .* pulse) / 2;
end