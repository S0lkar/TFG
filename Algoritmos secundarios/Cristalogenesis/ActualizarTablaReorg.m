
% L = Lista    -> I_des(i) Ia Ib Gmin 0
% Ia, Ib = arista
% C = coordenadas
% Actualiza la tabla con la arista dada.
function [L] = ActualizarTablaReorg(L, Ia, Ca, Ib, Cb, C, I, I_CA)  %I_CA para la comprobacion
    Hay_que_ordenar = false;

    for i = 1:size(L, 1)
        pos = find(I == L(i, 1), 1);
        pos_cmp = find(I_CA == L(i, 1), 1);
        G = Ganancia(Ca, C(:, pos), Cb); 
        if (G < L(i, 4)) && L(i, 5) > 0 && (Ia ~= I_CA(mod(pos_cmp-2, length(I_CA))+1)) && (Ib ~= I_CA(mod(pos_cmp, length(I_CA))+1)) % mejor ganancia y no es en la que está

            L(i, :) = [L(i, 1) Ia Ib G 1]; % marcamos como colocada pero no óptima
            Hay_que_ordenar = true;
        elseif L(i, 5) == 0
            Hay_que_ordenar = true;
        end
    end

    if Hay_que_ordenar
        aux = sortrows(L(L(:, 5) < 2, :), 2, 'ascend');
        L = [aux; L(L(:, 5) == 2, :)]; % los optimos abajo
    end
end

