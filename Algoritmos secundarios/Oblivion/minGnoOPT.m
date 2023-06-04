
% Pt son las coordenadas del punto a comprobar
% Coords son las coordenadas del anillo. Es decir; C(:, A)
% Es poco eficiente.
function [MIN, pos] = minGnoOPT(Pt, Coords)

    D = zeros(1, length(Coords));
    for i = 1:length(Coords)-1
        D(i) = norm(Coords(:, i) - Pt) + norm(Pt - Coords(:, i+1)) - norm(Coords(:, i) - Coords(:, i+1));
    end

    D(i+1) = norm(Coords(:, end) - Pt) + norm(Pt - Coords(:, 1)) - norm(Coords(:, end) - Coords(:, 1));

    [MIN, pos] = min(D);
end

