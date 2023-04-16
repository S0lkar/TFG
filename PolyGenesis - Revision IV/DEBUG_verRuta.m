
% Las coordenadas tienen que estar en columna
% Puedo hacer otra versión copypasteada que tome las coordenadas de
% "instancias" y así sea mas sencillo representar cosas, pero vamos que es
% lo mismo.

% Las coordenadas en columnas!! 
function DEBUG_verRuta(ruta, C, pausar, verCamino)
    if size(C, 1) == 2 % Por si acaso está en fila
            C = C';
    end

    title("Ruta"); hold on; axis equal;

    for i = 1:length(ruta)
        plot(C(ruta(i), 1), C(ruta(i), 2), '.b');
    end

    if verCamino
        for i = 1:length(ruta)-1
            plot([C(ruta(i), 1) C(ruta(i+1), 1)], [C(ruta(i), 2) C(ruta(i+1), 2)], 'b');
        end
        plot([C(ruta(end), 1) C(ruta(1), 1)], [C(ruta(end), 2) C(ruta(1), 2)], 'b');
    end

    if(pausar)
        pause();
        close all
    end
end

