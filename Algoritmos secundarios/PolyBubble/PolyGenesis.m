
% Las coordenadas en columnas
function Solucion = PolyGenesis(C)
    % Primera fase - División por capas
    [Indices, Len, N] = Estructura_convexa(C, (1:length(C))');

    % Setup para la segunda fase
    C = C';
    Solucion = Obtener_Conjunto(Indices, C, Len, N); % Puntos sueltos o la capa
    Capa_sig = Obtener_Conjunto(Indices, C, Len, N-1);

    % Al principio puede haber una reorganizacion, de los puntos sueltos interiores
    % a la capa mas interna (En solución
    if Len(end) > 0
        [~, Solucion] = Union(C(:, Capa_sig), Capa_sig, C(:, Solucion), Solucion);
        Representacion(C, Solucion);
    else
        Solucion = Capa_sig;
    end

    for i = N-1:-1:2
        Capa_ant = Capa_sig;
        Capa_sig = Obtener_Conjunto(Indices, C, Len, i-1);

        % A lo mejor se puede reutilizar cosas de la funcion como inputs y
        % así no tener que hacer más accesos
        Solucion = Fusion(C(:, Capa_ant), C(:, Capa_sig), C(:, Solucion), Capa_ant, Capa_sig, Solucion, C);
        Representacion(C, Solucion);
        pause();
    end
end

