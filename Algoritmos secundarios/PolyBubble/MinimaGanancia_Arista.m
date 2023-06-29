
% [Indices de los nodos de la arista, Ganancia]
% Coordenadas del punto, Coordenadas del anillo, Indices del anillo
% 'es_ciclico' determina si consideramos que es un anillo o no.

% ind | Arista Solucion | Arista Subconjunto | Ganancia
% ind |   Ia   |   Ib   |    Ic    |    Id   |    G
% Para unir los subconjuntos, los enlaces finales siempre serán AC y BD
% Si solo hay un punto, Ic == Id.

function [Umin, Gmin] = MinimaGanancia_Arista(C_Conj, I_Conj, C_S, I_S, es_ciclico)

    % Calcular la EC del subconjunto. 2 o 1 puntos ya son su propia EC.
    if length(I_Conj) > 2
        Anillo = convhulln(C_Conj'); 
        Anillo = Anillo(:, 1)';
        C_Conj = C_Conj(:, Anillo);
        I_Conj = I_Conj(Anillo);
    end

    N = length(I_S);
    if es_ciclico
        Gs = inf(1, N);
        Union = zeros(N, 4);
        for j = 1:length(I_Conj)
            [Gaux, flip] = Ganancia_Arista(C_S(:, N), C_S(:, 1), C_Conj(:, j), C_Conj(:, mod(j, length(I_Conj))+1));
            if Gaux < Gs(N)
                Gs(N) = Gaux;
                if flip
                    Union(N, :) = [I_S(N) I_S(1) I_Conj(mod(j, length(I_Conj))+1) I_Conj(j)];
                else
                    Union(N, :) = [I_S(N) I_S(1) I_Conj(j) I_Conj(mod(j, length(I_Conj))+1)];
                end
            end
        end
    else
        Gs = inf(1, N-1);
        Union = zeros(N-1, 4);
    end

    for i = 1:N-1
        for j = 1:length(I_Conj)
            [Gaux, flip] = Ganancia_Arista(C_S(:, i), C_S(:, i+1), C_Conj(:, j), C_Conj(:, mod(j, length(I_Conj))+1));
            if Gaux < Gs(i)
                Gs(i) = Gaux;
                if flip
                    Union(i, :) = [I_S(i); I_S(i+1); I_Conj(mod(j, length(I_Conj))+1); I_Conj(j)]';
                else
                    Union(i, :) = [I_S(i); I_S(i+1); I_Conj(j); I_Conj(mod(j, length(I_Conj))+1)]';
                end
            end
        end
    end

    [Gmin, pos] = min(Gs);
    Umin = Union(pos, :);

end

