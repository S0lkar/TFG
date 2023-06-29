
% Crea la lista usada en Estabilizar.
function L = CrearLista_Estab(C_S, I_S, C_Sub, I_Sub, Len)

    % Lista;
    % ind | Arista Solucion | Arista Subconjunto | Ganancia
    % ind |   Ia   |   Ib   |    Ic    |    Id   |    G
    % Para unir los subconjuntos, los enlaces finales siempre serán AC y BD
    % Si solo hay un punto, Ic == Id.

    L = zeros(length(Len), 6);
    for i = 1:length(Len)
        [I_Conj, C_Conj] = Obtener_Conjunto(I_Sub, C_Sub, Len, i);
            [Umin, Gmin] = MinimaGanancia_Arista(C_Conj, I_Conj, C_S, I_S, true);
            L(i, :) = [i Umin Gmin];
    end
    L = sortrows(L, 6, 'ascend'); % Ordenamos la lista por ganancia

end