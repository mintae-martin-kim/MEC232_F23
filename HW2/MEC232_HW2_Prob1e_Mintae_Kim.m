% HW 2 Problem 1(e)

% Problem 1(e)(ii)

A = [0 1; -4 -5];
B = [0; 1];
C = [2 1];
D = 0;

sys_1 = ss(A, B, C, D);


% Problem 1(e)(iii)

tf_1 = tf(sys_1);
disp("Transfer function:");
disp(tf_1);


% Problem 1(e)(iv)

[z,p,k] = zpkdata(sys_1);
disp(z);
disp(p);
disp(k);