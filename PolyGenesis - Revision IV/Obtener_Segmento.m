
% Devuelve la segmento i-ésimo del conjunto
function Segmento = Obtener_Segmento(Indices, Len, i)
    if i == 1
        inicio = 1;
    else
        inicio = sum(Len(1:i-1)) - (i-1) + 1; % Tamaños de capas - nRecorridas + primera posicion
    end
    final = sum(Len(1:i)) - (i-1); % Tamaño de las capas hasta la actual - nRecorridas

    Segmento = Indices(inicio:final);
end

% I = [1 2 3 4 5 6 7 8 9 10];
% Len = [2 2 1 3 2];