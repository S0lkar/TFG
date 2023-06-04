
% Calcula la distancia de un set de puntos a una recta que contiene a v1 y v2.
% El set va 'en horizontal' [x1 y1; x2 y2; ...]
% https://es.mathworks.com/matlabcentral/fileexchange/64396-point-to-line-distance
function d = dist_Set2Line(pt, v1, v2)
    v1 = [v1 0];
    v2 = [v2 0];
    pt = [pt zeros(size(pt, 1), 1)];
    v1_ = repmat(v1, size(pt,1), 1);
    v2_ = repmat(v2, size(pt,1), 1);
    % actual calculation
    a = v1_ - v2_;
    b = pt  - v2_;
    d = sqrt(sum(cross(a,b,2).^2,2)) ./ sqrt(sum(a.^2,2));
end