% Algoritmo para el cálculo de la ruta óptima de un set de coordenadas
% Void   -   Recibe el anillo de dominancia, la matriz de costes y los
% índices de los puntos por colocar
%
%       ruta = Void(Anillo, Puntos, mCostes)
%       mCostes: Matriz de NxN distancias entre cada par (i, j)
%       Puntos: Array de índices de los puntos por colocar.
%       Anillo: Array de índices que conforman el anillo de dominancia
%       ruta: Vector 1xN indicando en el orden que se visitan los puntos
%
% Light de que no usa la matriz de costes sino las coordenadas C. Se puede
% optimizar más.
function Anillo = LightVoid(Anillo, Puntos, C)
    
    nPuntos = uint64(length(Puntos));
    d = Inf(1, nPuntos); % Mínimo incremento en distancia
    A = zeros(1, nPuntos); % Posicion de la arista afectada
    % Por cada punto inconexo, calcular con cada par consecutivo del anillo;
    % D(Panillo1, Pi) + D(Pi, Panillo2) - D(Panillo1, Panillo2)
    % Cogemos el menor y añadimos ese punto en el aro, y vuelta a comenzar,
    % hasta que nos quedemos sin puntos que añadir.

    AnCoord = C(:, Anillo);
    for j = 1:nPuntos
        Pref = C(:, Puntos(j));
        for k = 1:length(Anillo)-1
            aux = norm(AnCoord(:,k) - Pref) + norm(Pref - AnCoord(:,k+1)) - norm(AnCoord(:,k)- AnCoord(:,k+1));
            if aux < d(j)
                d(j) = aux;
                A(j) = k;
            end
        end
        aux = norm(AnCoord(:,end) - Pref) + norm(Pref - AnCoord(:,1)) - norm(AnCoord(:,end)-AnCoord(:,1));
        if aux < d(j)
                d(j) = aux;
                A(j) = length(Anillo);
        end
    end

    for i = 1:nPuntos
        % --- Calculo la mejor arista a unirse de cada punto---

        % Habría que usar solo la nueva arista generada, no todas de nuevo
        % Puedo hacer una matriz de distancias a cada arista, y coger la
        % minima (deduciendo así cual es la A. No creo que sea muy util
        % porque entonces ya es indirectamente dependiente a mCostes. Mucha
        % memoria.
        
        % ------------------------

        [~, win] = min(d); % Cogemos el punto que provoca menos pérdida
        if A(win) < length(Anillo) % Y lo insertamos donde corresponde
            Anillo = [Anillo(1:A(win)) Puntos(win) Anillo(A(win)+1:end)];
        else
            Anillo = [Anillo Puntos(win)];
        end

        % ----------------------
        Ar_ant = Anillo(A(win));
        Ar_ant_c = C(:,Ar_ant);

        Ar = Anillo(A(win)+1);
        Ar_c = C(:,Ar);

        if A(win)+2 <= length(Anillo) % Giro al anillo
            Ar_dsp = Anillo(A(win)+2);
        else
            Ar_dsp = Anillo(1);
        end
        Ar_dsp_c = C(:,Ar_dsp);


        ref = A(win);
        AnCoord = C(:, Puntos);
        for j = 1:(nPuntos - i + 1)
            if A(j) == ref %se rompió su enlace
                d(j) = inf;
            end
            aux = norm(Ar_ant_c - AnCoord(:,j)) + norm(AnCoord(:,j) - Ar_c) - norm(Ar_ant_c - Ar_c);
            Act = true;
            if aux < d(j)
                d(j) = aux;
                A(j) = A(win);
                Act = false;
            end
            aux = norm(Ar_c - AnCoord(:,j)) + norm(AnCoord(:,j) - Ar_dsp_c) - norm(Ar_c - Ar_dsp_c);
            if aux < d(j)
                d(j) = aux;
                A(j) = A(win)+1;
                Act = false;
            end
            if Act && A(j) > ref % Actualizar la localización del enlace
                A(j) = A(j) + 1;
            end
        end


        % Actualizo la lista de puntos
        Puntos(win) = [];
        d(win) = [];
        A(win) = [];
        %plot(C(1,:), C(2,:), '.r'); hold on; axis equal;
        %plot(C(1,Anillo), C(2,Anillo), 'b'); plot([C(1,Anillo(end)) C(1,Anillo(1))], [C(2,end) C(2,1)], 'b'); hold off;
        %pause();
    end
end

