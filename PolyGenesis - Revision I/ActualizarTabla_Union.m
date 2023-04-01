
% L = Lista    -> I_des(i) Ia Ib Gmin 0
% Ia, Ib = arista
% C = coordenadas
% Actualiza la tabla con la arista dada.
function L = ActualizarTabla_Union(L, Ia, Ca, Ib, Cb, Coords, Ind)
    Hay_que_ordenar = false;

    for i = 1:size(L, 1)
        pos = find(Ind == L(i, 1), 1);
        G = Ganancia(Ca, Coords(:, pos), Cb);
        if G < L(i, 4)
            L(i, :) = [L(i, 1) Ia Ib G]; % Actualizamos la arista
            Hay_que_ordenar = true;
        end
    end

    if Hay_que_ordenar
        L = sortrows(L, 4, 'ascend');
    end
end

