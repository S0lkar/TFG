

% No es para nada necesario los argumentos que no sean las coordenadas,
% pero por si me apetece usarlas para comprobar. Van en columna. (1:22)'
function [Indices, Len, N] = DEBUG_verTopologia(Coordenadas, I)
    N = 1;
    Indices = [];
    Len = [];
    hold on; axis equal;
    while (length(Coordenadas) > 3)
      Anillo = convhulln(Coordenadas); 
      Anillo = Anillo(:, 1)';

      Indices = [Indices; I(Anillo)];
      Len(N) = length(Anillo);
      N = N + 1;

      plot(Coordenadas(Anillo, 1), Coordenadas(Anillo, 2), '.b');
      pause();
      Coordenadas(Anillo, :) = [];
      I(Anillo) = [];
    end
    Indices = [Indices; I];
    Len(N) = size(Coordenadas, 1);
end

