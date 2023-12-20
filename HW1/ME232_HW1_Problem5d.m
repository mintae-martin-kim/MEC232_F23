

% Problem 5(d)

n = [1 0 0];
d1 = [1 -1];
d2 = [1 -1.4 0.48];
d = conv(d1, d2);

sys = tf(n, d, -1);
impulse(sys);