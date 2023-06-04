function [nuevoMapa, Coordenadas] = mediaMapa(Islas, Coordenadas)

% Siguiendo el método 1 de Testing Distancias
    for i = 1:size(Islas, 2)
        a = Islas(:, i);
        a = a(a > 0); % Nos quedamos con las ciudades, quitamos los espacios
        if length(a) > 1 % No tiene sentido hacer media si es 1 ciudad
            coords = [];
            for j = 1:length(a)
                coords = [coords; Coordenadas(a(j), :)];
            end
            coords = mean(coords);
            Coordenadas(a, :) = []; % Son las islas que he juntado
            Coordenadas(size(Coordenadas, 1) + 1, :) = coords;
        end
    end
    nuevoMapa = Crear_mCostes(Coordenadas);
end

