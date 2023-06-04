clear
clc
close all

nPuntos_Iniciales = 5;
nPuntos_Desarrollo = 5;
paso = 1;
Coordenadas = [];
[x, y] = ginput(nPuntos_Iniciales);

Coordenadas = [Coordenadas [x';y']];
%ruta = Cristalogenesis(Coordenadas');
Anillo = 1:4;
[ruta, ~] = Reorganizacion(Anillo', Coordenadas(:, Anillo), (5:nPuntos_Iniciales)', Coordenadas(:, 5:nPuntos_Iniciales));
Representacion(Coordenadas, ruta);

for i = 1:nPuntos_Desarrollo
    [x, y] = ginput(paso);
    Coordenadas = [Coordenadas [x';y']];
    %ruta = Cristalogenesis(Coordenadas');
    [ruta, ~] = Reorganizacion(Anillo', Coordenadas(:, Anillo), (5:nPuntos_Iniciales+i)', Coordenadas(:, 5:nPuntos_Iniciales+i));
disp("Ya")
    Representacion(Coordenadas, ruta);
end