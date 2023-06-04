function Best = Annealing(max_iter, T, T_min, Current, mCostes)

    I = 0;
    Best = Current;
    Current_cost = fcost(Current, mCostes);
    Best_cost = Current_cost;
    New = zeros(size(Current), 'uint16');
    New_aux = zeros(size(Current), 'uint16');

    while (T > T_min) && (I < max_iter)
        % -------------- Genera nuevo recorrido --------------
        intentos = 0;
        New_cost = inf;
        while intentos < 50
            [New_aux, New_cost_aux] = annealingSuccesor(Current, mod(I, length(Current)) + 1, mCostes);
            if New_cost_aux < New_cost
                New = New_aux;
                New_cost = New_cost_aux;
                intentos = 0;
            else
                intentos = intentos + 1;
            end
        end

        % -------------- Toma de Decisión --------------

        E = New_cost - Current_cost;
        if(E < 0)
            Current = New;
            Current_cost = New_cost;
            if(New_cost < Best_cost)
                Best = New;
                Best_cost = New_cost;
                I = 0;
            end
        else
            p = exp(-E/T);
            if(p > rand(0, 1))
                Current = New;
                Current_cost = New_cost;
            end
        end

        % -------------- Actualización --------------
        T = 0.9 * T; % cool(T)
        I = I + 1;
    end
end
