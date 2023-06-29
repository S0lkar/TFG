
% Esta función puede añadir el punto a la EC bien sin necesidad de saber
% donde, porque lo va a deducir con los puntos desligados


% No está pillando bien los subconjuntos. No sabe realmente qué punto
% pillar cuando mira las cosas de los PI con la antigua EC.


function [C_S, I_S, C_EC, I_EC, C_PI, I_PI, C_Sub, I_Sub, Len] = Fragmentacion(C_S, I_S, C_EC, I_EC, I_pt, C_pt)

    % 1.- Calcular la nueva EC y observar los puntos desligados (PI)
    C = [C_EC C_pt];
    I = [I_EC; I_pt];
    nueva_EC = convhulln(C');
    nueva_EC = nueva_EC(:, 1)';
    I = I(nueva_EC);
    pos_pt = find(I == I_pt, 1);
    C = C(:, nueva_EC);

    I_PI = [setdiff(I, I_EC); setdiff(I_EC, I)];
    I_PI(I_PI == I_pt) = []; % Es el punto recién incluido.

    if ~isempty(I_PI) % En el caso de que hayan puntos desligados...

    % 2.- Obtener, a partir de los puntos desligados y el circuito, los
    % subconjuntos desligados (Sub) (y las coordenadas de todos esos puntos)
    C_PI = zeros(2, length(I_PI));
    I_Sub = [];
    C_Sub = [];
    Len = [];
    % Caso 1º
    % usando la EC antigua, ver si hay un subconjunto suelto
    ind = find(I_S == I(mod(pos_pt-2, length(I))+1), 1); % punto de la EC anterior al que se conecta el nuevo
    pos_inicio_recorte = ind;
    ind_sig = find(I_S == I_PI(1), 1);
    if ind > ind_sig
        tramo = [(ind+1:length(I_S)) 1:ind_sig-1];
    else
        tramo = ind+1:ind_sig-1;
    end
    if ~isempty(tramo) % Hay un subconjunto que registrar
        I_Sub = I_S(tramo);
        C_Sub = C_S(:, tramo);
        Len = length(tramo);
    end

    % Caso promedio
    for i = 1:length(I_PI)-1
        ind = ind_sig;
        ind_sig = find(I_S == I_PI(i+1), 1); % dos puntos de la antigua EC
        C_PI(:, i) = C_S(:, ind);
        if ind > ind_sig
            tramo = [(ind+1:length(I_S)) 1:ind_sig-1];
        else
            tramo = ind+1:ind_sig-1;
        end
        if ~isempty(tramo) % Hay un subconjunto que registrar
            I_Sub = [I_Sub; I_S(tramo)]; %#ok<AGROW> 
            C_Sub = [C_Sub C_S(:, tramo)]; %#ok<AGROW> 
            Len = [Len length(tramo)]; %#ok<AGROW> 
        end
    end
    C_PI(:, end) = C_S(:, ind_sig);

    % Caso ultimo
    % usando la EC antigua, ver si hay un subconjunto suelto
    ind = ind_sig;
    ind_sig = find(I_S == I(mod(pos_pt, length(I))+1), 1);% punto de la EC siguiente al que se conecta el nuevo
    pos_fin_recorte = ind_sig;
    if ind > ind_sig
        tramo = [(ind+1:length(I_S)) 1:ind_sig-1];
    else
        tramo = ind+1:ind_sig-1;
    end
    if ~isempty(tramo) % Hay un subconjunto que registrar
        I_Sub = [I_Sub; I_S(tramo)];
        C_Sub = [C_Sub C_S(:, tramo)];
        Len = [Len length(tramo)];
    end


    % 3.- Unir el nuevo punto en el circuito y quitar los puntos y 
    % subconjuntos desligados (PI y Sub)
    I_EC = I;
    C_EC = C;
    tramo = pos_inicio_recorte+1:pos_fin_recorte-1;
    if isempty(tramo) % Tenemos en cuenta que el vector es circular
        I_S(pos_inicio_recorte+1:end) = [];
        I_S(1:pos_fin_recorte-1) = [];
        C_S(:, pos_inicio_recorte+1:end) = [];
        C_S(:, 1:pos_fin_recorte-1) = [];
        I_S = [I_S; I_pt];
        C_S = [C_S C_pt];
    else
        I_S(tramo) = [];
        C_S(:, tramo) = [];
        I_S = [I_S(1:pos_inicio_recorte); I_pt; I_S(pos_inicio_recorte+1:end)];
        C_S = [C_S(:, 1:pos_inicio_recorte) C_pt C_S(:, pos_inicio_recorte+1:end)];
    end
    
    else % En el caso de no que hayan puntos desligados...
        C_PI = [];
        C_Sub = []; I_Sub = []; Len = [];
        C_EC = C; I_EC = I;
        pos = find(I == I_pt, 1); % Dónde se incluyó el punto nuevo en la EC
        pos = find(I_S == I(pos-1), 1); % Dónde tenemos que incluirlo en el circuito
        I_S = [I_S(1:pos); I_pt; I_S(pos+1:end)];
        C_S = [C_S(:, 1:pos) C_pt C_S(:, pos+1:end)];
    end
end

