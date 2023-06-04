% Algoritmo para aplicar la tensión superficial en una figura.
% TnsSup   -   Recibe la envolvente convexa, la matriz de costes y la ruta
% actual
%
%       ruta = TnsSup(ruta, Env, mCostes)
%       mCostes: Matriz de NxN distancias entre cada par (i, j)
%       Puntos: Array de índices de los puntos por colocar.
%       Anillo: Array de índices que conforman el anillo de dominancia
%       ruta: Vector 1xN indicando en el orden que se visitan los puntos
%
function ruta = LightTnsSup(ruta, Env, C)

    for i = 1:length(Env)-1 % Probamos a romper la ruta por cada punto de tensión
        indA = find(ruta == Env(i), 1);
        indB = find(ruta == Env(i+1), 1);

        Puntos = ruta(indA+1:indB-1);
        if indA == 1
            RutaAux = [ruta(1) ruta(indB:end)];

        elseif indB == length(ruta)
            RutaAux = [ruta(1:indA) ruta(end)];
        else
            RutaAux = [ruta(1:indA) ruta(indB:end)];
        end
        ruta = LightVoid_mex(RutaAux, Puntos, C);
    end
    % Optimizable
        indA = find(ruta == Env(1), 1);
        indB = find(ruta == Env(end), 1);
        if indA ~= 1 && indB ~= length(ruta)
            Puntos = [ruta(1:indA-1) ruta(indB+1:end)];
        elseif indA == 1 && indB ~= length(ruta)
            Puntos = [ruta(indB+1:end)];
        elseif indA ~= 1 && indB == length(ruta)
            Puntos = [ruta(1:indA-1)];
        elseif indA == 1 && indB == length(ruta)
            Puntos = [];
        end

        RutaAux = [ruta(indA:indB)];
        if ~isempty(Puntos)
            ruta = LightVoid_mex(RutaAux, Puntos, C);
        end
end

