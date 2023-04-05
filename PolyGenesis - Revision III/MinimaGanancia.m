
% [Indices de los nodos de la arista, Ganancia]
% Coordenadas del punto, Coordenadas del conjunto, Indices del conjunto
% 'es_ciclico' determina si consideramos que es un vector circular o no.

function [Ia, Ib, Gmin] = MinimaGanancia(C_punto, C_Conj, I_Conj, es_ciclico, Segmento_ignorado)

    N = length(I_Conj);
    if es_ciclico
        aux = zeros(1, N);
        aux(N) = Ganancia(C_Conj(:, N), C_punto, C_Conj(:, 1));
    else
        aux = zeros(1, N-1);
    end

    for i = 1:N-1
        aux(i) = Ganancia(C_Conj(:, i), C_punto, C_Conj(:, i+1));
    end
    [Gmin, pos] = min(aux);
    if pos == N
        Ia = I_Conj(N);
        Ib = I_Conj(1);
    else
        Ia = I_Conj(pos);
        Ib = I_Conj(pos+1);
    end

    if (Ia == Segmento_ignorado(1) && Ib == Segmento_ignorado(2)) || (Ia == Segmento_ignorado(2) && Ib == Segmento_ignorado(1))
        aux(pos) = inf;
        [Gmin, pos] = min(aux);
        if pos == N
            Ia = I_Conj(N);
            Ib = I_Conj(1);
        else
            Ia = I_Conj(pos);
            Ib = I_Conj(pos+1);
        end
    end

end

