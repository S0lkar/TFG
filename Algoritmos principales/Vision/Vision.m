
function Ruta = Vision(Coordenadas, Percentil)
%Ruta = VISION()
%   Coordenadas: lista de pares (x, y) de los puntos a unir
%   Ruta: Sucesión (1,2,3,4...) de las ciudades a seguir. El número se
%   corresponde con los índices de las coordenadas dadas.

BuffCoords{1} = Coordenadas;
BuffImgs{1} = [(1:size(Coordenadas, 1));zeros(1, size(Coordenadas, 1))];
nImgs = 1;

% Mapa inicial
%figure(nImgs);
%plot(Coordenadas(:, 2), Coordenadas(:, 1), '.b');
% ------------------------- Desenfoque -------------------------
while (size(Coordenadas, 1) > 3)
    nImgs = nImgs + 1;
    [BuffImgs{nImgs}, Coordenadas] = parejas(Coordenadas, Percentil);
    BuffCoords{nImgs} = Coordenadas;

    % Como se va reduciendo el mapa
    %figure(nImgs);
    %plot(Coordenadas(:, 2), Coordenadas(:, 1), '.b');
    %pause();
end
% Formar el triángulo
Union = [1 2; 2 3; 3 1];

% --------------------------  Enfoque  -------------------------

while nImgs > 1
     Union = Avanzar(Union, BuffImgs{nImgs}, BuffCoords{nImgs-1});
    % Para ir viendo los cambios
     %plot(BuffCoords{nImgs-1}(:, 2), BuffCoords{nImgs-1}(:, 1), '*b'); hold on;
     %Coords = BuffCoords{nImgs-1}(Union(:, 1), :);
     %plot(Coords(:, 2), Coords(:, 1), 'b'); hold off;
     %pause();
    nImgs = nImgs - 1;
end

% Solución
Ruta = Union(:, 1);
end
