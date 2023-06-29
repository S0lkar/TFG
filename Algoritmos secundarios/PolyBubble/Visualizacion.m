clear
clc
close all
load C.mat
C = Coordenadas; % Por comodidad para usar la función Ganancia
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
%      ¿Cómo queda representado visualmente lo
%                                   hecho hasta ahora?
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %

nPuntos_Iniciales = 8;
nPuntos_Desarrollo = 0;
paso = 1;
%Coordenadas = [];
%[x, y] = ginput(nPuntos_Iniciales);
%Coordenadas = [Coordenadas [x';y']];

Solucion = PolyGenesis(Coordenadas');
Representacion(Coordenadas, Solucion);

for i = 1:nPuntos_Desarrollo
    [x, y] = ginput(paso);
    Coordenadas = [Coordenadas [x';y']];
    Solucion = PolyGenesis(Coordenadas');
    Representacion(Coordenadas, Solucion);
end