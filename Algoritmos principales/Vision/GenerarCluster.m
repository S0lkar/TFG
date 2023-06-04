load mCostes
C = mCostes;
nCiudades = length(mCostes);

% ------------- Hay que ver cómo calcular estos parámetros
minDist = 7.5;
Proporcion = 1.1;
% -------------

% ~~~~~~~~~ Creación de Clusters ~~~~~~~~~ Aparentemente, bien
for i = 1:nCiudades
    for j = 1:nCiudades
        if(C(i, j) > minDist) % Distancia mínima
            C(i,j) = 0;
        end
    end
end

Aux = C;
CsC = 1:nCiudades; % Ciudades sin Colocar
counter = 1;
Cluster = {};
% Las ciudades muy alejadas forman sus propios clusters/islas
for i = 1:nCiudades
    if isempty(find(C(i, :) ~= 0))
        Cluster{counter} = [i];
        counter = counter + 1;
        CsC(find(CsC == i)) = []; % Contamos que fue colocada
    end
end
Islas_grandes = counter;

% Las ciudades cercanas forman los clusters/islas juntas
Lista = [];
while ~isempty(CsC)
    Lista = find(Aux(CsC(1), :) ~= 0); % lista de indices conectados
    Aux(CsC(1), :) = 0; % Eliminamos ese indice
    Aux(:, CsC(1)) = 0;
    Cluster{counter} = [CsC(1)]; % Lo insertamos en su isla
    CsC(1) = []; %eliminado

    while ~isempty(Lista)
        Cluster{counter} = [Cluster{counter} Lista(1)]; % registramos el siguiente
        Lista = [Lista find(Aux(Lista(1), :) ~= 0)]; % ampliamos las conexiones si las hay
        Aux(Lista(1), :) = 0; % Eliminamos ese indice
        Aux(:, Lista(1)) = 0;
        CsC(find(CsC == Lista(1))) = []; % Eliminamos la ciudad de las llevamos colocadas
        Lista(1) = [];                   % Lo eliminamos de la lista
    end
    Cluster{counter} = unique(Cluster{counter}); % Eliminar ciclos
    counter = counter + 1;
end

% ~~~~~~~~~ Disolución de Clusters ~~~~~~~~~
% Es mejor hacer una disolución mas estricta parece.
N = length(Cluster);
i = 1;
while i < N
    if length(Cluster{i}) > 2
        Parejas = nchoosek(Cluster{i}, 2);
        dist = zeros(size(Parejas, 1), 1);
        for j = 1:size(Parejas, 1)
            dist(j) = mCostes(Parejas(j, 1), Parejas(j, 2));
        end
        dist_min = min(dist); % Distancia mas pequeña entre las ciudades de la isla

        Nucleos = Parejas(find(dist <= dist_min * Proporcion), :);
        Busq = Nucleos(1, :);
        Mantiene = Nucleos(1, :);
        Nucleos(1, :) = [];

        while ~isempty(Busq)
            aux = mod(find(Nucleos == Busq(1)), size(Nucleos,1)) + 1; % Tengo las filas
            if isempty(find(Mantiene == Busq(1))) % Incluimos en la lista de ciudades conectadas
                Mantiene = [Mantiene Busq(1)];
            end
            Busq(1) = []; % Elimino "la ciudad expandida"
            if ~isempty(aux)
                for j = 1:length(aux)
                    Busq = [Busq Nucleos(aux(j), :)];
                end
            end
            Nucleos(aux, :) = [];
        end
        Ciudades_total = Cluster{i};
        Mover = ismember(Ciudades_total, Mantiene);
        Cluster{i} = Mantiene; % en la isla iesima se quedan las ciudades mantenidas
        Cluster{N+1} = Ciudades_total(Mover == 0); % el resto se mueve a la última isla.
        N = N + 1;
    end
    i = i + 1;
end


% ~~~~~~~~~ Cell => Matriz ~~~~~~~~~
max_tamano = 0;
i = 1;
while i <= N
    if isempty(Cluster{i})
        Cluster(i) = [];
        i = i - 1; N = N - 1;
    else
        max_tamano = max([length(Cluster{i}) max_tamano]);
    end
    i = i + 1;
end

Islas = [];
for i = 1:max_tamano
    for j = 1:N
        if i <= length(Cluster{j})
            Islas(i, j) = Cluster{j}(i);
        else
            Islas(i, j) = 0;
        end
    end
end

save('Islas.mat','Islas');