
% Función auxiliar para TSP_to_CM. Dados el alfa y beta límite, la
% envolvente convexa y los puntos de E/S devuelve el sentido en el que hay
% que recorrer el TSP (E+alfa y S+beta  ó  E+beta y S+alfa) y los alfa y
% beta reales (el segmento 'a romper' para hacer la unión). También si
% existen puntos interiores en dicho segmento o no.

function [Sentido, alfa, beta, PI] = Enlazar(Coordenadas, TSP, EC, alfa, beta, E, S)

    if alfa == beta % Moverlos para que ocupen los 2 segmentos vecinos
        if alfa == 1
            alfa = length(EC);
            beta = 2;
        elseif alfa == length(EC)
            alfa = alfa - 1;
            beta = 1;
        else
            alfa = alfa - 1;
            beta = beta + 1;
        end       
    end

    % Por cada segmento entre alfa y beta, comprobar su unión con E y S.
    % Guardar la de menor ganancia. Y devolver el sentido y si contiene
    % puntos interiores o no...De hecho podría devolver el CM ya hecho y
    % todo porque para qué recalcular.

end

