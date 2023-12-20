% Problem 3(b)

K1 = 2; K2 = 1; tau = 4; 

num = [K1-K2*tau K1-K2];
den = [tau tau+1 1];
G = tf(num,den);

step(G);

