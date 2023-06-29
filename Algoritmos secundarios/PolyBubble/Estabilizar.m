
% C_S, I_S -> Solución
% C_Sub, I_PI -> Puntos de la antigua EC
% C_Sub, I_Sub -> Subsets
function [C_S, I_S] = Estabilizar(C_S, I_S, C_PI, I_PI, C_Sub, I_Sub, Len)
    [C_S, I_S] = Union(C_S, I_S, C_PI, I_PI); % Unimos los puntos de la antigua EC

    % Lista;
    % ind | Arista Solucion | Arista Subconjunto | Ganancia
    % ind |   Ia   |   Ib   |    Ic    |    Id   |    G
    L = CrearLista_Estab(C_S, I_S, C_Sub, I_Sub, Len);

    while ~isempty(L)
        [I_Conj, C_Conj] = Obtener_Conjunto(I_Sub, C_Sub, Len, L(1, 1));
        [C_S, I_S] = Colocar(C_S, I_S, L(1, 2:5), C_Conj, I_Conj);
        
        Ia = L(1, 1); Ib = L(1, 2); % Puntos entre los que ahora se encuentra el subconjunto
        L(1, :) = [];
        % Ia-Ib dice de donde a donde deben de comprobar para actualizarse
        L = ActualizarTabla_Estab(C_S, I_S, L, C_Sub, I_Sub, Len, Ia, Ib);
    end

    % MEJORAR IMPLEMENTACION. Reduce el perímetro global.
    % USAR TENSION SUPERFICIAL.
    %[C_S, I_S] = RedGlobal2(C_S, I_S, I_S, C_S);
end