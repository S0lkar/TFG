rng(0);
N = 100;

a = -50;
b = 50;
X = (b-a) .* rand(N, 1) + a; % Coordenadas X de las N ciudades
Y = (b-a) .* rand(N, 1) + a; % Coordenadas Y de las N ciudades

plot(Y, X, '.b');

Coordenadas = [X Y];
save("Coordenadas.mat", "Coordenadas");
savefig("Mapa.fig");