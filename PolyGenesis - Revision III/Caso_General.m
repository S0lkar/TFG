
% Para resolver un TSP que consiste de más de dos anillos. Realiza la
% llamada recursiva para obtener el camino mínimo de los puntos interiores
% con uno de los segmentos de la EC más externa y aplica la técnica de
% optimización basada en la Regla de Derivación.

% [Indices, Len, N] son los valores que representan la Topología del TSP.
function TSP = Caso_General(Coordenadas, Segmento_Ignorado, Indices, Len, N)

    %% Llamada recursiva
    % Con los puntos interiores y un segmento que no sea el ignorado.

    EC_pos = Obtener_Capa(Indices, Len, 1);
    if EC_pos(1) == Segmento_Ignorado(1) && EC_pos(2) == Segmento_Ignorado(2)
        EC_pos = circshift(EC_pos, -1);
    end
    % Obtener los puntos de E/S (el primer segmento) y todos los interiores
    % (es decir, descartar el resto de EC_pos de las coordenadas) y obtener
    % el segmento a ignorar (el primero de nuevo) y hacer la llamada
    % recursiva

    PI = [EC_pos(1) setdiff(1:length(Coordenadas), EC_pos) EC_pos(2)];
    TSP = PolyGenesis(Coordenadas(:, PI), [1 length(PI)]);

    % "traducimos" la solución interior en los índices de la actual

    TSP = PI(Convertir_TSP_a_CM(TSP, 1, length(PI)));
    TSP = [TSP'; EC_pos(3:end)];

    
    %% Optimización con la Regla de Derivación
    
end