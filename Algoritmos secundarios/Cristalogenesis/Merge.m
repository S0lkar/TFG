% Merge une dos anillos dados en uno solo, que cumple la propiedad de ser el de menor perímetro. 
% (Hay que hacerlo con el procedimiento deducido)

% Aquí las coordenadas deberían de estar a lo vertical por aligerar el
% cálculo de la ganancia.
% En realidad necesitaria los dos anillos intactos y luego el actual.
% C_EC = Coordenadas del anillo anterior 'EC'
% C_NP = Coordenadas del anillo al que nos expandimos 'NP'
% C_CA = Circuito Actual 'CA'
% I_... = Indices de...
function I_CA = Merge(C_EC, C_NP, C_CA, I_EC, I_NP, I_CA)
    % Hacer la lista de
    % I_NP | Arista Mejor | Ganancia | Colocado
    % I_NP |  Ia  |  Ib   | Ganancia | Colocado
    L = zeros(length(I_NP), 4);
    for i = 1:length(I_NP)
        [Ia, Ib, Gmin] = Mejor_Arista(C_NP(:, i), C_EC, I_EC);
        L(i, :) = [I_NP(i) Ia Ib Gmin];
    end
    L = sortrows(L, 4, 'ascend'); % Ordenamos la lista por ganancia

    % Procedimiento;
    % Unimos el punto de menor ganancia al circuito actual a través de su
    % envolvente convexa (y la actualiza). Si habían puntos en esa arista,
    % más los que puedan haber quedado dentro de la EC, se reorganizarán en
    % el circuito actual por si cambiaron de estructura.

    for i = 1:length(I_NP) % hacer un mapa y probar lo que llevo...
        pos_pt = find(I_NP == L(i, 1), 1); % como se ordenó, necesito de nuevo el índice
        pos_a = find(I_CA == L(i, 2), 1);
        pos_b = find(I_CA == L(i, 3), 1);

        [I_des, C_des, C_CA, I_CA, C_EC, I_EC] = Expansion(C_CA, I_CA, L(i, 2), L(i, 3), L(i, 1), C_NP(:, pos_pt), C_EC, I_EC);
        
        % Actualizamos la lista con las dos nuevas aristas de la EC.
        % Recemos porque siempre se rompan las aristas antiguas.
        L = ActualizarTabla(L, L(i, 2), C_CA(:, pos_a), L(i, 1), C_NP(:, pos_pt), C_EC);
        L = ActualizarTabla(L, L(i, 1), C_NP(:, pos_pt), L(i, 3), C_CA(:, pos_b), C_EC);

        if ~isempty(I_des)
            [I_CA, C_CA] = Reorganizacion(I_CA, C_CA, I_des, C_des);
        end
    end

end


