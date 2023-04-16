
% Inserta el punto dado (P) en el segmento i.
function [Indices, Len] = Insertar_Segmento(Indices, Len, P, i)

    if i == 1
        skip = 1;
    else
        skip = sum(Len(1:i-1)) - (i-1) + 1; % Tamaños de capas - nRecorridas + primera posicion
    end
    
    Indices = [Indices(1:skip); P; Indices(skip+1:end)];
    Len(i) = Len(i) + 1;
end

