
 % Nota: Entre cada paso recursivo, los TSP deben de comenzar por el punto
 % 1.
% 'Union' también debe de ignorar el segmento que sea...
% Puedo hacer que el segmento ignorado esté en (end,1) y marcar
% 'MinimaGanancia' como no cíclico. Usaré los -1 del principio para saber
% de cuándo se trata de la primera llamada y cuando no.

% Hacer otro codigo pequeño para probar 'union' arreglado y cuando vaya
% bien volver a probar la recursividad

%[xi, yi] = ginput(10);
%C = [xi, yi]';
%TSP = PolyGenesis(C, [-1 -1]);
%DEBUG_verRuta(TSP, C, false);

load Debug_Recursividad.mat
TSP = PolyGenesis(Debug_Recursividad, [-1 -1]);
DEBUG_verRuta(TSP, Debug_Recursividad, false);
