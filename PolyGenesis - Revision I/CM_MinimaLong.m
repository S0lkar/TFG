
% Dado un TSP y su envolvente convexa, devuelve aquel segmento de menor cantidad de
% puntos interiores.
% Distancia, Entrada, Salida
function [D, E, S] = CM_MinimaLong(TSP, EC)
    D = length(Extraer_Segmento(TSP, EC(end), EC(1))) - 2; % El segmento final
    E = EC(end); S = EC(1);
    i = 1;
    while(i < length(EC) && D > 0)
        auxD = length(Extraer_Segmento(TSP, EC(i), EC(i+1))) - 2;
        if(auxD < D)
            D = auxD;
            E = EC(i); S = EC(i+1);
        end
        i = i + 1;
    end
end

