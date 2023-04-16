
% Las coordenadas en n columnas.
function TSP = PolyGenesis(Coordenadas, Segmento_Ignorado)

    EC = convexHull(delaunayTriangulation(Coordenadas(1, :)', Coordenadas(2, :)'));

    if(isempty(Segmento_Ignorado)) % Si es el TSP global, simplemente pasamos del formato de convexHull al vectorial circular
        EC = EC(1:end-1);
        TSP = EC;
    else % Si hay que ignorar segmentos, además se pone un extremo al inicio y otro al final
        EC = EC2CM(EC, Segmento_Ignorado(1), Segmento_Ignorado(2)); % E - PI - S
        TSP = EC;
    end
        
    % En el caso base no tengo que ignorar el segmento 1-end...
    if (length(TSP) < length(Coordenadas)) % Caso general
        % en el caso de que sea la primera llamada, no debo de descartar
        % ningún segmento, por ello vuelvo al formato de convexHull
        if(isempty(Segmento_Ignorado))
            EC = [EC; EC(1)];
        end

        % Asignar puntos interiores a sus segmentos de minima ganancia
        PI = 1:length(Coordenadas);
        PI(EC) = [];
        [Indices, Len] = AsignacionMinima(Coordenadas, EC, PI);

        Segmentos_Agrandados = Len > 2;

        % Resolver cada segmento actualizado
        for i = 1:length(Len)
            if(Segmentos_Agrandados(i))
                Seg = Obtener_Segmento(Indices, Len, i);
                Seg = Seg(PolyGenesis(Coordenadas(:, Seg), [1 length(Seg)]));
                
                [Indices, Len] = Substituir_Segmento(Indices, Len, Seg, i);
            end
        end

        % Teorema de los Arcos Irregulares


        % Output
        TSP = Indices;
    end

end

