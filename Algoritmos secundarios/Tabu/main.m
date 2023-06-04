clc,clear all;
%x=[1 2 3 4];
%x=[1 2 3 4 5 6 7 8 9 10 11 12];
% x = randperm(12);
% Current2 = tabu(x, 12);
% 
% if fEval(Current2)==0
% disp("Estado final sol")
% disp(Current2)
% end
% 
% disp("Estado final nosol")
% disp(Current2)
% disp(fEval(Current2))

nExperimentos = 1000;
nReinas = 12;
TiempoA = 0;
Inicios = [];
Aciertos = zeros(1, 3);
Iteraciones = zeros(1, 3);
Mal_colocado = zeros(1, 3);
Res = [];
I = 0;

for i = 1:nExperimentos
    Inicios = [Inicios; randperm(nReinas)];
end

for i = 1:nExperimentos
    tic
    [Res, I] = Tabu2(Inicios(i, :), nReinas);
    TiempoA = TiempoA + toc;
    Iteraciones(1) = Iteraciones(1) + I;

    if fEval(Res) == 0
        Aciertos(1) = Aciertos(1) + 1;
    end
    Mal_colocado(1) = Mal_colocado(1) + fEval(Res);
    
end