
% El objetivo de Colocar es situar los puntos del subconjunto 
% en donde generan la menor canancia.
function [C_S, I_S] = Colocar(C_S, I_S, Puntos, C_Conj, I_Conj)
    % Calcular la EC del subconjunto para saber "en qué dirección recorrer
    % el circuito". 
    if length(I_Conj) > 2
        Anillo = convhulln(C_Conj'); 
        Anillo = Anillo(:, 1)';
        I_aux = I_Conj(Anillo);
        pos_c = find(I_aux == Puntos(3), 1);
        pos_d = find(I_aux == Puntos(4), 1);
        if pos_c > pos_d % Derecha
            orden = 1;
        else % izquierda
            orden = 2;
        end
    else
        orden = 0; % 1 o 2 puntos.
    end

    % Añadir los puntos en ese orden a la solución.
    pos_a = find(I_S == Puntos(1), 1);
    pos_c = find(I_Conj == Puntos(3), 1);
    pos_d = find(I_Conj == Puntos(4), 1);

    if orden == 0
        if pos_d == pos_c % 1 punto
        I_S = [I_S(1:pos_a); I_Conj(pos_c); I_S(pos_a+1:end)];
        C_S = [C_S(:,1:pos_a) C_Conj(:,pos_c) C_S(:,pos_a+1:end)];
        else % 2 puntos
        I_S = [I_S(1:pos_a); I_Conj(pos_c); I_Conj(pos_d); I_S(pos_a+1:end)];
        C_S = [C_S(:,1:pos_a) C_Conj(:,pos_c) C_Conj(:,pos_d) C_S(:,pos_a+1:end)];
        end
       
        I_newSub = [];
        C_newSub = [];
    elseif orden == 1 % Derecha
        I_S = [I_S(1:pos_a); I_Conj(pos_c:end); I_Conj(1:pos_d); I_S(pos_a+1:end)];
        C_S = [C_S(:,1:pos_a) C_Conj(:,pos_c:end) C_Conj(:,1:pos_d) C_S(:,pos_a+1:end)];
        I_newSub = I_Conj(pos_d:pos_c);
        C_newSub = C_Conj(:, pos_d:pos_c);
    else % Izquierda
        I_S = [I_S(1:pos_a); I_Conj(pos_c:-1:1); I_Conj(end:-1:pos_d); I_S(pos_a+1:end)];
        C_S = [C_S(:,1:pos_a) C_Conj(:,pos_c:-1:1) C_Conj(:,end:-1:pos_d) C_S(:,pos_a+1:end)];
        I_newSub = I_Conj(pos_c:pos_d);
        C_newSub = C_Conj(:, pos_c:pos_d);
    end

    % Si hay puntos entre Ic-Id, entonces considerarlos subconjunto y
    % llamar a Estabilizar. De momento lo otro por testing.
    if ~isempty(I_newSub) % Hay puntos intermedios
        %[C_S, I_S] = Estabilizar(C_S, I_S, [], [], C_newSub, I_newSub, length(I_newSub));
        [C_S, I_S] = Union(C_S, I_S, C_newSub, I_newSub);
    end
end

