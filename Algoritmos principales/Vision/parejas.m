
% Hace lo mismo que cluster() pero mas eficiente, manteniendo el tamaño
% máximo de islas a 2.
function [Imagen, CoordsDesp] = parejas(CoordsAnt, Percentil)

% Paso 1.- Formar la matriz de costes
mCostes = Crear_mCostes(CoordsAnt);
% Paso 2.- Calcular el Percentil dado
valores = triu(mCostes);
P = prctile(valores(valores > 0), Percentil);

% Paso 3.- Escoger las parejas de ciudades a unir
[row, col] = find(mCostes <= P & mCostes > 0);
%disp(length(row)*2)

% Paso 4 (iterativo).- Quitar las uniones extras de ciudades ya mejor emparejadas
% Es poco común dar este paso si el mapa no hay muchos puntos equidistantes
% entre sí
    hubo_repe = false;
    cont = 1;
    while length(row)*2 > length(unique([row col]))
        % Uno de los dos de la pareja se repite posteriormente?
        Repe = find(row(cont+1:end) == row(cont) | col(cont+1:end) == row(cont));

        if ~isempty(Repe)
            Repe = [cont cont+Repe']; % Candidatos a mejor enlace
            distancias = zeros(1, length(Repe));
            for i = 1:length(Repe)
                distancias(i) = mCostes(row(Repe(i)), col(Repe(i)));
            end
            [~, mejor] = min(distancias);
            Repe(mejor) = []; % Enlace a conservar 
            row(Repe) = []; % Quitamos los repetidos
            col(Repe) = [];
            hubo_repe = true;
        end
    
        % El otro de la pareja se repite posteriormente?
        Repe = find(row(cont+1:end) == col(cont) | col(cont+1:end) == col(cont));
        if ~isempty(Repe)
            Repe = [cont cont+Repe']; % Candidatos a mejor enlace
            distancias = zeros(1, length(Repe));
            for i = 1:length(Repe)
                distancias(i) = mCostes(row(Repe(i)), col(Repe(i)));
            end
            [~, mejor] = min(distancias);
            Repe(mejor) = []; % Enlace a conservar 
            row(Repe) = []; % Quitamos los repetidos
            col(Repe) = [];
            hubo_repe = true;
        end
        if hubo_repe
            hubo_repe = false;
        else
            cont = mod(cont, length(row)) + 1;
        end
    end

% Paso 5.- Meter las ciudades no unidas en conjuntos separados
No_unidas = 1:length(CoordsAnt);
No_unidas([row col]) = [];

% Paso 6?.- Meter las uniones en la matriz y actualizar las coords
Imagen(1, :) = row;
Imagen(2, :) = col;
Imagen = [Imagen [No_unidas; zeros(1, length(No_unidas))]];

CoordsDesp = mediaMapa(Imagen, CoordsAnt);

end

