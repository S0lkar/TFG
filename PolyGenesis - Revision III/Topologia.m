% Topologia identifica las diferentes envolventes convexas que conforman el mapa 
% de coordenadas dado, y devuelve los índices que corresponde a cada anillo. 
% Los anillos están ordenados por orden de aparición (capa más externa a capa más interna)

% N es la cantidad de capas
% Len indica la longitud de cada capa. La última siempre refiere a los
% puntos sueltos (si no hay, Len(end) == 0).
function [Indices, Len, N] = Topologia(Coordenadas, I)
    N = 1;
    Indices = [];
    Len = [];
    while (length(Coordenadas) > 3)
      Anillo = convhulln(Coordenadas); 
      Anillo = Anillo(:, 1)';

      Indices = [Indices; I(Anillo)]; %#ok<AGROW>
      Len(N) = length(Anillo); %#ok<AGROW> 
      N = N + 1;

      Coordenadas(Anillo, :) = [];
      I(Anillo) = [];
    end
    Indices = [Indices; I];
    Len(N) = size(Coordenadas, 1);
end