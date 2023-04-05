
 % Nota: Entre cada paso recursivo, los TSP deben de comenzar por el punto
 % 1.
 
%[xi, yi] = ginput(10);
%C = [xi, yi]';
%TSP = PolyGenesis(C, [-1 -1]);
%DEBUG_verRuta(TSP, C, false);

load Debug_Recursividad.mat
TSP = PolyGenesis(Debug_Recursividad, [-1 -1]);
DEBUG_verRuta(TSP, Debug_Recursividad, false);
