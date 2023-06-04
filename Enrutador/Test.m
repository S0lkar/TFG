
% Coordenadas de ejemplo (29 puntos)
load Coordenadas

% Pueden estar en columna o en fila, la funcion luego los ordena bien
coords_X = Coordenadas(:, 1);
coords_Y = Coordenadas(:, 2)'; 

% La velocidad del ROV, la corriente en el eje X e Y. Con tal de que estén
% en la misma unidad sirve para que haga bien la aproximación
vel_ROV = 1; flow_x = 1; flow_y = 1;

% Devuelve una fila con los indices de las coordenadas en orden (está en
% uint64 para que vaya más rapido con los cálculos, si quieres que esté con
% el mismo formato que lo demás, double, la llamada sería como está
% comentada en la línea 18)
%Orden = Enrutar(coords_X, coords_Y, vel_ROV, flow_x, flow_y);
 Orden = double(Enrutar(coords_X, coords_Y, vel_ROV, flow_x, flow_y));
 