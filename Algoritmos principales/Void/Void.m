% Algoritmo para el cálculo de la ruta óptima de un set de coordenadas
% Void   -   Recibe el anillo de dominancia, la matriz de costes y los
% índices de los puntos por colocar
%
%       ruta = Void(Anillo, Puntos, mCostes)
%       mCostes: Matriz de NxN distancias entre cada par (i, j)
%       Puntos: Array de índices de los puntos por colocar.
%       Anillo: Array de índices que conforman el anillo de dominancia
%       ruta: Vector 1xN indicando en el orden que se visitan los puntos

function Anillo = Void(Anillo, Puntos, mCostes)
    
    nPuntos = uint64(length(Puntos));
    d = Inf(1, nPuntos); % Mínimo incremento en distancia
    A = zeros(1, nPuntos); % Posicion de la arista afectada
    % Por cada punto inconexo, calcular con cada par consecutivo del anillo;
    % D(Panillo1, Pi) + D(Pi, Panillo2) - D(Panillo1, Panillo2)
    % Cogemos el menor y añadimos ese punto en el aro, y vuelta a comenzar,
    % hasta que nos quedemos sin puntos que añadir.

    for j = 1:nPuntos
        Pref = Puntos(j);
        for k = 1:length(Anillo)-1
            aux = mCostes(Anillo(k), Pref) + mCostes(Pref,Anillo(k+1)) - mCostes(Anillo(k), Anillo(k+1));
            if aux < d(j)
                d(j) = aux;
                A(j) = k;
            end
        end
        aux = mCostes(Anillo(end), Pref) + mCostes(Pref,Anillo(1)) - mCostes(Anillo(end), Anillo(1));
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
        Ar = Anillo(A(win)+1);

        if A(win)+2 <= length(Anillo) % Giro al anillo
            Ar_dsp = Anillo(A(win)+2);
        else
            Ar_dsp = Anillo(1);
        end

        ref = A(win);
        for j = 1:(nPuntos - i + 1)
            if A(j) == ref %se rompió su enlace
                d(j) = inf;
            end
            aux = mCostes(Ar_ant, Puntos(j)) + mCostes(Puntos(j), Ar) - mCostes(Ar_ant, Ar);
            Act = true;
            if aux < d(j)
                d(j) = aux;
                A(j) = A(win);
                Act = false;
            end
            aux = mCostes(Ar, Puntos(j)) + mCostes(Puntos(j), Ar_dsp) - mCostes(Ar, Ar_dsp);
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
    end
end

