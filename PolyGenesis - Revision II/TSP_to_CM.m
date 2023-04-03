
% Versión mejorada de la unión TSP-CM original.
function TSP = TSP_to_CM(Coordenadas, TSP, EC, EC_pos, Segmento_Ignorado)

    %% Obtener un segmento del conjunto de CMs (comprobando que no sea el ignorado)
    % Al cual le será acoplado el TSP.
    if EC_pos(1) ~= Segmento_Ignorado(1) && EC_pos(2) ~= Segmento_Ignorado(2)
        E = EC_pos(1); S = EC_pos(2); index = 0;
    else
        E = EC_pos(2); S = EC_pos(3); index = 1;
    end

    %% Obtener el alfa y beta límites
    Coord_E = Coordenadas(:, E); % Evitar repetir accesos
    Coord_S = Coordenadas(:, S);
    aux_E = zeros(1, length(EC));
    aux_S = zeros(1, length(EC));
    for j = 1:length(EC)
        C = Coordenadas(:, EC(j));
        aux_E(j) = norm(Coord_E - C);
        aux_S(j) = norm(Coord_S - C);
    end

    [~, alfa] = min(aux_E);
    [~, beta] = min(aux_S);


    %% Obtener el alfa y beta reales
    [Sentido, alfa, beta, PI] = Enlazar(Coordenadas, TSP, EC, alfa, beta, E, S);


    %% Traslado del TSP al segmento de EC_pos seleccionado
    if PI
        CM = NeoPolyGenesis(Coordenadas(:, [E S TSP]), [E S]);
    else
        % Alfa y beta son los índices
        CM = Convertir_TSP_a_CM(TSP, alfa, beta);
    end

    if Sentido
        CM = flip(CM);
    end

    % Unir el CM en el conjunto (EC_pos) y hacer circshift para que la
    % E esté en la primera posición.
    if index == 0
        TSP = [EC_pos(1) CM EC_pos(2:end)];
    else
        TSP = [EC_pos(1:2) CM EC_pos(3:end)];
        TSP = circshift(TSP, -1);
    end

end

