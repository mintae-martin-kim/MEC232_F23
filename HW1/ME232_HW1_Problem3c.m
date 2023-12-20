% Problem 3(c)

syms t s
K1 = 2; K2 = 1; tau = 4; 

F = ((K1-K2*tau)*s+(K1-K2))/(s*(tau*s+1)*(s+1));
f = matlabFunction(ilaplace(F));
t = 0:0.01:30;

plot(t,f(t))