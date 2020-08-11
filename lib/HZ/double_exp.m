function y = double_exp(beta, x)

a = beta(1);
t1 = beta(2);
b = beta(3);
t2 = beta(4);
c = beta(5);

y = a * exp(-x/t1) + b * exp(-x/t2) + c;