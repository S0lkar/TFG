
% Dada la envolvente convexa (EC) de un conjunto de puntos (Coords), asigna cada punto
% interior (PI) a aquel segmento donde cause la mínima ganancia, sin tener en
% cuenta el efecto de haber añadido otros puntos interiores. El conjunto de
% segmentos va representado como una estructura de 2 vectores, Indices
% y Len (donde Len indica la longitud de cada segmento en indices). Además
% indica qué segmentos han recibido puntos interiores.

function [Indices, Len] = AsignacionMinima(Coords, EC, PI)
    % Ganancia = dist(E, PI) + dist(PI, S) - dist(E, S)
    G = zeros(1, length(EC)-1);


    % dist(E, S), para todos los segmentos
    for i = 1:length(EC)-1
        G(i) = - norm(Coords(:, EC(i)) - Coords(:, EC(i+1)));
    end
    G_aux = G;
    Len = zeros(size(G)) + 2; % Len 2 porque cuentan los puntos de E/S.
    Indices = EC;
    Coords_EC = Coords(:, EC); % Evitar accesos triples a vectores

    % Ganancia de cada punto y asignación a su segmento correspondiente
    for i = 1:length(PI)
        G = G_aux;
        P = PI(i);
        for j = 1:length(EC)-1
             G(j) = G(j) + norm(Coords_EC(:, j) - Coords(:, P)) + norm(Coords_EC(:, j+1) - Coords(:, P));
        end
        [~, pos] = min(G);
        [Indices, Len] = Insertar_Segmento(Indices, Len, P, pos);
    end
end

