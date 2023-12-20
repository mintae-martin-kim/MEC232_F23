%% HW 2 Problem 2

% Problem 2(b)

mb = 240;
mt = 36;
bs = 1000;
ks = 16000;
kt = 160000;

A = [-bs/mb 1/mb bs/mb 0;
     -ks 0 ks 0;
     bs/mt -1/mt -bs/mt 1/mt;
     0 0 -kt 0];

B = [0; 0; 0; kt];

C = [1 0 0 0];

D = 0;

sus_ss = ss(A, B, C, D);

% Problem 2(c)

e = eig(A);
disp("Eigenvalues:");
disp(e);

% Problem 2(d)

tf_2 = tf(sus_ss);
disp("Transfer function:");
disp(tf_2);

% Problem 2(e)

sys_zpk = zpk(sus_ss);

% Problem 2(f)

[wn, zeta] = damp(sus_ss);

% Problem 2(g)

step(sus_ss);

% Problem 2(h)

bode(sus_ss);

% Problem 2(i)

sus_can = canon(sus_ss, 'modal');
