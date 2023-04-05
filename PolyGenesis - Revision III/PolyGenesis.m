
% Las coordenadas en n columnas.
function TSP = PolyGenesis(Coordenadas, Segmento_Ignorado)
    [Indices, Len, N] = Topologia(Coordenadas', (1:length(Coordenadas))');

    % Setup para la segunda fase
    TSP = Obtener_Capa(Indices, Len, N); % Puntos interiores
    EC_pos = Obtener_Capa(Indices, Len, N-1);

    if N == 2 % Caso Base: resoluble con la unión de las dos ECs más internas.

        if Len(end) == 0 % No hay puntos internos -> La penúltima capa es la solución.
            TSP = EC_pos;
        else % Existen 1 o 2 puntos internos -> Su unión con la penúltima capa es la solución.
            TSP = Union(Coordenadas(:, EC_pos), EC_pos, Coordenadas(:, TSP), TSP, Segmento_Ignorado);
        end

    else % Caso General: Llamada recursiva para formar el 'segmento completo' y llevado a TSP aplicando la RdD.

        TSP = Caso_General(Coordenadas, Segmento_Ignorado, Indices, Len, N);

    end
    
end

