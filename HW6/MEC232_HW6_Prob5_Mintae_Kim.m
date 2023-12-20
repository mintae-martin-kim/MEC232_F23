syms a b

L_A = [2*a b b 0;
       1 a 0 b;
       1 0 a b;
       0 1 1 0;];

Q = [1; 0; 0; 1];

P = [b/(2*a) - 1/(2*a) -1/2;
     -1/2 1/(2*a*b) - (- a^2 + b)/(2*a*b)];

disp(-inv(L_A) * Q);
disp(det(P))