

%https://es.mathworks.com/matlabcentral/answers/277984-check-points-inside-triangle-or-on-edge-with-example
%https://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle
% - Puede que más eficiente?

%https://es.mathworks.com/matlabcentral/answers/687108-point-or-multiple-points-is-are-in-a-triangle
% - Lo más cómodo

%isinterior(polyshape(Triangle), Points);
%https://es.mathworks.com/help/matlab/ref/polyshape.isinterior.html
%https://es.mathworks.com/help/matlab/ref/polyshape.html


load testing.mat
%[xi, yi] = ginput(10);
%C = [xi, yi]';
isinterior(polyshape(C(:, [2 9 10])'), C(:, 1:8)');
DEBUG_verRuta(1:10, C, false);