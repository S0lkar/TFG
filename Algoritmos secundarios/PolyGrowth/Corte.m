
% Corte - Dado el recorrido entre dos puntos, devuelve el sitio donde insertar el
% nuevo. 
%       Insert = Corte(C, Fragmento, Punto)
%       C: Coordenadas de los puntos en parejas (X, Y)
%       Fragmento: Antigua ruta seguida
%       Punto: Nuevo punto a introducir en el recorrido

function Insert = Corte(C, Fragmento, Punto)
    
    d = zeros(length(Fragmento)-1, 1);
    Dists = zeros(length(Fragmento)-1, 1);
    C = C';
    for i = 1:length(Fragmento)-1
        Dists(i) = d_euclid(C(:, Fragmento(i)), C(:, Fragmento(i+1)));
    end
    for i = 1:length(Fragmento)-1
        d(i) = d_euclid(C(:,Fragmento(i)), C(:,Punto)) + d_euclid(C(:, Fragmento(i+1)), C(:,Punto)) + sum(Dists) - Dists(i);
    end
    [~, Insert] = min(d);
end

