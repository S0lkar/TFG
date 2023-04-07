% Algoritmo para el cálculo del coste de una ruta.
% fcost   -   Recibe una ruta y las coordenadas, y devuelve el coste
% asociado al circuito.
%
%       Total = CosteCM(ruta, Coordenadas)
%       C: coordenadas (X; Y) de los puntos.
%       ruta: Vector 1xN indicando en el orden que se visitan los puntos
%       Total: Distancia total recorrida
%
function Total = CosteCM(ruta, C)
    Aux = C(:, ruta); % Ordena los puntos según la ruta para evitar 'triples accesos' vectoriales
    Total = 0;
    for i = 1:length(ruta)-1
        Total = Total + norm(Aux(:, i) - Aux(:, i+1));
    end
end
