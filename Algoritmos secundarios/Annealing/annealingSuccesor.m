function [S, C] = annealingSuccesor(A, Inicio, mCostes)
    N = length(A);
    S = zeros(1, N, 'uint16');

    Fin = randi(N);
    % no tomar como segmento toda la asignacion
    while (Inicio == 1 && Fin == N) || (Inicio == N && Fin == 1)
        Fin = randi(N);
    end

    if Inicio > Fin % para que inicio esté antes de fin siempre
        aux = Inicio;
        Inicio = Fin;
        Fin = aux;
    end

    if rand(1) > 0.5 % Transporte
            
            Resto = [A(1:Inicio-1) A(Fin+1:end)]; % resto de la ruta
            Destino = randi(length(Resto)); % Elegimos el sitio de destino
            S = [Resto(1:Destino) A(Inicio:Fin) Resto(Destino+1:end)];

    else % Inversion
        if Inicio ~= 1
            S(1:Inicio-1) = A(1:Inicio-1);
        end
        S(Inicio:Fin) = flip(A(Inicio:Fin));
        if Fin ~= N
            S(Fin+1:end) = A(Fin+1:end);
        end
    end
    
    C = fcost(S, mCostes);
    S = S(1:length(A)); % Solamente por MEX, para que 'sepa' el tamaño.
end