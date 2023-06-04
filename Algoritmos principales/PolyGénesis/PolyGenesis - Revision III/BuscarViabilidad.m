
% Comprueba si existe un set de puntos de la capa I-ésima que sea beneficioso
% trasladarlo de 'A' a 'B'. Para capas posteriores a la primera, sólo comprueba
% aquellos puntos que, además, estén situados o en un segmento escogido o en uno de los
% dos contiguos a los escogidos.
% Ignora puntos de capas más interiores.

function Set = BuscarViabilidad(Coords, A, B, Indices, Len, I, Set)

    % Quitamos los puntos de A que sean de capas posteriores a la actual.
    % Esto habrá que cambiarlo a literalmente QUITARLOS de A.
    aux = A([1 end]); % los puntos de E/S
    inds = [];
    for i = 1:I % puntos interiores de las capas '1' hasta la I.
        inds = [inds Obtener_Capa(Indices, Len, i)]; %#ok<AGROW> 
    end
    A = [aux(1) A(inds) aux(2)];
    EC = Obtener_Capa(Indices, Len, I);
    dist_or = CosteCM(A, Coords) + norm(B(:, 1) - B(:, 2)); % Distancia original = dist(A) + dist(B);

    % Obtener los sets de dependencia de cada punto de la capa actual
    % Si no es la primera capa tengo que mirar que sean puntos interiores
    % de un segmento escogido o contiguo a los mismos.

    % Revisar 'Envolvente Convexa de un Camino Mínimo'
    if (I == 1)
        for i = 1:length(EC)
            % función para obtener el set de dependencia del punto EC(i) y
            % la longitud. tener un contador para la cantidad de puntos.
        end
    else
        for i = 1:length(EC)
            % comprobar que pertenece a un segmento o de uno contiguo de
            % los del Set.

            % función para obtener el set de dependencia del punto EC(i) y
            % la longitud. tener un contador para la cantidad de puntos.
        end
    end
    

    % Comprobar combinaciones de sets de depencia
    % Y quedarme con el B_new más grande viable (excluyendo los 2 primeros
    % puntos)
    set_new = [];
    for i = 1:length(comb)
        for j = i:length(comb)
            % Union del set i con el set j. Si no es igual a i, procedo.
            % Puedo reusar la función de 'Obtener_Capa' ya que es la misma
            % estructura.
            Union = union(comb{i}, comb{j}, 'stable');
            if(~isequal(Union, comb{i}))
                % Comprobación de viabilidad
                [esViable, B_new, A_new] = esViable(Coords, dist_or, Set, Union, A, B);
                % Guardar el más grande
            end
        end
    end
    % El 'set' es B_new sin la E/S. Aunque podría devolver también B_new y
    % A_new para que así ya tenga la división hecha luego. Pero vamos, si
    % no sería copiar el bucle que está en 'esViable'.
end

