% En las notas se llama 'Enlace'
%   UDes: uniones despues del enfoque -> Despues
%   UComp: uniones antes del enfoque -> Antes
%   ImgDes: Conjuntos despues del enfoque -> Despues
%   CoordsDes: Coordenadas después del enfoque -> Despues
function UDes = Avanzar(UComp, ImgDes, CoordsDes)
    %% Declaraciones de variables
    d1 = zeros(4, 1);
    d2 = zeros(4, 1);
    desempate = true;

    % Paso 1.- Hacer el procedimiento del paso 2, aplicado a la primera
    % transición entre conjuntos para determinar el primer "punto fijo".

    aux = ImgDes(:, UComp(1, :)); % Union con entrada
    if aux(2, 1) == 0 % en el caso de que haya 1 ciudad en un conjunto
        aux(2, 1) = aux(1,1);
    end
    if aux(2, 2) == 0
        aux(2, 2) = aux(1,2); desempate = false; % solo 1 isla en el puente
    end
    pE = CoordsDes(aux(:, 1), :); % Coordenadas de la entrada
    pP = CoordsDes(aux(:, 2), :); % "" del puente (segundo par)
    d1(1) = norm(pE(1, 1:end)' - pP(2, 1:end)');
    d1(2) = norm(pE(1, 1:end)' - pP(1, 1:end)');
    d1(3) = norm(pE(2, 1:end)' - pP(2, 1:end)');
    d1(4) = norm(pE(2, 1:end)' - pP(1, 1:end)');
    [Min1, ganador1] = min(d1); punto1 = [aux(mod(ganador1, 2) + 1, 1) aux(1 + (ganador1 > 2), 2)];


    aux = ImgDes(:, UComp(2, :)); % Union con salida
    if aux(2, 1) == 0 % en el caso de que haya 1 ciudad en un conjunto
        aux(2, 1) = aux(1,1);
    end
    if aux(2, 2) == 0
        aux(2, 2) = aux(1,2);
    end
    pS = CoordsDes(aux(:, 2), :); % Coordenadas de la salida (2º par)
    d2(1) = norm(pS(1, 1:end)' - pP(2, 1:end)');
    d2(2) = norm(pS(1, 1:end)' - pP(1, 1:end)');
    d2(3) = norm(pS(2, 1:end)' - pP(2, 1:end)');
    d2(4) = norm(pS(2, 1:end)' - pP(1, 1:end)');
    [Min2, ganador2] = min(d2); punto2 = [aux(mod(ganador2, 2) + 1, 1) aux(1 + (ganador2 > 2), 2)];

    if punto1(2) == punto2(1) && desempate % a) Entran en conflicto, se desempata
        if mod(ganador1, 2) == 0 % Quito los que dan conflictos para comparar
            d1(2) = inf; d1(4) = inf;
        else
            d1(1) = inf; d1(3) = inf;
        end
        if mod(ganador2, 2) == 0 % Quito los que dan conflictos para comparar
            d2(2) = inf; d2(4) = inf;
        else
            d2(1) = inf; d2(3) = inf;
        end
        aux = ImgDes(:, UComp(1, :)); % Union con entrada
        [Minaux1, gaux1] = min(d1); puntoaux1 = [aux(mod(gaux1, 2) + 1, 1) aux(1 + (gaux1 > 2), 2)];
        aux = ImgDes(:, UComp(2, :)); % Union con salida
        [Minaux2, gaux2] = min(d2); puntoaux2 = [aux(mod(gaux2, 2) + 1, 1) aux(1 + (gaux2 > 2), 2)];

        if (Minaux1 - Min1) > (Minaux2 - Min2) % pierdo mas moviendo 1, asi que muevo 2.
            punto2 = puntoaux2;
        else
            punto1 = puntoaux1;
        end
    end
    % Anoto las dos uniones exteriores a hacer y el anclaje
    anclaje_ant = punto2(1);
    UDesaux(1, :) = punto1;

    [PtIR,ptIC] = find(ImgDes == punto1(1));
    Pt_final = ImgDes(mod(PtIR,2)+1, ptIC);% final de trayecto.
    if Pt_final == 0
        Pt_final = punto1(1); % si solo hay una ciudad
    end
    UDesaux(2, :) = punto2;

    %% Uniones entre conjuntos
    d1 = zeros(2, 1); % Le cambiamos el tamaño, mas ajustado
    for c = 2:size(UComp, 1)-2
        desempate = true;

        % Paso 2.- Hallar cual es el punto óptimo para unir el puente con
        % la entrada y con la salida
        %Cuidado que dedo tener un punto fijo.
        aux = ImgDes(:, UComp(c, :)); % Union con entrada
        if aux(2, 1) == 0 % en el caso de que haya 1 ciudad en un conjunto
            aux(2, 1) = aux(1,1);
        end
        if aux(2, 2) == 0
            aux(2, 2) = aux(1,2); desempate = false;
        end
        pE = CoordsDes(anclaje_ant, :); % Coordenadas del anclaje
        pP = CoordsDes(aux(:, 2), :); % "" del puente (segundo par)
        d1(1) = norm(pE' - pP(1, 1:end)');
        d1(2) = norm(pE' - pP(2, 1:end)');
        [~, ganador1] = min(d1); punto1 = [anclaje_ant aux(ganador1, 2)];


        aux = ImgDes(:, UComp(c+1, :)); % Union con salida
        if aux(2, 1) == 0 % en el caso de que haya 1 ciudad en un conjunto
            aux(2, 1) = aux(1,1);
        end
        if aux(2, 2) == 0
            aux(2, 2) = aux(1,2);
        end
        pS = CoordsDes(aux(:, 2), :); % Coordenadas de la salida (2º par)
        d2(1) = norm(pS(1, 1:end)' - pP(2, 1:end)');
        d2(2) = norm(pS(1, 1:end)' - pP(1, 1:end)');
        d2(3) = norm(pS(2, 1:end)' - pP(2, 1:end)');
        d2(4) = norm(pS(2, 1:end)' - pP(1, 1:end)');
        [~, ganador2] = min(d2); punto2 = [aux(mod(ganador2, 2) + 1, 1) aux(1 + (ganador2 > 2), 2)];

        % Se puede optimizar mas. Está mal.
        if punto1(2) == punto2(1) && desempate % a) Entran en conflicto, se desempata
            % Tengo que ver cuanto pierdo eligiendo el segundo mejor candidato
            % en cada caso, y coger aquel cambio que represente la menor
            % pérdida.
            if mod(ganador1, 2) == 0 % Quito los que dan conflictos para comparar
                d1(2) = inf;
            else
                d1(1) = inf;
            end
            if mod(ganador2, 2) == 0 % Quito los que dan conflictos para comparar
                d2(2) = inf; d2(4) = inf;
            else
                d2(1) = inf; d2(3) = inf;
            end
            aux = ImgDes(:, UComp(c, :)); % Union con entrada 
            [Minaux1, gaux1] = min(d1); puntoaux1 = [anclaje_ant aux(gaux1, 2)];
            aux = ImgDes(:, UComp(c+1, :)); % Union con salida
            [Minaux2, gaux2] = min(d2); puntoaux2 = [aux(mod(gaux2, 2) + 1, 1) aux(1 + (gaux2 > 2), 2)];

            if (Minaux1 - Min1) > (Minaux2 - Min2) % pierdo mas moviendo 1, asi que muevo 2.
                punto2 = puntoaux2;
            else
                punto1 = puntoaux1;
            end
        end
        % Paso 3.- Anotar las dos uniones exteriores a hacer
        anclaje_ant = punto2(1);
        %UDesaux(end+1, :) = punto1;
        UDesaux(end+1, :) = punto2;
        if any(punto1 ~= UDesaux(end-1, :))
            UDesaux(end-1, :) = punto1; %Se actualiza si es necesario
        end
    end
    [auxR, auxC] = find(ImgDes == UDesaux(end, 2), 1); %apaño
    %es que no puedo unir con el final del tiron si comparte conjunto.
    %Tendra que ser la otra del conjunto la que se una con el final.
    if ImgDes(mod(auxR,2)+1, auxC) ~= 0
        Ultima_union = ImgDes(mod(auxR,2)+1, auxC);
    else
        Ultima_union = UDesaux(end, 2);
    end
    UDesaux(end+1, :) = [Ultima_union Pt_final];

    % ----------------------------------------------------------------------------
    % Paso 4.- Por cada isla, apuntar dichas uniones
    %% Uniones dentro de conjuntos
    for i = 1:size(ImgDes, 2)
        Pareja = ImgDes(:, i); % Esto por la forma de Desenfocar.
        if Pareja(2) ~= 0 && Pareja(1) ~= 0 % Si no es una sola isla...
            UDesaux(end + 1, :) = Pareja';
        end
    end

    % Paso 5.- Reorganizar las uniones para que sigan el formato
    %% Reorganizar las uniones
    UDes = UDesaux(1, 1:end);%zeros(size(UDesaux)); % para evitar copias y translados
    UDesaux(1, 1:end) = zeros(1, 2);

    [row, col] = find(UDesaux == UDes(1, 2), 1);
    i = 2;
    while ~isempty(row)%i = 2:size(UDesaux, 1) % cantidad de ciudades
        if col == 2 % Hay que voltear para que siga la estructura
            UDes(i, 1:end) = flip(UDesaux(row, 1:end));
        else
            UDes(i, 1:end) = UDesaux(row, 1:end);
        end
        UDesaux(row, 1:end) = zeros(1, 2);
        i = i + 1;
        [row, col] = find(UDesaux == UDes(i-1, 2), 1);
    end
end
