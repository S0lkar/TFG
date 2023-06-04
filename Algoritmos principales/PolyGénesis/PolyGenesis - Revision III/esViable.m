

% Determina si el conjunto de puntos {set_ant, comb} es viable
% trasladarlo desde 'A' hasta 'B'. Es necesario que, si se quieren 
% ignorar puntos, éstos sean retirados de A antes de llamar a la función.

% Se puede optimizar, porque sí sé el tamaño final de A y de B.
function [esViable, B_new, A_new] = esViable(Coords, dist_or, set_ant, comb, A, B)
    % Unir comb a set_ant usando el orden en A (en A_new, B_new)
    j = 1; k = 1;
    A_new = []; B_new = B(1);
    if isempty(set_ant)
        set_ant = -1;
    end

    for i = 1:length(A)
        ind = A(i);
        if(ind == comb(j))
            B_new = [B_new; ind]; j = j + 1; %#ok<*AGROW> 
        elseif(ind == set_ant(k))
            B_new = [B_new; ind]; k = k + 1;
        else
            A_new = [A_new; ind];
        end
    end
    B_new = [B_new; B(2)];

    % Calcular la distancia global
    dist_total = CosteCM(A_new, Coords) + CosteCM(B_new, Coords);

    % devolver si la distancia calculada es menor que la original
    esViable = (dist_total < dist_or);
end

