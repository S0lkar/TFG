A = 1:10000;
nExp = 100000;
T = 0;
% for i = 1:nExp
%     tic
%     find(A == 90000, 1);
%     T = T + toc;
% end
% disp("· Sin hacer el corte; " + T/nExp);
% 
% T = 0;
% for i = 1:nExp
%     tic
%     find(A(89000:end) == 90000, 1);
%     T = T + toc;
% end
% disp("· Con el corte; " + T/nExp);
% 
% disp("> Solo renta si con el corte va a recortar mucho.");

load C
Fragmento = 1:20;
Punto = 24;
for i = 1:nExp
    tic
    Corte(C, Fragmento, Punto);
    T = T + toc;
end
disp("· Tiempo de Corte; " + T/nExp);
% 5.3193e-05 antes
