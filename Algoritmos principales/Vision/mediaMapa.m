function CoordenadasAux = mediaMapa(Islas, Coordenadas)
% Siguiendo el método 1 de Testing Distancias;
%
%    Islas   : Matriz con las ciudades a unir 
%    Coords  : Localizacion de las ciudades. Se actualizará al unir.
%    mCostes : Matriz de Costes entre las ciudades nuevas.

    CoordenadasAux = zeros(size(Islas, 2), 2);
    for i = 1:size(Islas, 2)
        a = Islas(:, i);
        a = a(a > 0); % Nos quedamos con las ciudades, quitamos los espacios
        if length(a) > 1 % No tiene sentido hacer media si es 1 ciudad
            coords = [];
            for j = 1:length(a)
                coords = [coords; Coordenadas(a(j), :)];
            end
            coords = mean(coords);
            %Coordenadas(a, :) = []; % Son las islas que he juntado
            CoordenadasAux(i, :) = coords;
        else
            CoordenadasAux(i, :) = Coordenadas(a, :);
        end
    end
end

