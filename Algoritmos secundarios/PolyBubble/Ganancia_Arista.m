
% Calcula la ganancia de perímetro del polígono al incluir un conjunto de puntos interiores
% por su arista AB en la arista CD del polígono.
% Importante que las coordenadas estén en vertical para no hacer traspuestas
function [G, flip] = Ganancia_Arista(Ca, Cb, Cc, Cd)
    G = -norm(Ca - Cb) - norm(Cc - Cd);
    d1 = norm(Ca - Cc) + norm(Cb - Cd);
    d2 = norm(Ca - Cd) + norm(Cb - Cc);
    if d1 < d2
        G = G + d1;
        %disposicion = [a b c d];
        flip = false;
    else
        G = G + d2;
        %disposicion = [a b d c];
        flip = true;
    end
    % (D(a, c) + D(b, d)) - (D(a, b) + D(c, d))
    % (D(a, d) + D(b, c)) - (D(a, b) + D(c, d))
    %  D(Aristas_nuevas) - D(Aristas_antiguas) 
end

