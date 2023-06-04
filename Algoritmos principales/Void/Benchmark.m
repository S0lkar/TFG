


% C:\Users\Solkar\Documents\MATLAB\TFG\Anilloscebolla.m
% C:\Users\Solkar\Documents\MATLAB\Cosas mias\Para ver y esquematizar\a_medicion.m
% C:\Users\Solkar\Documents\MATLAB\Cosas mias\Para ver y esquematizar\Crear_mCostes.m
% C:\Users\Solkar\Documents\MATLAB\Post_Verano\Cristalogenesis\Cristalogenesis.m

addpath '.\Instancias\Instancias TSPLib'
addpath '.\Instancias\Instancias TNM'
addpath '.\Instancias\Instancias National'
addpath '.\Algoritmos\Void'
addpath '.\Algoritmos\Oblivion'
addpath '.\Post Invierno'
load TSPLib
load TNM
load National
C = TSPLib;%[TSPLib;TNM;National];

for i = 1:length(C)
    if length(C{i}) < 10000 % Exceso de memoria...
        Coords = C{i}; % Mapa i
        %if length(Coords) < 2000
        tic
        Anillo = convhulln(Coords); Anillo = Anillo(:, 1)';
        Puntos = uint64(1:length(Coords)); Puntos(Anillo) = []; % Puntos sin unir
        %mCostes = MatrizCostes_mex(Coords);
        %ruta = Void_mex(uint64(Anillo), uint64(Puntos), mCostes);
        %ruta = LightVoid_mex(uint64(Anillo), uint64(Puntos), Coords');
        %ruta = LightOblivion_mex(uint64(Anillo), uint64(Puntos), Coords');
        %ruta = TnsSup(ruta, uint64(Anillo), mCostes);
        %ruta = LightTnsSup(ruta, uint64(Anillo), Coords');
        ruta = LightVoid(uint64(Anillo), uint64(Puntos), Coords');
        %ruta = Asignacion_CM_mex(uint64(Anillo), uint64(Puntos), Coords);
        T(i) = toc;

        %S(i) = fcost(ruta, mCostes);
        S(i) = LightFcost(ruta, Coords');
    end
        %end
        i
end
% plot(Coords(ruta, 1), Coords(ruta, 2), '.r'); hold on;  plot(Coords(ruta, 1), Coords(ruta, 2), 'b'); hold off; 
 % para ver mapas
load TSPLib_TAM
load TSPLib_BEST
TAM = TSPLib_TAM(end:-1:1);
BEST = TSPLib_BEST(end:-1:1);

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
title("Tamaño vs Tiempo");