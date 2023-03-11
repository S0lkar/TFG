% Las coordenadas en columnas
function Solucion = NeoPolyGenesis(C)
    % Primera fase - División por capas
    [Indices, Len, N] = Estructura_convexa(C, (1:length(C))');

    % Setup para la segunda fase
    Solucion = Obtener_Capa(Indices, Len, N); % Puntos sueltos o la capa
    Capa_sig = Obtener_Capa(Indices, Len, N-1);
    C = C';

    % Al principio puede haber una reorganizacion, de los puntos sueltos interiores
    % a la capa mas interna (En solución
    if Len(end) > 0
        [~, Solucion] = Estabilizar(C(:, Capa_sig), Capa_sig, C(:, Solucion), Solucion);
    else
        Solucion = Capa_sig;
    end

    for i = N-1:-1:2
        Capa_ant = Capa_sig;
        Capa_sig = Obtener_Capa(Indices, Len, i-1);

        % A lo mejor se puede reutilizar cosas de la funcion como inputs y
        % así no tener que hacer más accesos
        Solucion = Fusion(C(:, Capa_ant), C(:, Capa_sig), C(:, Solucion), Capa_ant, Capa_sig, Solucion);
        %Representacion(C, Solucion);
    end
end
