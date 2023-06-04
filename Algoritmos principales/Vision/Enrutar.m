
function ruta = Enrutar(data)
%ruta = ENRUTAR(data); Transforma la representación de la ruta.
%  data: matriz de nx2, con las parejas de transiciones (a -> b; b -> c...)
%  ruta: vector de n ciudades (a -> b -> c -> d ...)
    ruta = zeros(1, length(data));%+1);
    for i = 1:length(data)
        ruta(i) = data(1, i);
    end
    %ruta(i+1) = data(2, i);
end