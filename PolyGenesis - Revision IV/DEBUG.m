
%Ci = [0 0; 0 0.5; 1 1; 1 0; 0 1; 0.839457 0; 0.00001 0];
%[x, y] = ginput(8);
%C = [Ci; [x y]];
load C.mat

anillo = convexHull(delaunayTriangulation(C(:,1), C(:, 2)));

%DEBUG_verRuta(anillo(:, 1), C, false, false);
figure,
%DEBUG_verRuta(1:length(C), C, false, false);

TSP = PolyGenesis(C', []);
DEBUG_verRuta(TSP, C, false, true);