A = [-1 -2 -2;
     0 -1 1;
     1 0 -1];
B = [2; 0; 1];
C = [1 1 0];
D = 0;
sys = ss(A,B,C,D,-1);

p = [0 0 0];
K = acker(A,B,p);
Acl = A-B*K;
syscl = ss(Acl,B,C,D,-1);
Pcl = pole(syscl);

disp(Acl);
disp(B*C);
disp(K);

syms F
disp(A-B*K+F*B*C);