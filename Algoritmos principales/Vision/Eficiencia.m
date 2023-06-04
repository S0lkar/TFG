
load Coordenadas
load Islas
load mCostes
nE = 367;
% para 734 ciudades, da un tiempo de 23.4s

CoordsDes = [-2 0.5; 0 2; -1.6 0; 1.6 0; 1 1.6; 1.8 0.4];
UComp = [1 2; 2 3; 3 1];
ImgDes = [1 2 4; 3 5 6];

T = 0;
for i = 1:nE
    tic
    UDes = Avanzar(UComp, ImgDes, CoordsDes);
    % ---------------------------------------------------
%     a = triu(mCostes);
%     a = a(a>0);
%     P = prctile(a,2);
%     C = mCostes(mCostes < P);
%     mC = Crear_mCostes(Coordenadas);
    % ---------------------------------------------------
    Crear_mCostes(Coordenadas);
    T = T + toc;
end
disp("Tiempo medio: " + T/nE);