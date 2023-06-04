
% recibe el circuito actual (tanto coordenadas como indices),
% los índices de los vértices de la arista a desocupar, 
% la envolvente convexa y
% el punto en cuestión.
% Devuelve los puntos quitados, el circuito actual y envolvente convexa
% después de añadir el punto en la arista A-B.
% las aristas nuevas generadas son [Ipta Ind_pt; Ind_pt Iptb]
function [I_des, C_des, C_CA, I_CA, C_EC, I_EC] = Expansion(C_CA, I_CA, Ipta, Iptb, Ind_pt, Coord_pt, I_EC_ant, C_EC_ant)
    pos_i = find(I_CA == Ipta, 1);
    pos_f = find(I_CA == Iptb, 1);
    I_des = [];
    C_des = [];

    % Falta actualizar CA añadiendo el punto
    if pos_i > pos_f % es que está en la ultima arista
        if pos_i < length(I_CA) % y hay puntos intermedios
            C_des = C_CA(:, pos_i+1:end);
            I_des = I_CA(pos_i+1:end);
            C_CA(:, pos_i+1:end) = [];
            I_CA(pos_i+1:end) = [];
        end
    else
        if pos_i + 1 < pos_f % si hay puntos intermedios en la arista intermedia
            C_des = C_CA(:, pos_i+1:pos_f-1);
            I_des = I_CA(pos_i+1:pos_f-1);
            C_CA(:, pos_i+1:pos_f-1) = [];
            I_CA(pos_i+1:pos_f-1) = [];
        end
    end
    C_CA = [C_CA(:, 1:pos_i) Coord_pt  C_CA(:, pos_i+1:end)]; % Añadimos el punto al circuito actual
    I_CA = [I_CA(1:pos_i) Ind_pt C_CA(pos_i+1:end)];

    % Calculamos la nueva envolvente convexa, resultado de haber añadido un
    % punto de la siguiente.
    % OPTIMIZAR; se podría hacer la envolvente con la antigua y el punto
    % nuevo, sin usar así todos los puntos interiores.
    nueva_EC = convhulln(C_CA'); nueva_EC = nueva_EC(:, 1)';
    C_EC = C_CA(:, nueva_EC);
    I_EC = I_CA(nueva_EC);
    
    [aux, pos] = setdiff(I_EC_ant, I_EC);
    I_des = [I_des aux];
    C_des = [C_des C_EC_ant(:, pos)]; % Puntos de la envolvente antigua que ahora solo estén en CA
end

