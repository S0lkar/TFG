

A = [1 2 3 4 5 6 7 8];
B = [9 10];
P_ex = [1 8 9 10];
load Test_RdD.mat
EC = convhulln(Test_RdD(:, 1:8)'); 
EC = EC(:, 1)';

[A, B] = Regla_de_Derivacion(Test_RdD, A, B, EC, P_ex);

DEBUG_verRuta(A, Test_RdD, false);
DEBUG_verRuta(B, Test_RdD, false);
