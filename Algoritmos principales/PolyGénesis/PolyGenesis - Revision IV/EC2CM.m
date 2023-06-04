
% La función recibe una EC, y, dados un punto de entrada y salida
% (contiguos), devuelve el CM equivalente de la EC (es decir, en la primera
% posición el punto de entrada y en el último el de salida).

function CM = EC2CM(EC, E, S)
    EC(end) = []; % (Por el formato de output de convexHull)
    Ie = find(EC == E, 1);
    Is = find(EC == S, 1);

    if (Ie == 1) && (Is == length(EC))
        CM = EC;
    elseif (Is == 1) && (Ie == length(EC))
        CM = flip(EC);
    elseif (Ie < Is)
        CM = [EC(Ie:-1:1); EC(end:-1:Is)];
    else
        CM = [EC(Ie:end); EC(1:Is)];
    end
end

