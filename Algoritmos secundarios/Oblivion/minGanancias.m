
% Pt son las coordenadas del punto a comprobar
% Coords son las coordenadas del anillo. Es decir; C(:, A)
% D son las distancias AB devueltas en dists.
function [MIN, pos] = minGanancias(Pt, D, Coords)
    Vect_dists = d_euclid(Pt, Coords); % Distancias AC
    Vect_dists = Vect_dists + circshift(Vect_dists, 1) - D;
    [MIN, pos] = min(Vect_dists);
end

