function [Current, i] = tabu(ini, N)
    % Current = randperm(N);
    Current = ini;
    Best = Current;
    Tabu_list = uint8(zeros(N));
    tenure = 4;
    i = 0;
    nReina = 1;
    max_iter = 80;

    % No usar iteraciones maxima, sino otra cond de parada, como no tener
    % mejores vias ya, etc.
    while(i < max_iter) && (fEval(Current) ~= 0)
        S = tabuListSuccesorStates(Best);
        Origen = Current; % Para no perder la fuente de los sucesores

        while ((length(S) > 1) & (Current == Origen))
            New = S(1, 1:N); % Toma el mas prometedor
            Perm = find((Origen ~= New) == 1); % Vemos que permutacion se hizo
            S = S(2:size(S, 1), :); % Elimina el sucesor de la lista
            
            if fEval(New) < fEval(Best)
                Current = New;
                Best = Current;
            elseif Tabu_list(Perm(1), Perm(2)) == 0
                Current = New;
            end
        end
        Tabu_list = Tabu_list - 1;
        Tabu_list(Perm(1), Perm(2)) = tenure; % Simetrico
        Tabu_list(Perm(2), Perm(1)) = tenure;

        i = i + 1;
        nReina = mod(nReina, N) + 1;
    end
end