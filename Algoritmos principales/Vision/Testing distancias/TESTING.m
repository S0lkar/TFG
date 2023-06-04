

%load Islas % Voy a probar con la primera de 2 ciudades. La 21.
load CoordTest
%load mCostes
mCostes = Crear_mCostes(CoordTest);

%a = Islas(:, 21);
%a = a(a > 0); % Nos quedamos con las ciudades, quitamos los espacios
a = [2 3]; % Voy a unir los puntos centrales

%% Metodo 1: haciendo la media de las coordenadas
% CORRECTO.
coords = mean([CoordTest(a(1), :); CoordTest(a(2), :)]);
CoordTest(a, :) = []; % Son las islas que he juntado
CoordTest(size(CoordTest, 1) + 1, :) = coords;
Metodo1 = Crear_mCostes(CoordTest);


%% Metodo 2: haciendo la media de los costes
% No sirve en este caso, necesito información sobre la estructura para poder calcular
% bien las distancias a la media. Como antes con las coordenadas, pues
% necesito algo que ayude a construirlo. Podría usar tambien el máximo,
% para el caso de interrupciones en ancho de banda, etc...
Filas = [];
for i = 1:length(a)
    Filas = [Filas; mCostes(a(i), :)];
end
Filas = mean(Filas);
Filas(a) = [];

mCostes(a, :) = [];
mCostes(:, a) = [];
mCostes = [mCostes Filas']; % Añadimos el nodo nuevo al final
Metodo2 = [mCostes; Filas 0];
