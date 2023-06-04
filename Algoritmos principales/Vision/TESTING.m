
%close all;
%CoordsDes = [-2 0.5; 0 2; -1.6 0; 1.6 0; 1 1.6; 1.8 0.4];
%CoordsAnt = [-2 0.5; 0 2; -1.6 0; 1.6 0; 1 1.6; 1.8 0.4];
%UComp = [1 2; 2 3; 3 1];
%ImgDes = [1 2 4; 3 5 6];
% row = [1 2 4 5]; col = [3 5 6 6]; % para probar las parejas
% UDes = Avanzar(UComp, ImgDes, CoordsDes);

Percentil = 1;
load Coordenadas 
Solucion = Vision(Coordenadas, Percentil);