%% Problem 1(a)

Abr = [-3.602 -0.822;
     0.822 -0.593];
Bbr = [-1; 0.107];
Cbr = [-1 -0.107];
Dbr = 0;
sysbr = ss(Abr, Bbr, Cbr, Dbr);

At = [0 Cbr; 
      0*Bbr Abr];
Bt = [0; Bbr];
Ct = [0 Cbr];
syst = ss(At, Bt, Ct, Dbr);

p = [-0.8, -2+2i, -2-2i];
Kt = place(At,Bt,p);
% disp(Kt);

Kbr = Kt(2:3);
syssvf = ss(Abr-Bbr*Kbr, Bbr, Cbr, Dbr);

sysi = ss(0, Kt(1,1), 1, 0);
syso = syssvf * sysi;
syscl = feedback(syso, 1);

[acl, bcl, ccl, dcl] = ssdata(syscl);
% disp(eig(acl));

% step(syscl); % figure 1
% disp(zpk(syscl));

syms s t
sympref('FloatingPointOutput',true) 
F = tf(syscl);
num = poly2sym(F.Numerator, s);
den = poly2sym(F.Denominator, s);
f(t) = ilaplace(num/den);
% disp(f);


%% Problem 1(b)

Afull = [0 2 0 0;
     0 0 4 0;
     0 0 0 8;
     -1.557 -4.803 -9.37 -14.6;];
Bfull = [0; 0; 0; 2];
Cfull = [0.2031 0.5625 0.6875 0.5];
Dfull = 0;
sys = ss(Afull, Bfull, Cfull, Dfull);

Atfull = [0 Cfull; 
      0*Bfull Afull];
Btfull = [0; Bfull];
Ctfull = [0 Cfull];
syst = ss(Atfull, Btfull, Ctfull, Dfull);

Kbrfull = [Kbr 0 0];

% Find Tb for Kfull
Wc = lyap(Afull, Bfull*(Bfull'));
Wo = lyap(Afull', Cfull'*Cfull);
R = chol(Wo);
[U,S,V] = svd(R*Wc*R');
Tb = S^(-1/4) * U' * R;
Kfull = Kbrfull * Tb;

syssvffull = ss(Afull-Bfull*Kfull, Bfull, Cfull, Dfull);
sysi = ss(0, Kt(1,1), 1, 0);
sysofull = syssvffull * sysi;
sysclfull = feedback(sysofull, 1);
[aclfull, bclfull, cclfull, dclfull] = ssdata(sysclfull);

% disp(eig(aclfull));
% step(sysclfull); % figure 2
% disp(zpk(sysclfull));


%% Problem 2(a)

observerPoles = [-4-4*1i -4+4*1i];
Lbr = place(Abr',Cbr',observerPoles)';
% disp(Lbr);


%% Problem 2(b)

% Construct the state estimator block
% Matrix B
sysB = ss(Bbr);
sysB.u='Ui';
sysB.y = 's1';
% Block (sI-Abr+Bbr*Kbr+Lbr*Cbr)^(-1)
sysA = ss(Abr-Bbr*Kbr-Lbr*Cbr,eye(2),eye(2),0);
sysA.u = 's4';
sysA.y = 'Xbrh';
% Observer gain L
sysL = ss(Lbr);
sysL.u = 'Y';
sysL.y = 's2';
% State Feedback Gain K
sysKx = ss(-Kbr);
sysKx.u = 'Xbrh';
sysKx.y = 's3';

% Summation blocks
sumBlocks{1} = sumblk('s4 = s2 + s1',2);
% State Estimator with 'u' and 'y' as the input and 'ux' as the output.
% (We also consider the output estimation error 'eps' as an optional output for creating some plots later )
reg = connect(sysB,sysA,sysL,sysKx,sumBlocks{1},{'Ui','Y'},{'s3'});

% Connect the state estimator/feedback to the integrator and plant
% Integrator
s = tf('s');
Ki = Kt(1);
sysI = Ki*1/s;
sysI.u = 'E';
sysI.y = 'Ui';
% Plant
% sysp = ss(Abr,Bbr,Cbr,Dbr);
sysp = ss(Afull,Bfull,Cfull,Dfull);
sysp.u = 'U';
sysp.y = 'Y';
sumBlocks{2} = sumblk('E = R - Y');
sumBlocks{3} = sumblk('U = Ui + s3');
closedLoopSystem = connect(sysp,sysI,reg,sumBlocks{2},sumBlocks{3},'R','Y');

% Plot the step response from 'r' to 'Y'
% figure;
% step(closedLoopSystem('Y','R'));


%% Problem 3(c)

A = [-1 -2 -2;
     0 -1 1;
     1 0 -1];
B = [2; 0; 1];
C = [1 1 0];
D = 0;

aPrioriObsPoles = [0 0 0];
L = acker(A',C',aPrioriObsPoles)';
disp(L);


%% Problem 3(d) - Approach 1

% Matrix B plant
sysBp = ss(B);
sysBp.u = 'U';
sysBp.y = 's1';
% Block (zI-A)^(-1) plant
sysAp = ss(A,eye(3),eye(3),0,-1);
sysAp.u = 's1';
sysAp.y = 'X';
% Matrix C plant
sysCp = ss(C);
sysCp.u = 'X';
sysCp.y = 'Y';
% Matrix B observer
sysBo = ss(B);
sysBo.u = 'U';
sysBo.y = 's2';
% Block (zI-A)^(-1) observer
sysAo = ss(A,eye(3),eye(3),0,-1);
sysAo.u = 's4';
sysAo.y = 'Xh';
% Matrix C observer
sysCo = ss(C);
sysCo.u = 'Xh';
sysCo.y = 'Yh';
% Observer gain L
sysL = ss(L);
sysL.u = 'eps';
sysL.y = 's3';
% Feedback gain K
K = acker(A,B,aPrioriObsPoles);
sysK = ss(K);
sysK.u = 'Xh';
sysK.y = 's5';
% Referebce gain F
F = 1/6;
sysF = ss(F);
sysF.u = 'V';
sysF.y = 's6';
% Summation blocks
sumBlocks{1} = sumblk('s4 = s2 + s3',3);
sumBlocks{2} = sumblk('eps = Y - Yh');
sumBlocks{3} = sumblk('U = s6 - s5',3);

aPrioriObsSystem = connect(sysBp,sysAp,sysCp,sysBo,sysAo,sysCo,sysL,sysK,sysF,sumBlocks{1},sumBlocks{2},sumBlocks{3},{'V'},{'Y','Yh'});

t = 0:1:50;
V = 5 * (t>=0);
X0 = [0; 0; 0];
Xh0 = [-2; 2; 3];
lsim(aPrioriObsSystem, V, t);


%% Problem 3(e)

aPosterioriObsPoles = [0 0 0];
L = acker(A',(C*A)',aPosterioriObsPoles)';
disp(L);


%% Problem 4(a)

A = -50 * eye(2);
B = 100 * eye(2);
s = 100;
rho = 1;
Q = [s+1 -s;
     -s s+1];
R = rho * eye(2);
[K,S,P] = lqr(A,B,Q,R);


%% Problem 4(b)

t = 0:0.01:10;
d = [t<0; t>=2];

sys = ss(A-B*K, B, eye(2), zeros(2,2));
% lsim(sys,d,t);
