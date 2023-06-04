
% La función recibe el TSP, y, dados un punto de entrada y salida
% (contiguos), devuelve el CM equivalente del TSP (es decir, en la primera
% posición el punto de entrada y en el último el de salida).
function CM = Convertir_TSP_a_CM(TSP, E, S)
    Ie = find(TSP == E, 1);
    Is = find(TSP == S, 1);

    if (Ie == 1 && Is == length(TSP))
        CM = TSP;
    elseif (Is == 1 && Ie == length(TSP))
        CM = flip(TSP);
    elseif(Ie < Is)
        CM = [TSP(Ie:-1:1); TSP(end:-1:Is)];
    else
        CM = [TSP(Ie:end); TSP(1:Is)];
    end
end

