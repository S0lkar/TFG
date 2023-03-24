
if(true)
    clc
    clear
end

load COORDENADAS.mat
load LONGITUDES.mat
load RUTAS.mat

% ----------- En orden descendente en tamaño -----------
S = zeros(1, length(C));
for i = 1:length(C)
    S(i) = length(C{i});
end
[~, orden] = sort(S, "ascend");
C = C(orden);
L = L(orden);
R = R(orden);
% -------------------------------------------------------

% ---------- Toma de resultados del algoritmo -----------
Res = zeros(1, length(C));
T = zeros(1, length(C));
for i = 1:length(C)
    Coords = C{i};
    % Llamada a la función de cálculo de ruta
    tic
    ruta = R{i};
    T(i) = toc;
    DEBUG_verRuta(ruta, Coords, true);
    % Cálculo del resultado
    Res(i) = LightFcost(ruta, Coords');
end
% -------------------------------------------------------

% -------------- Muestra de los resultados --------------
TSPLib_costs = [L{:}];
Pctg = TSPLib_costs ./ Res;
plot(1:length(C), Pctg, '.b'); title("Precisión de los mapas");hold on;
plot(1:length(C), Pctg, 'b');

figure, plot(1:length(C), T, '.b'); title("Tiempos obtenidos");hold on;
plot(1:length(C), T, 'b');
% -------------------------------------------------------

