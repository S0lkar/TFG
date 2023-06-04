
% Dados el TSP, su envolvente convexa (EC) y los puntos
% exteriores (EC_pos), une el TSP a uno de los segmentos, manteniendo la
% propiedad de ser un camino minimo.

% Al final CM tendrá tanto los puntos del TSP como de la capa siguiente.
% E y S son los puntos de entrada y salida de donde se colocaron los puntos
% interiores.

% Le tengo que hacer los circshifts necesarios como para que el punto de
% entrada al segmento con todos los intermedios esté al inicio del vector.
% Así me simplifica todo el proceso posterior.

function TSP = Union_TSP_CM(Coordenadas, TSP, EC, EC_pos, Segmento_Ignorado)

    %% Tomamos el camino mínimo con menos puntos intermedios
    [D, E, S] = CM_MinimaLong(TSP, EC);

    %% Comprobar con qué segmento de la EC_pos casa mejor
    cE = Coordenadas(:, E); cS = Coordenadas(:, S);
    Rotura_TSP = norm(cE - cS);
    % Falta ignorar el caso del Segmento Ignorado -----------

    % Ganancia = Enlaces formados - Enlaces rotos
    Opc1 = norm(cE - Coordenadas(:, EC_pos(end))) + norm(cS - Coordenadas(:, EC_pos(1)));
    Opc2 = norm(cE - Coordenadas(:, EC_pos(1))) + norm(cS - Coordenadas(:, EC_pos(end)));
    % Falta comprobar que no hay intersecciones.

    min_G = min(Opc1, Opc2) - (norm(Coordenadas(:, EC_pos(end)) - Coordenadas(:, EC_pos(1))) + Rotura_TSP);
    Sentido = Opc1 > Opc2;
    index = 0; seg_E = EC_pos(end); seg_S = EC_pos(1);

    for i = 1:length(EC_pos)-1
        Opc1 = norm(cE - Coordenadas(:, EC_pos(i))) + norm(cS - Coordenadas(:, EC_pos(i+1)));
        Opc2 = norm(cE - Coordenadas(:, EC_pos(i+1))) + norm(cS - Coordenadas(:, EC_pos(i)));
        
        % Método para saber si hay intersecciones y "anular" una o ambas
        % opciones si se necesita.
        % Lo podría hacer comprobando si hay un punto a menos distancia del
        % de la EC_pos que estoy uniendo. Si lo hay (y no es ninguno de los que estoy uniendo), 
        % es que tiene que haber una intersección por fuerza
        
        G = min(Opc1, Opc2) - (norm(Coordenadas(:, EC_pos(i))-Coordenadas(:, EC_pos(i+1))) + Rotura_TSP);
        
        if(G < min_G)
            min_G = G;
            Sentido = Opc1 > Opc2; 
            seg_E = i; seg_S = i+1; index = i;
        end
    end
    
    % Transformamos el TSP en CM, para insertarlo en el CM exterior en el
    % sentido necesario.
    if D == 0
        CM = Convertir_TSP_a_CM(TSP, E, S);
    else
        CM = NeoPolyGenesis(Coordenadas(:, [EC_pos(seg_E) EC_pos(seg_S) TSP]), [EC_pos(seg_E) EC_pos(seg_S)]);
    end

    if Sentido
        CM = flip(CM);
    end

    %% Unir el TSP convertido a CM con el CM seleccionado del conjunto exterior
    if index == 0
        TSP = [EC_pos(end) CM EC_pos(1:end-1)]; index = 1;
    else
        TSP = [EC_pos(1:seg_E) CM EC_pos(seg_S:end)];
    end
    
    % Shiftear el segmento con los puntos interiores al inicio
    TSP = circshift(TSP, -(index-1));
end

