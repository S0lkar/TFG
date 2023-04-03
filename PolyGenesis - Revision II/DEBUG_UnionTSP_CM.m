

% Coordenadas con todos los puntos
load C.mat
nPuntos = 3;
Coordenadas = C([1 13 12 22 20 7 14 8], :);

% Envolvente convexa de los puntos 1...nPuntos
EC = convhulln(Coordenadas(1:nPuntos, :)); 
EC = EC(:, 1)';

% Siguiente anillo que forma la envolvente convexa posterior
EC_pos = convhulln(Coordenadas(nPuntos+1:end, :)); 
EC_pos = nPuntos + EC_pos(:, 1)';

EC_pos = 4:8;
%EC_pos = circshift(EC_pos, 1);

% Unión de ambos conjuntos
TSP = Union_TSP_CM(Coordenadas', 1:nPuntos, EC, EC_pos, [-1 -1]);
DEBUG_verRuta(TSP, Coordenadas, false);