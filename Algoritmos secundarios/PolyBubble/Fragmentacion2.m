
% Esta función puede añadir el punto a la EC bien sin necesidad de saber
% donde, porque lo va a deducir con los puntos desligados


% No está pillando bien los subconjuntos. No sabe realmente qué punto
% pillar cuando mira las cosas de los PI con la antigua EC.


function [C_S, I_S, C_EC, I_EC, C_PI, I_PI, C_Sub, I_Sub, Len] = Fragmentacion2(C_S, I_S, C_EC, I_EC, I_pt, C_pt)

    % 1.- Calcular la nueva EC y observar los puntos desligados (PI)
    C = [C_EC C_pt];
    I = [I_EC; I_pt];
    nueva_EC = convhulln(C');
    nueva_EC = nueva_EC(:, 1)';
    I = I(nueva_EC);
    C = C(:, nueva_EC);

    [val1, ind1] = setdiff(I, I_EC);
    [val2, ind2] = setdiff(I_EC, I);
    I_PI = [val1; val2];
    pos = find(I_PI == I_pt, 1);
    I_PI(pos) = []; % Es el punto recién incluido.
    if ~isempty(I_PI)
        C_PI = C_EC(:, [ind1; ind2]);
        C_PI(:, pos) = []; % Es el punto recién incluido.
    else
        C_PI = [];
    end

    % 2.- Obtener, a partir de los puntos desligados y el circuito, los
    % subconjuntos desligados (Sub) (y las coordenadas de todos esos puntos)
    C_Sub = []; I_Sub = []; Len = [];


    if isempty(I_PI) % comprobar solo puntos interiores. 0 o 1 subconjunto.
        pos = find(I == I_pt, 1); % ¿Donde hemos insertado el nuevo punto?
        ind_ant = I(mod(pos-2, length(I))+1);
        ind_pos = I(mod(pos, length(I))+1);
        pos_ini = find(I_S == ind_ant, 1); % Segmento que se verá afectado
        pos_fin = find(I_S == ind_pos, 1);
        if pos_ini > pos_fin
            tramo = [pos_ini+1:length(I_S) 1:pos_fin-1];
        else
            tramo = pos_ini+1:pos_fin-1;
        end
        if ~isempty(tramo) % Si hay un subconjunto, lo separamos
            I_Sub = I_S(tramo);
            C_Sub = C_S(:, tramo);
            Len = length(tramo);
            I_S(tramo) = [];
            C_S(:, tramo) = [];
        end %-----------------------------------------------------------------------------------
        pos = find(I == I_pt, 1); % ¿Donde insertamos el nuevo punto?
        ind_ant = I(mod(pos-2, length(I))+1);
        pos = find(I_S == ind_ant, 1);
        I_S = [I_S(1:pos); I_pt; I_S(pos+1:end)]; % Incluimos el punto nuevo
        C_S = [C_S(:, 1:pos) C_pt C_S(:, pos+1:end)];



    elseif length(I_PI) == 1 % Solo los lados del punto desligado
        pos = find(I_EC == I_PI, 1); % ¿Donde está ese punto?
        ind_ant = I_EC(mod(pos-2, length(I))+1);
        ind_pos = I_EC(mod(pos, length(I))+1);
        pos_ini = find(I_S == ind_ant, 1); % Segmentos que se verán afectados
        pos_med = find(I_S == I_EC(pos), 1);
        pos_fin = find(I_S == ind_pos, 1);

        % Primer tramo 
        if pos_ini > pos_med
            tramo1 = [pos_ini+1:length(I_S) 1:pos_med-1];
        else
            tramo1 = pos_ini+1:pos_med-1;
        end
        % Segundo tramo 
        if pos_med > pos_fin
            tramo2 = [pos_med+1:length(I_S) 1:pos_fin-1];
        else
            tramo2 = pos_med+1:pos_fin-1;
        end
        tramoT = [tramo1 pos_med tramo2];
        
        % Añadimos los subtramos, si hubieran, a los subconjuntos.
        if ~isempty(tramo1)
            I_Sub = I_S(tramo1);
            C_Sub = C_S(:, tramo1);
            Len = length(tramo1);
        end
        if ~isempty(tramo2)
            I_Sub = [I_Sub; I_S(tramo2)];
            C_Sub = [C_Sub C_S(:, tramo2)];
            Len = [Len length(tramo2)];
        end

        I_S(tramoT) = [];% Eliminamos los antiguos tramos
        C_S(:, tramoT) = [];
        pos_ini = find(I_S == ind_ant, 1); % cambió de posición
        I_S = [I_S(1:pos_ini); I_pt; I_S(pos_ini+1:end)]; % Incluimos el punto nuevo
        C_S = [C_S(:, 1:pos_ini) C_pt C_S(:, pos_ini+1:end)];




    else % recorrer el tramo entero. Hay que determinar en qué sentido (derecha o izquierda) se hace.

        % Primer tramo
        pos_primero = find(I_EC == I_PI(1), 1);
        es_anterior = find(I_EC(mod(pos_primero-2, length(I_EC))+1) == I, 1);
        if es_anterior
            ind = find(I_EC(mod(pos_primero-2, length(I_EC))+1) == I_S, 1);
            sentido = true; % Hacia la derecha
        else % es el posterior
            ind = find(I_EC(mod(pos_primero, length(I_EC))+1) == I_S, 1);
            sentido = false; % Hacia la izquierda
        end
        
        if sentido % Lo recorremos hacia la derecha --------------------

            pos_inicio_recorte = ind;
            ind_sig = find(I_S == I_PI(1), 1);
            if ind > ind_sig % pasa por el final del vector
                tramo = [ind+1:length(I_S) 1:ind_sig-1];
            else
                tramo = ind+1:ind_sig-1;
            end
            if ~isempty(tramo) % Hay un subconjunto que registrar
                I_Sub = I_S(tramo);
                C_Sub = C_S(:, tramo);
                Len = length(tramo);
            end
            % Tramos intermedios
            for i = 1:length(I_PI)-1
                ind = ind_sig;
                ind_sig = find(I_S == I_PI(i+1), 1); % dos puntos de la antigua EC
                if ind > ind_sig % pasa por el final del vector
                    tramo = [ind+1:length(I_S) 1:ind_sig-1];
                else
                    tramo = ind+1:ind_sig-1;
                end
                if ~isempty(tramo) % Hay un subconjunto que registrar
                    I_Sub = [I_Sub; I_S(tramo)]; %#ok<AGROW> 
                    C_Sub = [C_Sub C_S(:, tramo)]; %#ok<AGROW> 
                    Len = [Len length(tramo)]; %#ok<AGROW> 
                end
            end
        
            % Ultimo tramo
            ind = ind_sig;
            % punto de la EC siguiente al que se conecta el nuevo
            pos_ultimo = find(I_EC == I_PI(end), 1);
            ind_sig = find(I_EC(mod(pos_primero, length(I_EC))+1) == I_S, 1);
            
            
            pos_fin_recorte = ind_sig;
            if ind > ind_sig % pasa por el final del vector
                tramo = [ind+1:length(I_S) 1:ind_sig-1];
            else
                tramo = ind+1:ind_sig-1;
            end
            if ~isempty(tramo) % Hay un subconjunto que registrar
                I_Sub = [I_Sub; I_S(tramo)];
                C_Sub = [C_Sub C_S(:, tramo)];
                Len = [Len length(tramo)];
            end
            if pos_inicio_recorte > pos_fin_recorte  % pasa por el final del vector
                tramo = [pos_inicio_recorte+1:length(I_S) 1:pos_fin_recorte-1];
            else
                tramo = pos_inicio_recorte+1:pos_fin_recorte-1;
            end

            I_S(tramo) = [];
            C_S(:, tramo) = [];
            pos = find(I == I_pt, 1); % ¿Donde insertamos el nuevo punto?
            ind_ant = I(mod(pos-2, length(I))+1);
            pos = find(I_S == ind_ant, 1);
            I_S = [I_S(1:pos); I_pt; I_S(pos+1:end)];
            C_S = [C_S(:, 1:pos) C_pt C_S(:, pos+1:end)];


        else % Lo recorremos hacia la izquierda   --------------------

            pos_inicio_recorte = ind;
            ind_sig = find(I_S == I_PI(1), 1);
            if ind < ind_sig % pasa por el final del vector
                tramo = [ind_sig+1:length(I_S) 1:ind-1];
            else
                tramo = ind_sig+1:ind-1;
            end
            if ~isempty(tramo) % Hay un subconjunto que registrar
                I_Sub = I_S(tramo);
                C_Sub = C_S(:, tramo);
                Len = length(tramo);
            end
            % Tramos intermedios
            for i = 1:length(I_PI)-1
                ind = ind_sig;
                ind_sig = find(I_S == I_PI(i+1), 1); % dos puntos de la antigua EC
                if ind < ind_sig % pasa por el final del vector
                    tramo = [ind_sig+1:length(I_S) 1:ind-1];
                else
                    tramo = ind_sig+1:ind-1;
                end
                if ~isempty(tramo) % Hay un subconjunto que registrar
                    I_Sub = [I_Sub; I_S(tramo)]; %#ok<AGROW> 
                    C_Sub = [C_Sub C_S(:, tramo)]; %#ok<AGROW> 
                    Len = [Len length(tramo)]; %#ok<AGROW> 
                end
            end
        
            % Ultimo tramo
            ind = ind_sig;
            % punto de la EC siguiente al que se conecta el nuevo
            pos_ultimo = find(I_EC == I_PI(end), 1);
            ind_sig = find(I_EC(mod(pos_ultimo-2, length(I_EC))+1) == I_S, 1);
            
            pos_fin_recorte = ind_sig;
            if ind < ind_sig % pasa por el final del vector
                tramo = [ind_sig+1:length(I_S) 1:ind-1];
            else
                tramo = ind_sig+1:ind-1;
            end
            if ~isempty(tramo) % Hay un subconjunto que registrar
                I_Sub = [I_Sub; I_S(tramo)];
                C_Sub = [C_Sub C_S(:, tramo)];
                Len = [Len length(tramo)];
            end
        
            if pos_fin_recorte > pos_inicio_recorte  % pasa por el final del vector
                tramo = [pos_fin_recorte+1:length(I_S) 1:pos_inicio_recorte-1];
            else
                tramo = pos_fin_recorte+1:pos_inicio_recorte-1;
            end

            I_S(tramo) = [];
            C_S(:, tramo) = [];
            pos = find(I == I_pt, 1); % ¿Donde insertamos el nuevo punto?
            ind_ant = I(mod(pos-2, length(I))+1);
            pos = find(I_S == ind_ant, 1);
            I_S = [I_S(1:pos); I_pt; I_S(pos+1:end)];
            C_S = [C_S(:, 1:pos) C_pt C_S(:, pos+1:end)];

        end % FIN ---------------
    end
    I_EC = I; % Actualizamos la envolvente convexa
    C_EC = C;
end

