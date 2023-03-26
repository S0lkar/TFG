
% Dados el TSP (Solucion y su envolvente convexa EC) y los puntos
% exteriores (EC_pos), une el TSP a uno de los segmentos, manteniendo la
% propiedad de ser un camino minimo.

% Al final CM tendrá tanto los puntos del TSP como de la capa siguiente.
% E y S son los puntos de entrada y salida de donde se colocaron los puntos
% interiores.

% Le tengo que hacer los circshifts necesarios como para que el punto de
% entrada al segmento con todos los intermedios esté al inicio del vector.
% Así me simplifica todo el proceso posterior.

function Solucion = Union_TSP_CM(Coordenadas, Solucion, EC, EC_pos, Segmento_Ignorado)
   Solucion = Solucion + EC + EC_pos - Segmento_Ignorado;
end

