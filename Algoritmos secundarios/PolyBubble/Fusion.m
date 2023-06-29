

% Coords está solo para hacer el plot
function I_S = Fusion(C_ant, C_sig, C_S, I_ant, I_sig, I_S, COORDS)
    % Lista;
    % I_sig | Ganancia Minima
    L = zeros(length(I_sig), 2);
    for i = 1:length(I_sig)
        [~, ~, Gmin] = MinimaGanancia(C_sig(:, i), C_ant, I_ant, true);
        L(i, :) = [I_sig(i) Gmin];
    end
    L = sortrows(L, 2, 'ascend'); % Ordenamos la lista por ganancia

    % Inclusión de los puntos siguientes, en orden.
    for i = 1:length(I_sig)
        pos = find(I_sig == L(1, 1), 1);
        [C_S, I_S, C_ant, I_ant, C_PI, I_PI, C_Sub, I_Sub, Len] = Fragmentacion2(C_S, I_S, C_ant, I_ant, I_sig(pos), C_sig(:, pos));
    
        % Actualizar tabla de sig con las dos nuevas aristas
        L(1, :) = [];
        Cb = C_sig(:, pos); % punto situado
        pos = find(I_ant == I_sig(pos));
        Ca = C_ant(:,mod(pos-2, length(I_ant))+1); % punto anterior
        Cc = C_ant(:, mod(pos, length(I_ant))+1); % punto posterior

        L = ActualizarTabla_Fusion(L, Ca, Cb, C_sig, I_sig); % tabla actualizada
        L = ActualizarTabla_Fusion(L, Cb, Cc, C_sig, I_sig);

        if ~isempty(I_PI) || ~isempty(Len)
            [C_S, I_S] = Estabilizar(C_S, I_S, C_PI, I_PI, C_Sub, I_Sub, Len);
        end
        % -------------------------------------------------------------
        plot(COORDS(1, :), COORDS(2, :), '.b'); hold on;
        Representacion(C_ant, 1:length(I_ant)); hold off;
        Representacion(COORDS, I_S);
        pause();

    end
end