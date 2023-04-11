
% Regla_Derivacion devuelve qué puntos interiores de 'A' se han de trasladar a 'B'
% para minimizar la distancia global de entre ambos caminos mínimos.
% Coords -> Coordenadas de los puntos
% A -> indices de los puntos del CM 'A'.
% B -> indices de los puntos de E/S del CM 'B'.
% [Indices, Len, N] -> Información sobre la topología de 'A'.
% i -> capa i-ésima sobre la que buscamos el set viable.
% set_ant -> set anterior de puntos escogidos para su traslado de 'A' a 'B'.


% Primera llamada; set = Regla_Derivacion(Coords, A, B, Indices, Len, N, 2, []);


function Set = Regla_Derivacion(Coords, A, B, Indices, Len, N, i, set_ant)
%Debe devolver todos los sets viables.
    Set = BuscarViabilidad(Coords, A, B, Indices, Len, i, set_ant);

    if(length(Set) == length(set_ant)) % No hay ningún set en la capa actual que sea viable trasladar
        return; % Habría que devolver un 'trigger' a todos los puntos de la llamada anterior
        % (devolviendo un segundo parámetro con los 'puntos actualizados'
        % con todos los de esta EC)
    else
        % Debo de seguir con el set mas grande. Si el comprobante da que ya
        % no es viable ('es viable' con todos los puntos), debo de pasar al
        % siguiente set mas grande.
        Set = Regla_Derivacion(Coords, A, B, Indices, Len, N, i+1, Set);
        Set = Comprobante(Coords, A, B, Indices, Len, N, Set, i);
    end

end

