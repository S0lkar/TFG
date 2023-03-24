
% Esta función recibe el TSP actual y la siguiente envolvente convexa,
% creando el TSP asociado a los puntos de ambos conjuntos.
% Segmento ignorado sólo para el caso de unir el TSP con la envolvente
% convexa exterior.

function Solucion = Expandir_TSP(Coordenadas, Solucion, EC, EC_pos, Segmento_Ignorado)
    % Unimos el TSP a un camino minimo exterior
    Solucion = Union_TSP_CM(Solucion, EC, EC_pos, Segmento_Ignorado);

    for i = 1:length(EC_pos)
        % Obtener segmento dado los puntos de entrada y salida (EC(i) y EC(i+1))

        if(EC_pos(i) ~= Segmento_Ignorado(1) || EC_pos(i+1) ~= Segmento_Ignorado(2))
            [A, B] = Regla_de_Derivacion(Coordenadas, A, B);
            % Sustituir los segmentos antiguos por los nuevos
        end
    end

end

