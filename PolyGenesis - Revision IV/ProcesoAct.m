
% Proceso de comprobación del traspaso de puntos interiores de un segmento
% a otro.
function [Anew, Bnew, D_A, D_B, hay_act] = ProcesoAct(C, Seg_A, Seg_B, D_A, D_B)
    Anew = Seg_A;
    Bnew = Seg_B;
    hay_act = false;


    % Ordenar los puntos interiores de A y B por minima ganancia
    Ea = Seg_A(1); Sa = Seg_A(end); Eb = Seg_B(1); Sb = Seg_B(end);
    orden_A = zeros(length(Seg_A) - 2, 1); orden_B = zeros(length(Seg_B) - 2, 1);
    for i = 1:length(orden_A)
        orden_A(i) = norm(C(:, Eb) - C(:, Seg_A(i+1))) + norm(C(:, Sb) - C(:, Seg_A(i+1)));
    end
    for i = 1:length(orden_B)
        orden_B(i) = norm(C(:, Ea) - C(:, Seg_B(i+1))) + norm(C(:, Sa) - C(:, Seg_B(i+1)));
    end
    Aact = Seg_A(2:end-1);
    [~, orden_A] = sort(orden_A); orden_A = Aact(orden_A); % indices de A en orden a B.
    Bact = Seg_B(2:end-1);
    [~, orden_B] = sort(orden_B); orden_B = Bact(orden_B); % indices de B en orden a A.


    % Comprobación del set a trasladar que otorgue la mayor reducción de la
    % ganancia
    D_best = D_A + D_B;
    resA = Seg_A;
    resB = Seg_B;

    % A -> B
    for i = 1:length(orden_A)

        % Incluir en B el primer punto de orden_A y quitarlo de la lista
        resB = [resB(1); orden_A(1); resB(2:end)];
        resA(find(resA == orden_A(1), 1)) = [];
        orden_A(1) = [];


        % PolyGenesis a A y B, calcular sus distancias
        if length(resA) > 3
            resA = resA(PolyGenesis(C(:, resA), [1 length(resA)]));
        end
        resB = resB(PolyGenesis(C(:, resB), [1 length(resB)]));


        % Si la distancia mejora a la actual, guardar el estado actual de A
        % y B.
        Dist_A = tLength(resA, C); Dist_B = tLength(resB, C);

        if(Dist_A + Dist_B < D_best)
            Anew = resA;
            Bnew = resB;
            D_A = Dist_A; D_B = Dist_B; D_best = D_A + D_B;
            hay_act = true;
        end
    end


    % B -> A
    resA = Seg_A;
    resB = Seg_B;
    
    for i = 1:length(orden_B)
        % Incluir en B el primer punto de orden_B y quitarlo de la lista
        resA = [resA(1); orden_B(1); resA(2:end)];
        resB(find(resB == orden_B(1), 1)) = [];
        orden_B(1) = [];


        % PolyGenesis a A y B, calcular sus distancias
        resA = resA(PolyGenesis(C(:, resA), [1 length(resA)]));
        if length(resB) > 3
            resB = resB(PolyGenesis(C(:, resB), [1 length(resB)]));
        end


        % Si la distancia mejora a la actual, guardar el estado actual de A
        % y B.
        Dist_A = tLength(resA, C); Dist_B = tLength(resB, C);

        if(Dist_A + Dist_B < D_best)
            Anew = resA;
            Bnew = resB;
            D_A = Dist_A; D_B = Dist_B; D_best = D_A + D_B;
            hay_act = true;
        end
    end
end

