
% Las coordenadas en columnas
function Solucion = NeoPolyGenesis(C)
    % Primera fase - División por capas
    [Indices, Len, N] = Topologia(C, (1:length(C))');

    % Setup para la segunda fase
    Solucion = Obtener_Capa(Indices, Len, N); % Puntos sueltos o la capa
    EC_pos = Obtener_Capa(Indices, Len, N-1);
    C = C';

    % Tratamiento de la capa más interna, si posee 1 o 2 puntos.
    if Len(end) > 0
        [~, Solucion] = Union(C(:, EC_pos), EC_pos, C(:, Solucion), Solucion);
    else
        Solucion = EC_pos;
    end

    for i = N-1:-1:2
        EC = EC_pos; % Pasamos a la capa siguiente
        EC_pos = Obtener_Capa(Indices, Len, i-1);
        [Solucion] = Expandir_TSP(C, Solucion, EC, EC_pos, [-1 -1]);
    end
end
