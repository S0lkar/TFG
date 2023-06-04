

load Co
C = Co;
R = PolyGrowth(C, false);
Env = convhulln(C); Env = uint64(Env(:, 1));
R = uint64(R)';
mC = creaMC(C);

R = TnsSup(R, flip(Env), mC);
fcost(R, mC)
plotAnillo(R, C, 'b');
