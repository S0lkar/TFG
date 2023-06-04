
% L = Lista    -> I_des(i) Ia Ib Gmin 0
% Ia, Ib = arista
% C = coordenadas
% Actualiza la tabla con la arista dada.
function [L] = ActualizarTabla(L, Ia, Ca, Ib, Cb, C)
    Hay_que_ordenar = false;

    for i = 1:size(L, 1)
        G = Ganancia(Ca, C(:, L(i, 1)), Cb);
        if G < L(i, 4)
            L(i, :) = [L(i, 1) Ia Ib G]; % Actualizamos la arista
            Hay_que_ordenar = true;
        end
    end

    if Hay_que_ordenar
        L = sortrows(L, 4, 'ascend');
    end
end

