
% Calcula la ganancia de perímetro del polígono al incluir el punto B en la arista AC. 
% Importante que las coordenadas estén en vertical para no hacer traspuestas
function G = Ganancia(Coord_a, Coord_b, Coord_c)
    G = norm(Coord_a - Coord_b) + norm(Coord_b - Coord_c) - norm(Coord_a - Coord_c);
end

% Comprobado usando;
% a = [1 2; 1 3; 1 4];
% Ganancia(a(1, :)', a(2, :)', a(3, :)')
% OR: a = a'; Ganancia(a(:, 1), a(:, 2), a(:, 3));

% ans =

%      0