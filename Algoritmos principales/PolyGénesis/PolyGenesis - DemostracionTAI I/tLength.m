% Función para el cálculo del coste de un segmento.
% tLength   -   Recibe una ruta y las coordenadas, y devuelve el coste
% asociado al circuito.
%
%       Total = fcost(ruta, Coordenadas)
%       C: coordenadas (X; Y) de los puntos.
%       ruta: Vector 1xN indicando en el orden que se visitan los puntos
%       Total: Distancia total recorrida
%
function Total = tLength(ruta, C)
    Aux = C(:, ruta);
    Total = norm(Aux(:,end) - Aux(:,1));
    for i = 1:length(ruta)-1
        Total = Total + norm(Aux(:,i) - Aux(:,i+1));
    end
end