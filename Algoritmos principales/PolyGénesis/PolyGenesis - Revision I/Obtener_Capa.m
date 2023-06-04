% Otra función de comodidad. Está siguiendo la primera representación
% de todas.
% n es la capa que quieres obtener.
function Halo = Obtener_Capa(Indices, Len, N)
    skip = sum(Len(1:N-1)); % Cuantas posiciones me tengo que saltar
    Halo = Indices((skip+1):(skip+Len(N))); % el cacho que sería
end

% I = [1 2 3 4 5 6 7 8 9 10];
% Len = [2 2 1 3 2];