
function [I_CA, C_CA] = Reorganizacion(I_CA, C_CA, I_des, C_des)
    L = zeros(length(I_des), 5);
    for i = 1:length(I_des)
        [Ia, Ib, Gmin] = Mejor_Arista(C_des(:, i), C_CA, I_CA);
        L(i, :) = [I_des(i) Ia Ib Gmin 0];
    end
    L = sortrows(L, 4, 'ascend');

    while (L(1, 5) ~= 2) % Mientras queden por colocar/no estén óptimos
        if L(1, 5) == 1 % Está colocado y no es óptimo, hay que quitarlo
            pos_pt = find(I_CA == L(1, 1), 1);
            I_CA(pos_pt) = [];
            C_CA(:, pos_pt) = [];
        end

        pos_pt = find(I_des == L(1, 1), 1); % como se ordenó, necesito de nuevo el índice
        pos_a = find(I_CA == L(1, 2), 1);
        pos_b = mod(pos_a + 1, length(I_CA)) + 1;

        % Añadimos el punto al circuito actual
        C_CA = [C_CA(:, 1:pos_a) C_des(:, pos_pt)  C_CA(:, pos_a+1:end)];
        I_CA = [I_CA(1:pos_a); I_des(pos_pt); I_CA(pos_a+1:end)];
        L(1, 5) = 2;
        % ------------------------------------
          
        % Actualizamos la lista con las dos nuevas aristas de la CA.
        Ia = L(1,2); Ca = C_CA(:, pos_a); % Lo guardo por si se reordena
        Ib = L(1,1); Cb = C_des(:, pos_pt);
        Ic = L(1,3); Cc = C_CA(:, pos_b);

        L = ActualizarTablaReorg(L, Ia, Ca, Ib, Cb, C_des, I_des, I_CA);
        L = ActualizarTablaReorg(L, Ib, Cb, Ic, Cc, C_des, I_des, I_CA);
    end


end

