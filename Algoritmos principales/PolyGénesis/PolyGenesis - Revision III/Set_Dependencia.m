
% Coordenadas -> Coordenadas de todos los puntos
% EC -> Índices de los puntos de la EC del punto a calcular su set de
% dependencia
% Ipt -> Índice del punto a calcular su set de dependencia
% Eb/Sb -> Índices de los puntos de entrada/salida del camino B al que se unen.

% Ahora mismo me da el set de dependencia como algo binario {0,1,0...}, lo
% que puedo transformar en una matriz booleana
function [Set_D, N] = Set_Dependencia(Coordenadas, EC, Ipt, Eb, Sb)

    % Con tal de ver que puntos caen en el triangulo Eb-Ipt-Sb ya tengo el
    % set de dependencia.
    %isinterior(polyshape(Triangle), Points);
    Set_D = isinterior(polyshape(Coordenadas(:, [Eb Ipt Sb])'), Coordenadas(:, EC)');
end

