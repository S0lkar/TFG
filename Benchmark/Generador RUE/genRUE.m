
rng(0);
nInstancias = 3150;
a = 1;  % range for RUE points.
b = 1000000;
RUE = cell(3150, 1);
for i = 1:nInstancias
    nPts = randi(100000); % Some big maps
    X = (b-a).* rand(nPts, 1) + a;
    Y = (b-a).*rand(nPts,1) + a;
    RUE{i} = [X Y];
end
save('RUE.mat', 'RUE', '-v7.3');