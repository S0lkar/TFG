
% Recibe un TSP del cual se ha realizado la asignación mínima.
% Por cada segmento que posee puntos interiores, lo optimiza frente al
% resto hasta alcanzar el mínimo global.
function [Indices, Len] = TAI(Coordenadas, Indices, Len)

    % Obtener qué segmentos son candidatos a repartirse puntos (ignorar los vacíos)
    L = 1:length(Len);
    L = L(Len > 2); % índices de los segmentos con puntos interiores

    % Obtener las distancias originales de cada segmento
    D = zeros(length(L), 1);
    for i = 1:length(D)
        ind = Obtener_Segmento(Indices, Len, L(i));
        Seg_vacio = norm(Coordenadas(:, ind(1))-Coordenadas(:, ind(end)))*2;
        EC = ind(convexHull(delaunayTriangulation(Coordenadas(1, ind)', Coordenadas(2, ind)')));
        D(i) = tLength(EC, Coordenadas) - Seg_vacio;
    end

    % Proceso principal
    while(~isempty(L))
        ind_act = L(1); L(1) = [];
        D_act = D(1); D(1) = [];
        Seg_act = Obtener_Segmento(Indices, Len, ind_act);
        
        % j = CogerOptimo(Seg_act, Indices, Len, L);
        j = L;

        hay_act = false;
        i = 1;
        while (i <= length(j)) && ~hay_act
            [ACTnew, Inew, D_Act, D_I, hay_act] = ProcesoAct(Coordenadas, Seg_act, Obtener_Segmento(Indices, Len, j(i)), D_act, D(i));
            if(hay_act)
                [Indices, Len] = Substituir_Segmento(Indices, Len, ACTnew, ind_act);
                [Indices, Len] = Substituir_Segmento(Indices, Len, Inew, j(i));
                L = [L ind_act];
                D(i) = D_I;
                D = [D; D_Act];
            end
            i = i + 1;
        end
    end
end

