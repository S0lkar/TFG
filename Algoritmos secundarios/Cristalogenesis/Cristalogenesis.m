
% 'función main'
% Las coordenadas tienen que estar en horizontal.
% Devuelve en orden los índices del circuito.
function Anillo_opt = Cristalogenesis(Coordenadas)
    
    % Primera fase - División por capas
    [Indices, Len, N] = Halos_Opt(Coordenadas, (1:length(Coordenadas))');

    % Setup para la segunda fase
    Anillo_opt = Obtener_Halo(Indices, Len, N);
    Anillo_sig = Obtener_Halo(Indices, Len, N-1);
    Coordenadas = Coordenadas';

    % Al principio hay una reorganizacion, de los puntos sueltos interiores
    % a la capa mas interna
    if Len(end) < 3
        Anillo_opt = Reorganizacion(Anillo_sig, Coordenadas(:, Anillo_sig), Anillo_opt, Coordenadas(:, Anillo_opt));
    end
    % Segunda fase - Unión de las capas
    for i = N-1:-1:2
        Anillo_ant = Anillo_sig;
        Anillo_sig = Obtener_Halo(Indices, Len, i-1);

        % A lo mejor se puede reutilizar cosas de la funcion como inputs y
        % así no tener que hacer más accesos
        Anillo_opt = Merge(Coordenadas(:, Anillo_ant), Coordenadas(:, Anillo_sig), Coordenadas(:, Anillo_opt), Anillo_ant, Anillo_sig, Anillo_opt);
        Representacion(Coordenadas, Anillo_opt);
    end
end

%load eil51MAP;
%Coordenadas = eil51MAP;

%mi solución puede servir para el ciclo hamiltoniano - estoy intentando conseguir el circuito
%de menor longitud. Las aristas que "no existen" tienen coste infinito. Luego, si la solución
%que encuentra es de coste infinito, es que no hay un ciclo.