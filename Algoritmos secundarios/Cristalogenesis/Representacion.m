function Representacion(Coordenadas, mejor_ruta)
    if size(Coordenadas, 1) == 2 % Por si acaso está en fila
        Coordenadas = Coordenadas';
    end
    plot(Coordenadas(:, 1), Coordenadas(:, 2), '.r'); hold on;
    plot(Coordenadas(mejor_ruta, 1), Coordenadas(mejor_ruta, 2), 'b');
    plot(Coordenadas(mejor_ruta([end 1]), 1), Coordenadas(mejor_ruta([end 1]), 2), 'b');
    axis([0 1 0 1]);

    Anillo = convhulln(Coordenadas); Anillo = Anillo(:, 1)';
    plot(Coordenadas(Anillo, 1), Coordenadas(Anillo, 2), 'k'); 
    plot(Coordenadas(Anillo([end 1]), 1), Coordenadas(Anillo([end 1]), 2), 'k'); hold off;

    %save('mejor_ruta.mat', 'mejor_ruta');
    %savefig('mapaGen.fig');
end

