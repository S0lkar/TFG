

% Cambiar a 'Obtener_Conjunto'
% Extrae un subconjunto de la familia Indices.
% n es el índice del subconjunto que quieres obtener.
function [I_Conj, C_Conj] = Obtener_Conjunto(Indices, Coords, Len, N)
    skip = sum(Len(1:N-1)); % Cuantas posiciones me tengo que saltar
    tramo = (skip+1):(skip+Len(N));
    I_Conj = Indices(tramo); % El fragmento a extraer
    C_Conj = Coords(:, tramo);
end

% I = [1 2 3 4 5 6 7 8 9 10];
% Len = [2 2 1 3 2];