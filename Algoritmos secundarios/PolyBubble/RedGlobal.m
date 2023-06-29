
% Se me ocurre hacer algo provisional aunque sea ineficiente, total...
function [C_S, I_S] = RedGlobal(C_S, I_S, I_Act, C_Act)
% Lista;
    % I_sig | Arista Mejor | Ganancia Minima
    % I_sig |  Ia  |  Ib   | Ganancia Minima
    L = zeros(length(I_Act), 4);
    for i = 1:length(I_Act)
        [Ia, Ib, Gmin] = MinimaGanancia(C_Act(:, i), C_S, I_S, true);
        L(i, :) = [I_Act(i) Ia Ib Gmin];
    end
    L = sortrows(L, 4, 'ascend'); % Ordenamos la lista por ganancia

    % Esto hay que remodelarlo porque hay que quitar el punto y ponerlo
    % donde se debe...y hay enlaces que se deben de mejorar...uf...
    for i = 1:length(I_Act)
        % Incluimos el punto de menor ganancia de la lista y continuamos
        pos_a = find(I_S == L(1, 2), 1);
        I_S = [I_S(1:pos_a); L(1, 1); I_S(pos_a+1:end)];
        pos_b = find(I_Act == L(1, 1), 1);
        C_S = [C_S(:, 1:pos_a) C_Act(:, pos_b) C_S(:, pos_a+1:end)];
    
        Ia = L(1, 2); Ib = L(1, 1); Ic = L(1, 3);
        Ca = C_S(:, pos_a); Cb = C_S(:, pos_a+1); Cc = C_S(:, mod(pos_a+1, length(I_S))+1);
        L(1, :) = []; % Punto colocado

        L = ActualizarTabla_Union(L, Ia, Ca, Ib, Cb, C_S, I_S);
        L = ActualizarTabla_Union(L, Ib, Cb, Ic, Cc, C_S, I_S);
    end
end