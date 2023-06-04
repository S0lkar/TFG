
nExp = 10000;
T = 0;

for i = 1:nExp
    tic
    R = PolyGrowth(Co, false);
    Env = convhulln(Co); Env = uint64(Env(:, 1));
    R = uint64(R)';
    mC = creaMC(Co);
    R = TnsSup(R, flip(Env), mC);
    T = T + toc;
end
disp("· T total: " + T);
disp("· T medio: " + T/nExp);