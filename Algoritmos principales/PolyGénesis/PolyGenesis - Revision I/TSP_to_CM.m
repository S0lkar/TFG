
% Versión mejorada de la unión TSP-CM original.
function TSP = TSP_to_CM(Coordenadas, TSP, EC, EC_pos, Segmento_Ignorado)

    %% Punto de la EC más cercano a cada uno de la EC_pos
    aux = zeros(size(EC));
    POS = zeros(size(EC_pos)); % Porisiones de los puntos dentro de la EC
    for i = 1:length(EC_pos)
        Coord = Coordenadas(:, EC_pos(i)); % Evitar repetir cálculos
        for j = 1:length(EC)
            aux(j) = norm(Coord - Coordenadas(:, EC(j)));
        end
        [~, POS(i)] = min(aux);
    end

    %% Comprobar pares de puntos
    % Comprobar el caso de end - 1

    for i = 1:length(EC_pos)
        % Ver la ganancia de la mejor opción entre i - i+1 y guardar sus
        % datos
    end

    %% Traslado del TSP al segmento de EC_pos seleccionado

end

