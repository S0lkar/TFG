load C.mat
load TAM.mat
load BEST.mat
TAM = TAM(end:-1:1);
BEST = BEST(end:-1:1);

[TAM, order] = sort(TAM, "ascend");
BEST = BEST(order);
C = C(order);

for i = 2:length(C)
    if length(C{i}) < 10000 % Exceso de memoria...
        Coords = C{i}; % Mapa i
    
        tic
        R = PolyGrowth(Coords, false); R = uint64(R)';
        mCostes = MatrizCostes_mex(Coords);
        Env = convhulln(Coords); Env = uint64(Env(:, 1));
        ruta = TnsSup(R, flip(Env), mCostes);
        T(i) = toc;
        S(i) = fcost(ruta, mCostes);
    end
end

m = [TAM BEST./S' T'];
m = sortrows(m, 1, 'ascend');

ind = find(m(:, 2) > 2);
m(ind, :) = [];
ind = find(m(:, 1) == 561 | m(:, 1) == 532 | m(:, 1) ==  29 | m(:, 1) == 48); % Mapas erróneos
m(ind, :) = [];

plot(m(:, 1), m(:, 2), 'b');
title("Tamaño vs Calidad de la solucion");
pause();
plot(m(:, 1), m(:, 3), 'b'); %hold on;
%I = 1:100:8000; plot(I, 0.08 .* I); plot(I, 0.08 .* I .* log2(I)); 
title("Tamaño vs Tiempo");
%legend("Tiempos obtenidos", "Orden n", "O(n * log(n))"); hold off;