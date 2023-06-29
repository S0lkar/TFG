
% Se me ocurre hacer algo provisional aunque sea ineficiente, total...
function [C_S, I_S] = RedGlobal2(C_S, I_S, I_Act, C_Act)
    % Versión patata
    Minimalidad_global = false;
    while ~Minimalidad_global
        Minimalidad_global = true;
        i = 1;
        while Minimalidad_global && i <= length(I_Act)
            Iaux = I_S; Caux = C_S;
            pos = find(Iaux == I_Act(i), 1);
            Iaux(pos) = []; Caux(:, pos) = [];
            %G = Ganancia(C_S(:, mod(pos-2, length(I_S))+1), C_S(:, pos), C_S(:, mod(pos, length(I_S))+1));
            [Ia, ~, Gmin] = MinimaGanancia(C_S(:, pos), Caux, Iaux, true);

            if Ia ~= I_S(mod(pos-2, length(I_S))+1) % Ha encontrado una mejor arista
            %if Gmin < G
                pos = find(Iaux == Ia, 1);
                I_S = [Iaux(1:pos); I_Act(i); Iaux(pos+1:end)];
                C_S = [Caux(:, 1:pos) C_Act(:, i) Caux(:, pos+1:end)];
                Minimalidad_global = false;
            else
                i = i + 1;
            end
        end
    end
end