
% Une los puntos individuales (PI) a las aristas del circuito (S).
function I_S = Union(C_S, I_S, C_PI, I_PI)

    Ct = [C_PI C_S]; % todas las coordenadas
    It = [I_PI; I_S]; % todos los indices
    % Lista;
    % I_sig | Arista Mejor | Ganancia Minima
    % I_sig |  Ia  |  Ib   | Ganancia Minima
    L = zeros(length(I_PI), 4);
    for i = 1:length(I_PI)
        [Ia, Ib, Gmin] = MinimaGanancia(C_PI(:, i), C_S, I_S, true);
        L(i, :) = [I_PI(i) Ia Ib Gmin];
    end
    if ~isempty(I_PI)
        L = sortrows(L, 4, 'ascend'); % Ordenamos la lista por ganancia
    end
    for i = 1:length(I_PI)
        % Incluimos el punto de menor ganancia de la lista y continuamos
        pos_a = find(I_S == L(1, 2), 1);
        I_S = [I_S(1:pos_a); L(1, 1); I_S(pos_a+1:end)];
        pos_b = find(I_PI == L(1, 1), 1);
        C_S = [C_S(:, 1:pos_a) C_PI(:, pos_b) C_S(:, pos_a+1:end)];
    
        Ia = L(1, 2); Ib = L(1, 1); Ic = L(1, 3);
        Ca = C_S(:, pos_a); Cb = C_S(:, pos_a+1); Cc = C_S(:, mod(pos_a+1, length(I_S))+1);
        L(1, :) = []; % Punto colocado

        L = ActualizarTabla_Union(L, Ia, Ca, Ib, Cb, Ct, It);
        L = ActualizarTabla_Union(L, Ib, Cb, Ic, Cc, Ct, It);
    end
end