function Coordenadas = plotAnillo(Anillo, Coordenadas, color)
    AnilloAux = [Anillo Anillo(1)];
    plot(Coordenadas(:, 1), Coordenadas(:, 2), '.b'); hold on;
    plot(Coordenadas(AnilloAux, 1), Coordenadas(AnilloAux, 2), color);
    %axis("tight"); hold off;
    axis([-25 25 -25 25]); %hold off;
    pause();
end

