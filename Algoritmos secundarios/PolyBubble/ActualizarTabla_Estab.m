
% ind | Arista Solucion | Arista Subconjunto | Ganancia
% ind |   Ia   |   Ib   |    Ic    |    Id   |    G
function L = ActualizarTabla_Estab(C_S, I_S, L, C_Sub, I_Sub, Len, Ia, Ib)
    % Nos quedamos solo con la porción de la solución nueva (el subconjunto
    % antes añadido) y actualizamos la lista con ello.
    Hay_que_ordenar = false;
    pos_a = find(I_S == Ia, 1); pos_b = find(I_S == Ib, 1);
    tramo = pos_a:pos_b;

    if isempty(tramo) % está el fin del vector en medio
        I_S = [I_S(pos_a:end); I_S(1:pos_b)];
        C_S = [C_S(:, pos_a:end) C_S(:, 1:pos_b)];
    else
        I_S = I_S(tramo);
        C_S = C_S(:, tramo);
    end


    for i = 1:size(L, 1)
        [I_Conj, C_Conj] = Obtener_Conjunto(I_Sub, C_Sub, Len, L(i, 1));

        [Umin, Gmin] = MinimaGanancia_Arista(C_Conj, I_Conj, C_S, I_S, false);

        if Gmin < L(i, 6) % Hace falta actualizar
            L(i, 2:5) = Umin;
            L(i, 6) = Gmin;
            Hay_que_ordenar = true;
        end
    end

    if Hay_que_ordenar
        L = sortrows(L, 6, 'ascend');
    end
end