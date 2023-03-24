
% Dados el TSP (Solucion y su envolvente convexa EC) y los puntos
% exteriores (EC_pos), une el TSP a uno de los segmentos, manteniendo la
% propiedad de ser un camino minimo.

% Al final CM tendrá tanto los puntos del TSP como de la capa siguiente.
% E y S son los puntos de entrada y salida de donde se colocaron los puntos
% interiores.
function [CM, E, S] = Union_TSP_CM(Coordenadas, Solucion, EC, EC_pos, Segmento_Ignorado)
    CM = Solucion + EC + EC_pos - Segmento_Ignorado;
    E=1;S=2;
end

