
function D = dists(Coords, Anillo)
    D = zeros(1, length(Anillo));
    for i = 1:length(Anillo)-1
        D(i) = d_euclid(Coords(:, Anillo(i)), Coords(:, Anillo(i+1)));
    end
    D(i+1) = d_euclid(Coords(:, Anillo(end)), Coords(:, Anillo(1)));
end

