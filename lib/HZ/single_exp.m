function y = single_exp(beta, x)

% beta(3) = 150;
a = beta(1);
t = beta(2);
b = beta(3);


y = a * exp(-x/t) + b;