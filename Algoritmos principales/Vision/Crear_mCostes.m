
% Crea la matriz de costes a partir de una lista de coordenadas de las
% ciudades.
function mCostes = Crear_mCostes(Coordenadas)
% Se puede mejorar cambiando la distancia euclidea.
    mCostes = zeros(length(Coordenadas), length(Coordenadas));
    for i = 1:length(Coordenadas)
        for j = i:length(Coordenadas)
            aux = Coordenadas(i, :)' - Coordenadas(j, :)' * ones(1, 1);
            mCostes(i, j) = sum(aux.*aux);% d_euclid(Coordenadas(i, :)', Coordenadas(j, :)');
            mCostes(j, i) = mCostes(i, j);
        end
    end
end