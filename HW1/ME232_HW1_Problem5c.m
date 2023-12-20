% Problem 5(c)

n = [1 0];
d1 = [-1 1];
d2 = [0.48 -1.4 1];
d = conv(d1, d2);

[r,p,k] = residue(n,d);