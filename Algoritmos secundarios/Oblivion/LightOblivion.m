% Algoritmo para el cálculo de la ruta óptima de un set de coordenadas
% Oblivion   -   Recibe el envolvente convexa, la matriz de costes y los
% índices de los puntos por colocar
%
%       ruta = LightOblivion(Anillo, Puntos, C)
%       C: Coordenadas de todos los puntos
%       Puntos: Array de índices de los puntos por colocar.
%       Anillo: Array de índices que conforman la envolvente convexa
%       ruta: Vector 1xN indicando en el orden que se visitan los puntos
%
function Anillo = LightOblivion(Anillo, Puntos, C)
    
    nPuntos = uint64(length(Puntos));
    Ganancia = Inf(nPuntos, 1); % Mínimo incremento en distancia
    Act = true; % Se actualizó el anillo

    while(Act)
        Act = false;
        %D = dists(C, Anillo); % distancias del anillo actual
        indice = 1; % Vamos comprobando los puntos por si mejoraron

        while(indice <= nPuntos && ~Act)
            AnilloAux = Anillo;
            pos = find(Anillo == Puntos(indice), 1);
            AnilloAux(pos) = []; % El anillo sin ese punto.
            %Daux = D;
            %Daux(pos) = [];

            %[MIN, pos] = minGanancias(C(:, Puntos(indice)), Daux, C(:, AnilloAux));
            [MIN, pos] = minGnoOPT(C(:, Puntos(indice)), C(:, AnilloAux));

            if(MIN < Ganancia(indice))
                Ganancia(indice) = MIN;
                Anillo = [AnilloAux(1:pos) Puntos(indice) AnilloAux((pos+1):end)];
                Act = true;
            end
            indice = indice + 1;
        end

        plot(C(1, :), C(2, :), '.b'); hold on;
        plot(C(1, Anillo), C(2, Anillo), 'b'); 
        plot(C(1, Anillo([1 end])), C(2, Anillo([1 end])), 'b');hold off;
        pause();
    end

end

