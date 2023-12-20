A = [0 2 0 0;
     0 0 4 0;
     0 0 0 8;
     -1.557 -4.803 -9.37 -14.6;];

B = [0; 0; 0; 2];

C = [0.2031 0.5625 0.6875 0.5];

sys = ss(A, B, C, 0);

Wc = lyap(A, B*(B'));
Wo = lyap(A', C'*C);

R = chol(Wo);
[U,S,V] = svd(R*Wc*R');
disp(S^(1/2));
Tb = S^(-1/4) * U' * R;
disp(Tb);

Ab = Tb * A * inv(Tb);
Bb = Tb * B;
Cb = C * inv(Tb);

Wbc = lyap(Ab, Bb*(Bb'));
Wbo = lyap(Ab', Cb'*Cb);

disp(Wbc);
disp(Wbo);

[sysb,g] = balreal(sys);

rsysb = modred(sysb, 2:4);

bodeplot(sys,'-', rsysb,'x');
stepplot(sys,'-', rsysb,'x');