
% Recibe un TSP y los puntos de entrada-salida del sub-camino mínimo a
% extraer.
function CM = Extraer_Segmento(TSP, E, S)
    Ie = find(TSP == E, 1);
    Is = find(TSP == S, 1);

    if(Ie < Is) % El segmento "no está en el fin del vector"
        CM = TSP(Ie:Is);
    else
        CM = [TSP(Ie:end) TSP(1:Is)];
    end
end

