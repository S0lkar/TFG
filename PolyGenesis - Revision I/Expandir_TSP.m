
% Esta función recibe el TSP actual y la siguiente envolvente convexa,
% creando el TSP asociado a los puntos de ambos conjuntos.
% Segmento ignorado sólo para el caso de unir el TSP con la envolvente
% convexa exterior.

function Solucion = Expandir_TSP(Coordenadas, Solucion, EC, EC_pos, Segmento_Ignorado)
    % Unimos el TSP a un camino minimo exterior
    Solucion = Union_TSP_CM(Solucion, EC, EC_pos, Segmento_Ignorado);

    % Empieza en 2 por saltarse el propio segmento con todos los puntos
    % intermedios
    for i = 2:length(EC_pos)-1
        Seg_inicial = Extraer_Segmento(Solucion, EC_pos(1), EC_pos(i)); % Camino 'A' donde están los puntos intermedios
        Seg = [EC_pos(i), EC_pos(i+1)]; % Camino 'B', que es el contigüo a A. Sin puntos intermedios

        if(EC_pos(i) ~= Segmento_Ignorado(1) || EC_pos(i+1) ~= Segmento_Ignorado(2))
            [A, B] = Regla_de_Derivacion(Coordenadas, Seg_inicial, Seg, EC, EC_pos);
            % Sustituir los segmentos antiguos por los nuevos
            Solucion(1:EC_pos(i+1)) = [A B];
        end
    end

    Seg_inicial = Extraer_Segmento(Solucion, EC_pos(1), EC_pos(end)); % Camino 'A' donde están los puntos intermedios
    Seg = [EC_pos(end), EC_pos(1)]; % Camino 'B', que es el contigüo a A.
    if(EC_pos(end) ~= Segmento_Ignorado(1) || EC_pos(1) ~= Segmento_Ignorado(2))
        [A, B] = Regla_de_Derivacion(Coordenadas, Seg_inicial, Seg, EC, EC_pos);
        % Sustituir los segmentos antiguos por los nuevos
        Solucion = [A B];
    end

end

