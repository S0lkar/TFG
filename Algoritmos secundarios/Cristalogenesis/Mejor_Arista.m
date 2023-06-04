
% [Indices de los nodos de la arista, Ganancia]
% Coordenadas del punto, Coordenadas del anillo, Indices del anillo

function [Ia, Ib, Gmin] = Mejor_Arista(C_punto, C_Anillo, I_Anillo)

    N = length(I_Anillo);
    aux = zeros(1, N);
    aux(N) = Ganancia(C_Anillo(:, N), C_punto, C_Anillo(:, 1));

    for i = 1:N-1
        aux(i) = Ganancia(C_Anillo(:, i), C_punto, C_Anillo(:, i+1));
    end
    [Gmin, pos] = min(aux);
    if pos == N
        Ia = I_Anillo(N);
        Ib = I_Anillo(1);
    else
        Ia = I_Anillo(pos);
        Ib = I_Anillo(pos+1);
    end

end

