
% Wrapper para ser llamado desde Python. Devuelve un vector
% con la ruta a seguir

% coordenadas en metros
% vel_ROV en m/s
% flow en m/s
function Orden = Boceto(coords_X, coords_Y, vel_ROV, flow_x, flow_y)

    % Coordenadas originales y sus distancias a (0, 0).
    C = [coords_X(:) coords_Y(:)]';
    d = zeros(1, length(C));
    for i = 1:length(C)
        d(i) = dist_euclid([0; 0], C(i, :));
    end
    % v = d/t -> t = d/v
    t = d ./ vel_ROV;

    % Aplicamos la distorsión en cada eje.
    % v = d/t -> d = v*t
    for i = 1:length(C) 
        C(i, :) = [C(i, 1) * (flow_x * t(i)); C(i, 2) * (flow_y * t(i))];
    end

    % Llamada a la función que calcule la ruta del "mapa real"
    Orden = [1:length(C)]; % Orden = fn(C);

end